import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/layout

pub fn page() -> element.Element(layout.Msg) {
	html.main([attribute.class("container-fluid fullscreen d-flex align-items-center justify-content-center flex-column")], [
		html.h1([], [element.text("404")]),
		html.p([], [element.text("Awkward. This page doesn't exist.")]),
		html.a([attribute.href("/")], [
			html.button([attribute.class("btn btn-secondary")], [element.text("Home")])
		])
	])
}

