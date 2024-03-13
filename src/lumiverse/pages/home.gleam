import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/elements/series
import lumiverse/models/series as series_model

pub fn page() -> element.Element(Nil) {
	let dosanko = series_model.Manga(
		slug: "dosanko-gal-wa-namaramenkoi",
		name: "Hokkaido Gals Are Super Adorable!",
		image: "https://mangadex.org/covers/d8323b7b-9a7a-462b-90f0-2759fed52511/5c2ffa99-be9e-4a75-8823-320b6e4ce7c7.png"
	)

	html.main([attribute.class("container")], [
		html.section([], [
			html.h1([], [element.text("Latest Updates")]),
			series.card(dosanko)
		])
	])
}

//fn hero_card()
