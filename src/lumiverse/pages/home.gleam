import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/layout
import lumiverse/elements/series
import lumiverse/models/series as series_model

pub fn page() -> element.Element(layout.Msg) {
	let dosanko = series_model.Manga(
		id: "dosanko-gal-wa-namaramenkoi",
		name: "Hokkaido Gals Are Super Adorable!",
		image: "https://lumiverse.sammyette.party/api/image/series-cover?seriesId=289&apiKey=7c3bb00c-629e-4829-8c50-7dd3b73fc846"
	)

	html.main([attribute.class("container")], [
		html.section([], [
			html.h1([], [element.text("Latest Updates")]),
			series.card(dosanko)
		])
	])
}

//fn hero_card()
