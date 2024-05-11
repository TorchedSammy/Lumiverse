import gleam/option
import gleam/result
import gleam/io
import gleam/javascript/promise
import gleam/uri
import juno
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre_http as http
import modem

import localstorage
import router as router_handler

import lumiverse/api/api
import lumiverse/model
import lumiverse/models/series as series_model
import lumiverse/models/auth as auth_model
import lumiverse/models/router
import lumiverse/layout
import lumiverse/pages/home
import lumiverse/pages/series as series_page
import lumiverse/pages/auth
import lumiverse/pages/not_found

pub fn main() {
	let app = lustre.application(init, update, view)
	let assert Ok(_) = lustre.start(app, "#app", 0)
}

fn init(_) {
	let kavita_user = localstorage.read("kavita_user")
	let user = case kavita_user {
		Ok(jsondata) -> {
			option.Some(api.decode_login_json(jsondata))
		}
		Error(_) -> option.None
	}
	io.debug(user)
	io.debug(get_route())

	#(model.Model(
		route: router_handler.uri_to_route(get_route()),
		user: user,
		auth: model.AuthModel(
			auth_message: "",
			user_details: auth_model.LoginDetails("", "")
		)
	), modem.init(on_url_change))
}


fn on_url_change(uri: uri.Uri) -> layout.Msg {
	router_handler.uri_to_route(uri) |> router.ChangeRoute |> layout.Router
}

@external(javascript, "./router.ffi.mjs", "get_current_href")
fn get_route() -> uri.Uri {}

fn update(model: model.Model, msg: layout.Msg) -> #(model.Model, Effect(layout.Msg)) {
	case msg {
		layout.Router(router.ChangeRoute(route)) -> #(model.Model(..model, route: route), effect.none())
		layout.AuthPage(auth_model.LoginSubmitted) -> {
			#(model, api.login(model.auth.user_details.username, model.auth.user_details.password))
		}
		layout.AuthPage(auth_model.UsernameUpdated(username)) -> {
			#(model.Model(..model, auth: model.AuthModel(..model.auth, user_details: auth_model.LoginDetails(..model.auth.user_details, username: username))), effect.none())
		}
		layout.AuthPage(auth_model.PasswordUpdated(password)) -> {
			#(model.Model(..model, auth: model.AuthModel(..model.auth, user_details: auth_model.LoginDetails(..model.auth.user_details, password: password))), effect.none())
		}
		layout.AuthPage(auth_model.AuthMessage(message)) -> {
			io.println("im infected")
			#(model.Model(..model, auth: model.AuthModel(..model.auth, auth_message: message)), effect.none())
		}
		layout.AuthPage(_) -> #(model, effect.none())
		layout.LoginGot(Ok(user)) -> {
			io.println("we got a user!")
			let assert Ok(home) = uri.parse("/")
			#(model.Model(..model, user: option.Some(user)), effect.from(fn(dispatch) {
				localstorage.write("kavita_user", api.encode_login_json(user))
				router.ChangeRoute(router.Home) |> layout.Router |> dispatch
			}))
		}
		layout.LoginGot(Error(e)) -> {
			io.println("this is sad")
			let eff = case e {
				http.Unauthorized -> {
					io.println("not authorized??")
					effect.from(fn(dispatch) {
						"Incorrect username or password"
						|> auth_model.AuthMessage
						|> layout.AuthPage
						|> dispatch
					})
				}
				_ -> effect.none()
			}

			#(model, eff)
		}
	}
}

fn view(model: model.Model) -> Element(layout.Msg) {
	let page = case model.route {
		router.Home -> home.page()
		router.Login -> auth.login(model)
		router.Logout -> auth.logout()
		router.Series(id) -> {
			io.println(id)
			// this is just a test case,
			// on request series should be fetched from kavita
			case id {
				"sousou-no-frieren" -> {
					let frieren = series_model.Manga(
						id: "sousou-no-frieren",
						name: "Sousou no Frieren",
						image: "https://mangadex.org/covers/b0b721ff-c388-4486-aa0f-c2b0bb321512/425098a9-e052-4fea-921d-368252ad084e.jpg",
						artists: ["Abe Tsukasa"],
						authors: ["Yamada Kanehito"],
						description: "",
						genres: ["Adventure", "Drama", "Fantasy", "Slice of Life"],
						tags: [],
						publication: series_model.Ongoing
					)

					series_page.page(frieren)
				}
				_ -> not_found.page()
			}
		}
		router.NotFound -> not_found.page()
	}

	case model.route {
		router.Login -> page
		router.Logout -> page
		router.NotFound -> page
		_ -> html.div([], [
			layout.nav(model.user),
			page,
		])
	}
}
