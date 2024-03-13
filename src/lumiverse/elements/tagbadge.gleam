import gleam/list

import lustre/attribute
import lustre/element
import lustre/element/html

pub fn tags(tags: List(String))  -> List(element.Element(Nil)) {
	list.map(tags, fn(t: String) -> element.Element(Nil) {
		tag(t)
	})
}

pub fn tag(tag: String) -> element.Element(Nil) {
	html.span([], [
		element.text(tag)
	])
}

pub fn badge(name: String) -> element.Element(Nil) {
	html.span([], [
		element.text(name)
	])
}

pub fn badges_title(title: String, badges: List(String)) -> element.Element(Nil) {
	html.div([attribute.class("tagbadge-list")], [
		html.h3([], [element.text(title)]),
		html.div([attribute.class("flex"), attribute.style([
			#("column-gap", "0.5rem"),
			#("row-gap", "0.2rem"),
		])], 
			list.map(badges, fn(b: String) -> element.Element(Nil) {
				badge(b)
			})
		)
	])
}
