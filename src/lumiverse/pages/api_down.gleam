import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/layout

pub fn page() -> element.Element(layout.Msg) {
	html.main([attribute.class("container-fluid fullscreen d-flex align-items-center justify-content-center flex-column")], [
		html.h1([], [element.text("(×_×)")]),
		html.p([], [element.text("Could not connect to the backend API. Maybe try reloading?")]),
	])
}
