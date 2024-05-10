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
	html.nav([attribute.class("navbar fixed-top navbar-expand-lg bg-body border-bottom border-primary")], [
		html.div([attribute.class("container-fluid")], [
			html.a([attribute.class("navbar-brand"), attribute.href("/")], [
				html.img([
					//attribute.src(config.logo()),
					attribute.class("logo")
				]),
				html.span([attribute.class("navbar-brand-text")], [element.text("Lumiverse")]),
			]),
			html.div([attribute.class("navbar-nav")], [
				case user {
					option.Some(user) -> todo as "make popup and login stuff lol"
					option.None -> html.a([attribute.class("nav-link"), attribute.href("/login")], [
						html.button([
							attribute.attribute("type", "button"),
							attribute.class("btn"),
						], [element.text("Login")])
					])
				}
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
