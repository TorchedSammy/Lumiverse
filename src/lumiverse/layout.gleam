import gleam/option
import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lustre_http as http

import lumiverse/config
import lumiverse/models/router
import lumiverse/models/auth
import lumiverse/models/series

pub type Msg {
	Router(router.Msg)
	AuthPage(auth.Msg)
	LoginGot(Result(auth.User, http.HttpError))
	HomeRecentlyAddedUpdate(Result(List(series.MinimalInfo), http.HttpError))
	SeriesRetrieved(Result(series.MinimalInfo, http.HttpError))
	SeriesMetadataRetrieved(Result(series.Metadata, http.HttpError))
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

pub fn nav(user: option.Option(auth.User)) -> element.Element(a) {
	html.nav([attribute.class("navbar fixed-top navbar-expand-lg border-bottom")], [
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
					option.Some(user) -> html.div([attribute.class("dropdown")], [
						html.button([attribute.class("btn btn-secondary dropdown-toggle"), attribute.attribute("data-bs-toggle", "dropdown"), attribute.attribute("type", "button")], [
							element.text(user.username)
						]),
						html.div([attribute.class("dropdown-menu p-3")], [
							html.div([attribute.class("mt-3 mb-3")], [
								html.div([attribute.class("d-grid justify-content-center")], [
									html.span([attribute.class("fw-bold fs-4 mb-1")], [element.text(user.username)])
								]),
								html.div([attribute.class("d-grid justify-content-center")], [
									html.span([attribute.class("badge text-bg-light")], [element.text("User")])
								]),
							]),
							html.hr([attribute.class("border border-primary")]),
							html.div([], [
								drop_item("bookmark", "Bookmarks", "/bookmarks"),
								drop_item("bars", "Settings", "/settings"),
								drop_item("filter", "Filters", "/filters"),
								drop_item("info-circle", "Announcements", "/announcements"),
							]),
							html.hr([attribute.class("border border-primary")]),
							drop_item("sign-out", "Log Out", "/signout")
						])
					])
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

fn drop_item(icon: String, name: String, href: String) -> element.Element(a) {
	html.a([attribute.href(href), attribute.class("drop-item")], [
		html.button([attribute.attribute("type", "button"), attribute.class("btn btn-lg")], [
			html.span([attribute.class("drop-item-icon icon-" <> icon)], []),
			html.span([attribute.class("drop-item-text")], [element.text(name)])
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
