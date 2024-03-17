import gleam/option
import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/api/api
import lumiverse/config
import lumiverse/models/router
import lumiverse/models/auth

pub type Msg {
	Router(router.Msg)
	AuthPage(auth.Msg)
}

pub fn head() -> element.Element(a) {
	html.head([], [
		html.meta([
			attribute.attribute("charset", "UTF-8")
		]),
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

pub fn nav(user: option.Option(api.User)) -> element.Element(a) {
	html.header([attribute.class("fixed-top")], [
		html.div([attribute.class("container")], [
			html.nav([], [
				html.ul([], [
					html.li([], [
						html.a([attribute.href("/")], [
							html.img([
								//attribute.src(config.logo()),
								attribute.class("logo")
							])
						])
					]),
					html.li([], [
						//html.a([attribute.href("/blog")], [element.text("Blog")])
					])
				]),
				html.ul([], [
					html.li([], [
						html.details([attribute.class("dropdown")], [
							html.summary([], [element.text("sammy")]),
							html.ul([], [
								html.li([], [element.text("Bookmarks")]),
								case user {
									option.Some(user) -> todo as "i didnt anticipate this!?"
									option.None -> html.a([
										attribute.href("/login"), attribute.role("button")
									], [element.text("Login")])
								}
							])
						])
					])
				])
			])
		])
	])
}

pub fn footer() -> element.Element(a) {
	html.footer([], [
		html.div([attribute.class("container")], [
			html.h1([], [element.text("hi")])
		])
	])
}
