import gleam/list

import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/layout

pub fn list(tags: List(String))  -> element.Element(layout.Msg) {
	html.div([attribute.class("tag-list")], list.map(tags, fn(t: String) -> element.Element(layout.Msg) {
		single(t)
	}))
}

pub fn single(tag: String) -> element.Element(layout.Msg) {
	html.span([attribute.class("tag badge text-bg-secondary")], [
		element.text(tag)
	])
}

pub fn list_title(title: String, badges: List(String)) -> element.Element(layout.Msg) {
	html.div([], [
		html.h3([], [element.text(title)]),
		list(badges)
	])
}

pub fn badge(name: String) -> element.Element(layout.Msg) {
	html.span([
		attribute.href("/tags/" <> name)
	], [
		element.text(name)
	])
}

