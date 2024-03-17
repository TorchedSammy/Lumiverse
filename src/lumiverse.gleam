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

import localstorage
import router as router_handler

import lumiverse/api/api
import lumiverse/models/series as series_model
import lumiverse/models/router
import lumiverse/layout
import lumiverse/pages/home
import lumiverse/pages/series as series_page
import lumiverse/pages/auth

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

	#(Model(router.Home, user), router_handler.init())
}

fn update(model: Model, msg: layout.Msg) -> #(Model, Effect(layout.Msg)) {
	case msg {
		layout.Router(router.ChangeRoute(route)) -> #(Model(route, model.user), effect.none())
		layout.Router(router.NoOp) -> #(model, effect.none())
		layout.AuthPage(_) -> #(model, effect.none())
	}
}

fn view(model: Model) -> Element(layout.Msg) {
	let page = case model.route {
		router.Home -> home.page()
		router.Login -> auth.login()
		router.Series(id) -> {
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
						genres: ["Adventure", "Drama", "Fantasy", "Slice of Life"]
					)

					series_page.page(frieren)
				}
				_ -> element.text("Not found!")
			}
		}
		router.NotFound -> element.text("Not found!")
	}

	html.div([], [
		layout.nav(model.user),
		page,
		layout.footer()
	])
}
