import gleam/list
import gleam/string

import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/layout
import lumiverse/models/series
import lumiverse/elements/tag
import lumiverse/elements/chapter

pub fn page(srs: series.Manga) -> element.Element(layout.Msg) {
	html.main([attribute.class("container series-page")], [
		html.div([], [
			html.div([attribute.class("series-bg-image bg-image-backdrop"), attribute.style([
				#("background-image", "url('" <> srs.image <> "')")
			])], []),
			html.div([attribute.attribute("loading", "lazy"), attribute.class("series-bg-image bg-image-backdrop"), attribute.style([
				#("background", "linear-gradient(67.81deg,rgba(0,0,0,.64) 35.51%,transparent)"),
				#("backdrop-filter", "blur(4px)")
			])], [])
		]),
		html.div([attribute.class("info")], [
			html.img([
				attribute.attribute("loading", "lazy"),
				attribute.src(srs.image),
				attribute.class("img-fluid cover")
			]),
			html.div([attribute.class("names d-flex")], [
				html.h1([attribute.class("title")], [element.text(srs.name)]),
				html.p([attribute.class("subtitle")], [element.text(srs.name)]),
				html.div([attribute.style([
					#("flex-grow", "1"),
					#("display", "block")
				])], []),
				html.span([attribute.class("authors")], [
					element.text(string.join(srs.authors, ", "))
				])
			]),
			html.div([attribute.class("buttons")], [
				html.button([attribute.attribute("type", "button"), attribute.class("btn btn-primary btn-lg")], [
					html.span([attribute.class("icon-book")], []),
					element.text("Start Reading")
				])
			]),
			html.div([attribute.class("d-flex tagandpub")], [
				html.div([attribute.class("d-flex tag-list")], list.append(tag.list(srs.tags), tag.list(srs.genres))),
				html.div([attribute.class("publication")], [
					html.span([attribute.class("icon-circle"), attribute.attribute("data-publication", series.publication_title(srs.publication))], []),
					html.span([attribute.class("publication-text")], [element.text("Publication: " <> series.publication_title(srs.publication))])
				])
			])
		]),
		html.div([], [
			html.p([], [
				element.text(srs.description)
			])
		]),
		html.div([attribute.class("grid")], [
			html.div([attribute.class("flex info-extras")], [
				tag.list_title("Author", srs.authors),
				tag.list_title("Artist", srs.artists),
				tag.list_title("Genres", srs.genres),
			]),
			html.div([], [
				html.h3([], [element.text("Chapters")]),
				html.div([attribute.class("flex col-1")], [
					chapter.card(srs, series.Chapter(
						name: "Chapter 1",
						id: "chapter-1",
						image: ""
					))
				])
			])
		])
	])
}
