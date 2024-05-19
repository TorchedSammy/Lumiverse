import gleam/option
import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lustre_http as http

import lumiverse/config
import lumiverse/model
import lumiverse/models/auth
import lumiverse/models/reader
import lumiverse/models/router
import lumiverse/models/series
import lumiverse/models/stream
import lumiverse/components/button.{button}

// TODO: put messages related to a specific page in separate source
// there is no reason for LoginGot to not be outside auth.Msg
// TODO TODO: handle specific messages where they are declared
pub type Msg {
	Router(router.Msg)
	HealthCheck(Result(Nil, http.HttpError))
	// Auth
	AuthPage(auth.Msg)
	LoginGot(Result(auth.User, http.HttpError))

	//Home
	DashboardRetrieved(Result(List(stream.DashboardItem), http.HttpError))
	HomeRecentlyAddedUpdate(Result(model.SeriesList, http.HttpError))
	SeriesRetrieved(Result(series.MinimalInfo, http.HttpError))
	SeriesMetadataRetrieved(Result(series.Metadata, http.HttpError))

	// Reader
	Read
	ReaderPrevious
	ReaderNext
	ProgressUpdated(Result(Nil, http.HttpError))
	ContinuePointRetrieved(Result(reader.ContinuePoint, http.HttpError))
	ProgressRetrieved(Result(reader.Progress, http.HttpError))
	ChapterInfoRetrieved(Result(reader.ChapterInfo, http.HttpError))
	PreviousChapterRetrieved(Result(Int, http.HttpError))
	NextChapterRetrieved(Result(Int, http.HttpError))
}

pub fn nav_(model: model.Model) -> element.Element(a) {
	html.nav([attribute.class("navbar navbar-expand-lg border-bottom" <> case model.route {
		router.Reader(_) -> ""
		_ -> " fixed-top mb-3 navbar-transition"
	})], [
		html.div([attribute.class("container-fluid")], [
			html.a([attribute.class("navbar-brand"), attribute.href("/")], [
				html.img([
					attribute.src(config.logo()),
					attribute.class("logo")
				]),
				html.span([attribute.class("navbar-brand-text")], [element.text("Lumiverse")]),
			]),
			html.div([attribute.class("navbar-nav")], [
				case model.user {
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

pub fn nav(model: model.Model) {
	html.nav([], [
		html.div([attribute.class("max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4")], [
			html.a([attribute.href("/"), attribute.class("flex items-center space-x-3")], [
				html.img([
					attribute.src(config.logo()),
					attribute.class("h-12")
				]),
				html.span([
					attribute.class("self-center text-2xl font-bold dark:text-white")
				], [
					element.text("Lumiverse")
				])
			]),
			case model.user {
				option.Some(user) -> html.div([], [
					button([button.md(), attribute.class("text-white")], [element.text(user.username)])
				])
				option.None -> html.a([attribute.href("/login")], [
					button([button.solid(button.Neutral), button.md()], [element.text("Login")])
				])
			}
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
