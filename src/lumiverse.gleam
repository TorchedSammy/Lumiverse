import gleam/uri
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html

import lumiverse/models/series as series_model

import lumiverse/layout
import lumiverse/router
import lumiverse/pages/home
import lumiverse/pages/series as series_page
import lumiverse/pages/auth

pub fn main() {
	let app = lustre.application(init, update, view)
	let assert Ok(_) = lustre.start(app, "#app", 0)
}

// Model with Route
type Model {
	Model(route: router.Route)
}

fn init(_) {
	#(Model(router.Home), router.init())
}

fn update(model: Model, msg: layout.Msg) -> #(Model, Effect(layout.Msg)) {
	case msg {
		layout.Router(router.ChangeRoute(route)) -> #(Model(route), effect.none())
		layout.Router(router.NoOp) -> #(model, effect.none())
		layout.AuthPage(_) -> #(model, effect.none())
	}
}

fn view(model: Model) -> Element(layout.Msg) {
	case model.route {
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
}
