import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/elements/tags
import lumiverse/models/series

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
		html.div([attribute.class("grid"), attribute.style([
			#("display", "inline-flex")
		])], [
			html.img([
				attribute.attribute("loading", "lazy"),
				attribute.src(srs.image),
				attribute.style([#("border-radius", "var(--pico-border-radius)")])
			]),
			html.div([attribute.class("grid col-1")], [
				html.div([attribute.class("flex col-1 gy-0"), attribute.style([
					#("height", "10rem"),
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
					html.div([attribute.class("grid"), attribute.style([
						#("display", "inline-flex")
					])],
						tags.multiple([
							"Suggestive",
							"Comedy",
							"Romantic Subtext",
						])
					)
				])
			]),
		])
	])
}
