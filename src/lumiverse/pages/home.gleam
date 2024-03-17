import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/layout
import lumiverse/elements/series
import lumiverse/models/series as series_model

pub fn page() -> element.Element(layout.Msg) {
	let frieren = series_model.Manga(
						id: "sousou-no-frieren",
						name: "Sousou no Frieren",
						image: "https://mangadex.org/covers/b0b721ff-c388-4486-aa0f-c2b0bb321512/425098a9-e052-4fea-921d-368252ad084e.jpg",
						artists: ["Abe Tsukasa"],
						authors: ["Yamada Kanehito"],
						description: "",
						genres: ["Adventure", "Drama", "Fantasy", "Slice of Life"]
					)

	html.main([attribute.class("container")], [
		html.section([], [
			html.h1([], [element.text("Latest Updates")]),
			series.card(frieren)
		])
	])
}

//fn hero_card()
