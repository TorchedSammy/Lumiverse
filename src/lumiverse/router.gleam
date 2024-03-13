import wisp.{type Request, type Response}
import gleam/string_builder
import lustre/attribute
import lustre/element
import lustre/element/html
import lumiverse/web
import lumiverse/models/series

import lumiverse/layout
import lumiverse/pages/home
//import lumiverse/pages/blog
import lumiverse/pages/not_found
import lumiverse/pages/series as series_page

pub fn handle_request(req: Request) -> Response {
	use req <- web.middleware(req)

	let dosanko = series.Manga(
		slug: "dosanko-gal-wa-namaramenkoi",
		name: "Hokkaido Gals Are Super Adorable!",
		image: "https://mangadex.org/covers/d8323b7b-9a7a-462b-90f0-2759fed52511/5c2ffa99-be9e-4a75-8823-320b6e4ce7c7.png"
	)
	case wisp.path_segments(req) {
		[] -> create_page(home.page())

		["series", id] -> create_page(series_page.page(dosanko))

		_ -> fullpage(not_found.page()) |> wisp.html_response(404)
	}
}

fn fullpage(page: element.Element(Nil)) -> string_builder.StringBuilder {
	html.html([attribute.attribute("data-theme", "dark")], [
		layout.head(),
		html.body([], [
			layout.nav(),
			page,
		//	layout.footer()
		]),
	])
	|> element.to_string_builder
	|> string_builder.prepend("<!DOCTYPE html>")
}

pub fn create_page(page: element.Element(Nil)) -> Response {
	fullpage(page)
	|> wisp.html_response(200)
}
