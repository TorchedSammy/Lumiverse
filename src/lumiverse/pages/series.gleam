import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/models/series
import lumiverse/elements/tagbadge
import lumiverse/elements/chapter

pub fn page(srs: series.Series) -> element.Element(Nil) {
	html.main([attribute.class("container series-page")], [
		html.div([], [
			html.div([attribute.class("series-bg-image"), attribute.style([
				#("background-image", "url('" <> srs.image <> "')")
			])], []),
			html.div([attribute.attribute("loading", "lazy"), attribute.class("series-bg-image"), attribute.style([
				#("background", "linear-gradient(67.81deg,rgba(0,0,0,.64) 35.51%,transparent)"),
				#("backdrop-filter", "blur(4px)")
			])], [])
		]),
		html.div([attribute.class("container grid flex")], [
			html.img([
				attribute.attribute("loading", "lazy"),
				attribute.src(srs.image),
				attribute.style([#("border-radius", "var(--pico-border-radius)")])
			]),
			html.div([attribute.class("grid col-1"), attribute.style([
					//#("grid-template-rows", "auto 1fr")
			])], [
				html.div([attribute.class("flex col-1 gy-0"), attribute.style([
					#("min-height", "10rem"),
				])], [
					html.h1([attribute.class("mb-0")], [element.text(srs.name)]),
					html.span([], [element.text(srs.name)]),
					html.div([attribute.style([
						#("flex-grow", "1")
					])], []),
					html.span([], [element.text("Ikada Kai")]),
				]),
				html.div([attribute.class("grid col-1")], [
					html.div([attribute.class("grid"), attribute.style([
						#("display", "inline-flex")
					])], [
						html.button([], [element.text("Start Reading")]),
						html.button([attribute.class("secondary")], [
							html.span([attribute.class("icon-star-o")], [])
						]),
					]),
					html.div([], [
						html.div([attribute.class("flex"), attribute.style([
							#("gap", "0.5em"),
							#("flex-wrap", "wrap")
						])],
							tagbadge.tags([
								"Suggestive",
								"Comedy",
								"Romantic Subtext",
							])
						),
						html.div([attribute.class("publication ico-gap")], [
							html.span([attribute.class("icon-circle")], []),
							html.span([], [element.text("Publication: 2023, Ongoing")])
						]),
						html.div([attribute.class("rating ico-gap")], [
							html.span([attribute.class("icon-star")], []),
							html.span([], [element.text("8.06")])
						])
					])
				])
			]),
		]),
		html.div([], [
			html.p([], [
				element.text("Tsubasa Shiki has just moved from Tokyo to Hokkaido, in the middle of winter.
				Not quite appreciating how far apart towns are in the country, he gets off the taxi at the
				next town over from his destination so he can see the sights around his home.
				But he is shocked when he learns the \"next town\" is a 3 hour walk away.
				But he also meets a cute Dosanko (born and raised in Hokkaido) gyaru named Minami Fuyuki who
				is braving negative 8 degree weather in the standard gyaru outfit of short skirts and bare legs!")
			])
		]),
		html.div([attribute.class("grid")], [
			html.div([attribute.class("flex info-extras")], [
				tagbadge.badges_title("Author", ["Ikada Kai"]),
				tagbadge.badges_title("Artist", ["Ikada Kai"]),
				tagbadge.badges_title("Genres", ["Comedy", "Drama", "Slice of Life", "Romance"]),
			]),
			html.div([], [
				html.h3([], [element.text("Chapters")]),
				html.div([attribute.class("flex col-1")], [
					chapter.card(series.Chapter(
						name: "Chapter 1",
						id: "chapter-1",
						image: ""
					))
				])
			])
		])
	])
}
