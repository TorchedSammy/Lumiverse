import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

pub fn page() -> element.Element(Nil) {
	html.main([attribute.class("container")], [
		html.section([attribute.class("hero")], [
			html.h1([], [element.text("404")]),
		]),
	])
}

