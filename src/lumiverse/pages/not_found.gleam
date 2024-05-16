import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/layout
import lumiverse/components/button.{button}

pub fn page() -> element.Element(layout.Msg) {
	html.main([attribute.class("font-['Poppins'] flex flex-col justify-center items-center h-screen space-y-4")], [
		html.h1([attribute.class("font-bold text-6xl")], [element.text("404")]),
		html.p([], [element.text("Awkward. This page doesn't exist.")]),
		html.a([attribute.href("/")], [
			button([button.solid(button.Neutral), button.md()], [element.text("Home")])
		])
	])
}

