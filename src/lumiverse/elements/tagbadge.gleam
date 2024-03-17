import gleam/list

import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/layout

pub fn tags(tags: List(String))  -> List(element.Element(layout.Msg)) {
	list.map(tags, fn(t: String) -> element.Element(layout.Msg) {
		tag(t)
	})
}

pub fn tag(tag: String) -> element.Element(layout.Msg) {
	html.span([], [
		element.text(tag)
	])
}

pub fn badge(name: String) -> element.Element(layout.Msg) {
	html.span([
		attribute.href("/tags/" <> name)
	], [
		element.text(name)
	])
}

pub fn badges_title(title: String, badges: List(String)) -> element.Element(layout.Msg) {
	html.div([
		attribute.class("tagbadge-list"),
	], [
		html.h3([], [element.text(title)]),
		html.div([attribute.class("flex"), attribute.style([
			#("column-gap", "0.5rem"),
			#("row-gap", "0.2rem"),
		])], 
			list.map(badges, fn(b: String) -> element.Element(layout.Msg) {
				badge(b)
			})
		)
	])
}
