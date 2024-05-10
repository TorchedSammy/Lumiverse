import gleam/option
import gleam/result
import gleam/io
import gleam/uri
import juno
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import modem

import localstorage
import router as router_handler

import lumiverse/api/api
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

// Model with Route
type Model {
	Model(route: router.Route, user: option.Option(api.User))
}

fn init(_) {
	let kavita_user = localstorage.read("kavita_user")
	let user = case kavita_user {
		Ok(jsondata) -> {
			let user = case api.login_from_json(jsondata) {
				_ -> todo as "this is the wrong type"
			}
			option.Some(result.unwrap(user, api.Username("")))
		}
		Error(_) -> option.None
	}
	io.debug(user)
	io.debug(get_route())

	#(Model(router_handler.uri_to_route(get_route()), user), modem.init(on_url_change))
}


fn on_url_change(uri: uri.Uri) -> layout.Msg {
	router_handler.uri_to_route(uri) |> router.ChangeRoute |> layout.Router
}

@external(javascript, "./router.ffi.mjs", "get_current_href")
fn get_route() -> uri.Uri {}

fn update(model: Model, msg: layout.Msg) -> #(Model, Effect(layout.Msg)) {
	case msg {
		layout.Router(router.ChangeRoute(route)) -> #(Model(route, model.user), effect.none())
		layout.AuthPage(auth_model.LoginSubmitted) -> {
			io.println("submitted")
			#(model, effect.none())
		}
		layout.AuthPage(_) -> #(model, effect.none())
	}
}

fn view(model: Model) -> Element(layout.Msg) {
	let page = case model.route {
		router.Home -> home.page()
		router.Login -> auth.login()
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
		router.NotFound -> page
		_ -> html.div([], [
			layout.nav(model.user),
			page,
		])
	}
}
