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
		router.Login -> element.text("At Login!")
		router.Series(id) -> {
			// this is just a test case,
			// on request series should be fetched from kavita
			case id {
				"dosanko-gal-wa-namaramenkoi" -> {
					let dosanko = series_model.Manga(
						id: "dosanko-gal-wa-namaramenkoi",
						name: "Hokkaido Gals Are Super Adorable!",
						image: "https://lumiverse.sammyette.party/api/image/series-cover?seriesId=289&apiKey=7c3bb00c-629e-4829-8c50-7dd3b73fc846"
					)

					series_page.page(dosanko)
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
