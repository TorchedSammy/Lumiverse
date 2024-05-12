import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/string

import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

import lumiverse/model
import lumiverse/layout
import lumiverse/models/series
import lumiverse/elements/tag
import lumiverse/elements/chapter
import lumiverse/pages/not_found
import router

pub fn page(model: model.Model) -> element.Element(layout.Msg) {
	case model.reader_progress {
		option.None -> html.div([attribute.class("container-fluid fullscreen d-flex align-items-center justify-content-center flex-column")], [
			html.div([attribute.class("spinner-border text-primary")], [])
		])
		option.Some(progress) -> {
			let assert option.Some(user) = model.user
			let page_image = router.direct("/api/reader/image?chapterId=" <> int.to_string(progress.chapter_id) <> "&page=" <> int.to_string(progress.page_number) <> "&apiKey=" <> user.api_key)

			html.div([attribute.class("d-flex flex-column"), attribute.id("reader-page"), attribute.style([
				#("position", "relative")
			])], [
				html.div([attribute.class("container-fluid d-flex flex-column border-bottom")], [
					html.div([attribute.class("d-flex flex-column gap-1")], case model.viewing_series {
						option.None -> [
							html.p([attribute.class("placeholder placeholder-glow col-4 fs-5 mb-1")], [element.text("MMmmAHHaeiougAEIOUGH")]),
							html.p([attribute.class("placeholder placeholder-glow placeholder-sm col-3 mb-1")], [])
						]
						option.Some(serie) -> {
							let assert Ok(srs) = serie

							[
								html.p([attribute.class("mb-0 fs-5")], [element.text(srs.name)]),
								html.p([attribute.class("text-primary mb-0")], [element.text(srs.name)]),
							]
						}
					}),
					html.div([attribute.class("row gap-3 p-3 mb-2")], case model.viewing_series, model.continue_point {
						option.Some(serie), option.Some(cont_point) -> {
							[
								html.span([attribute.class("badge text-bg-secondary fs-6 col")], [element.text("Page " <> int.to_string(progress.page_number + 1) <> " / " <> int.to_string(cont_point.pages))]),
								html.span([attribute.class("badge text-bg-secondary fs-6 col")], [element.text("Menu")]),
							]
						}
						_, _ -> {
							[
								html.span([attribute.class("fs-6 col placeholder placeholder-glow")], [element.text("...")]),
								html.span([attribute.class("fs-6 col placeholder placeholder-glow")], [element.text("Menu")]),
							]
						}
					})
				]),
				html.div([attribute.class("d-flex justify-content-center")], [
					html.div([event.on_click(layout.ReaderPrevious), attribute.style([
						#("position", "absolute"),
						#("top", "0"),
						#("bottom", "0"),
						#("left", "0"),
						#("width", "50vw"),
					])], []),
					html.div([event.on_click(layout.ReaderNext), attribute.style([
						#("position", "absolute"),
						#("top", "0"),
						#("bottom", "0"),
						#("right", "0"),
						#("width", "50vw"),
					])], []),
				]),
				html.img([attribute.class("align-self-center"), attribute.id("reader-img"), attribute.src(page_image)])
			])
		}
	}
}

