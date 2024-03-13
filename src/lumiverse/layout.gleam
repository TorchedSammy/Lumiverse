import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

pub fn head() -> element.Element(Nil) {
	html.head([], [
		html.meta([
			attribute.name("viewport"),
			attribute.attribute("content", "width=device-width, initial-scale=1.0")
		]),
		html.link([
			attribute.rel("stylesheet"),
			attribute.href("/static/font-awesome/style.css")
		]),
		html.link([
			attribute.rel("stylesheet"),
			attribute.href("https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css")
		]),
		html.link([
			attribute.rel("stylesheet"),
			attribute.href("/static/main.css")
		]),
		html.script([
			attribute.src("/static/main.js")
		], "")
	])
}

pub fn nav() -> element.Element(Nil) {
	html.header([attribute.class("fixed-top")], [
		html.div([attribute.class("container")], [
			html.nav([], [
				html.ul([], [
					html.li([], [
						html.a([attribute.href("/")], [
							html.img([
								attribute.src("https://gleam.run/images/lucy/lucy.svg"),
								attribute.class("nav-logo")
							])
						])
					]),
					html.li([], [
						html.a([attribute.href("/blog")], [element.text("Blog")])
					])
				]),
				html.ul([], [
					html.li([], [
						html.button([], [element.text("Contact")])
					])
				])
			])
		])
	])
}

pub fn footer() -> element.Element(Nil) {
	html.footer([], [
		html.div([attribute.class("container")], [
			html.h1([], [element.text("hi")])
		])
	])
}
