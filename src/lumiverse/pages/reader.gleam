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
		option.None -> html.div([], [])
		option.Some(progress) -> {
			let assert option.Some(user) = model.user
			let page_image = router.direct("/api/reader/image?chapterId=" <> int.to_string(progress.chapter_id) <> "&page=" <> int.to_string(progress.page_number) <> "&apiKey=" <> user.api_key)

			html.div([attribute.class("items-center justify-between"), attribute.id("reader-page"), attribute.style([
				#("position", "relative")
			])], [
				html.div([attribute.class("border-b-2 border-zinc-800 p-4 space-y-2")], [
					html.div([attribute.class("")], case model.viewing_series {
						option.None -> [
							html.div([attribute.class("animate-pulse h-4 w-48")], []),
							html.div([attribute.class("animate-pulse h-4 w-48")], [])
						]
						option.Some(serie) -> {
							let assert Ok(srs) = serie

							[
								html.p([attribute.class("")], [element.text(srs.name)]),
								html.p([attribute.class("text-violet-600")], [element.text(srs.name)]),
							]
						}
					}),
					html.div([attribute.class("grid grid-cols-2 gap-2")], case model.viewing_series, model.continue_point, model.chapter_info {
						option.Some(serie), option.Some(cont_point), option.Some(inf) -> {
							[
								html.span([attribute.class("bg-zinc-800 rounded py-0.5 px-1")], [element.text("Page " <> int.to_string(progress.page_number + 1) <> " / " <> int.to_string(inf.pages))]),
								html.span([attribute.class("bg-zinc-800 rounded py-0.5 px-1")], [element.text("Menu")]),
							]
						}
						_, _, _ -> {
							[
								html.div([attribute.class("animate-pulse h-12")], []),
								html.div([attribute.class("animate-pulse h-12")], [])
							]
						}
					})
				]),
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
				html.div([attribute.class("flex justify-center items-center h-screen")], [
					html.img([attribute.class("h-screen object-contain"), attribute.id("reader-img"), attribute.src(page_image)])
				])
			])
		}
	}
}

