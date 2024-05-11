import gleam/dict
import gleam/option
import gleam/result
import gleam/list
import gleam/int
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
import lumiverse/api/series as series_req
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
			case api.decode_login_json(jsondata) {
				Ok(user) -> option.Some(user)
				Error(_) -> {
					localstorage.remove("kavita_user")
					option.None
				}
			}
		}
		Error(_) -> option.None
	}
	io.debug(user)
	io.debug(get_route())

	let route = router_handler.uri_to_route(get_route())
	let model = model.Model(
		route: route,
		user: user,
		auth: model.AuthModel(
			auth_message: "",
			user_details: auth_model.LoginDetails("", "")
		),
		home: model.HomeModel(
			carousel: [],
			carousel_smalldata: []
		),
		metadatas: dict.new(),
		series: dict.new(),
		viewing_series: option.None
	)

	#(model, effect.batch([modem.init(on_url_change), route_effect(model, route)]))
}


fn on_url_change(uri: uri.Uri) -> layout.Msg {
	router_handler.uri_to_route(uri) |> router.ChangeRoute |> layout.Router
}

@external(javascript, "./router.ffi.mjs", "get_current_href")
fn get_route() -> uri.Uri {}

fn homepage_display(user: option.Option(auth_model.User)) -> Effect(layout.Msg) {
	io.println("im here")
	case user {
		option.None -> {
		io.println("nope")
			effect.none()
		}
		option.Some(user) -> {
			io.println("getting recently added")
			series_req.recently_added(user.token)
		}
	}
}

fn route_effect(model: model.Model, route: router.Route) -> Effect(layout.Msg) {
	let eff = case route {
		router.Home -> homepage_display(model.user)
		router.Logout -> {
			localstorage.remove("kavita_user")
			let assert Ok(home) = uri.parse("/")
			modem.load(home)
		}
		router.Series(id) -> case model.user {
			option.None -> {
			io.println("no siri")
				effect.none()
			}
			option.Some(user) -> {
				io.println("getting serie")
				let id_parsed = int.base_parse(id, 10)
				case id_parsed {
					Ok(id_int) -> effect.batch([series_req.series(id_int, user.token), series_req.metadata(id_int, user.token)])
					Error(_) -> effect.from(fn(dispatch) { router.NotFound |> router.ChangeRoute |> layout.Router |> dispatch})
				}
			}
		}
		_ -> effect.none()
	}
}

fn update(model: model.Model, msg: layout.Msg) -> #(model.Model, Effect(layout.Msg)) {
	case msg {
		layout.Router(router.ChangeRoute(route)) -> {
			#(model.Model(..model, route: route), route_effect(model, route))
		}
		layout.HomeRecentlyAddedUpdate(Ok(series)) -> {
			case model.user {
				option.Some(user) -> {
					let metadata_fetchers = list.map(series, fn(s: series_model.MinimalInfo) {
						series_req.metadata(s.id, user.token)
					})
					let new_series = dict.from_list(list.map(series, fn(s: series_model.MinimalInfo) {
						#(s.id, s)
					}))
					|> dict.merge(model.series)
					#(model.Model(..model, home: model.HomeModel(..model.home, carousel_smalldata: series), series: new_series), effect.batch(metadata_fetchers))
				}
				option.None -> #(model, effect.none())
			}
		}
		layout.HomeRecentlyAddedUpdate(Error(e)) -> {
			io.println("failure")
			io.debug(e)
			#(model, effect.none())
		}
		layout.SeriesRetrieved(maybe_serie) -> {
			#(model.Model(
				..model,
				viewing_series: option.Some(maybe_serie)
			), effect.none())
		}
		layout.SeriesMetadataRetrieved(Ok(metadata)) -> {
			#(model.Model(..model, metadatas: model.metadatas |> dict.insert(metadata.id, metadata)), effect.none())
		}
		layout.SeriesMetadataRetrieved(Error(e)) -> {
			io.println("metadata fetch failed")
			io.debug(e)
			#(model, effect.none())
		}
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
			localstorage.write("kavita_user", api.encode_login_json(user))
			#(model.Model(..model, user: option.Some(user)), modem.load(home))
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
		router.Home -> home.page(model)
		router.Login -> auth.login(model)
		router.Logout -> auth.logout()
		router.Series(id) -> series_page.page(model)
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
