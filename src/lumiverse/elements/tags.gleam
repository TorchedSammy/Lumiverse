import gleam/list

import lustre/attribute
import lustre/element
import lustre/element/html

pub fn multiple(tags: List(String))  -> List(element.Element(Nil)) {
	list.map(tags, fn(t: String) -> element.Element(Nil) {
		single(t)
	})
}

pub fn single(tag: String) -> element.Element(Nil) {
	html.span([], [
		element.text(tag)
	])
}
