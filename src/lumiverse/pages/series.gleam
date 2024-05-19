import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/string

import lustre/attribute.{class}
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

import lumiverse/components/button.{button}

pub fn page(model: model.Model) -> element.Element(layout.Msg) {
	case model.viewing_series {
		option.Some(serie) -> case serie {
			Error(_) -> not_found.page()
			_ -> real_page(model)
		}
		option.None -> real_page(model)
	}
}

fn real_page(model: model.Model) -> element.Element(layout.Msg) {
	let assert option.Some(user) = model.user
	html.div([class("max-w-screen-xl items-center justify-between mx-auto mb-8 p-4 space-y-4")], [
		html.div([class("flex flex-col sm:flex-row md:flex-row gap-4")], [
			case model.viewing_series {
				option.Some(serie) -> {
					let assert Ok(srs) = serie
					let cover_url = router.direct("/api/image/series-cover?seriesId=" <> int.to_string(srs.id) <> "&apiKey=" <> user.api_key)

					html.div([class("max-w-64")], [
						html.img([class("bg-zinc-800 rounded object-contain min-w-48 min-h-80"), attribute.src(cover_url)])
					])
				}
				option.None -> html.div([class("bg-zinc-800 rounded animate-pulse h-80 w-48")], [])
			},
			html.div([attribute.class("flex flex-col gap-5")], [
				html.div([class("space-y-2")], case model.viewing_series {
					option.Some(serie) -> {
						let assert Ok(srs) = serie

						[
							html.h1([
								class("font-['Poppins'] font-extrabold text-xl sm:text-5xl")
							], [element.text(srs.name)]),
							html.h2([
								class("font-['Poppins'] font-medium sm:font-semibold text-lg sm:text-xl")
							], [element.text(srs.name)]),
						]
					}
					option.None -> [
						html.div([
							class("bg-zinc-800 animate-pulse h-12 w-96")
						], []),
						html.div([
							class("bg-zinc-800 animate-pulse h-7 w-48")
						], [])
					]
				}),
				html.div([], [
					button([
						event.on_click(layout.Read),
						button.solid(button.Primary),
						button.lg(),
						class("text-white font-semibold")
					], [
						html.span([attribute.class("icon-book")], []),
						element.text("Start Reading")
					])
				]),
				case model.viewing_series {
					option.Some(serie) -> {
						let assert Ok(srs) = serie
						let assert Ok(metadata) = dict.get(model.metadatas, srs.id)

						html.div([class("flex flex-wrap gap-2 uppercase font-['Poppins'] font-semibold text-[0.7rem]")], list.append(
							{
								let tags = list.append(list.map(metadata.tags, fn(t) {t.title}), list.map(metadata.genres, fn(t) {t.title}))
								case list.length(tags) {
									0 -> []
									_ -> [tag.list(tags)]
								}
							},
							[
								html.div([attribute.class("space-x-1")], [
									html.span([
										class("icon-circle text-publication-" <> series.publication_title(metadata.publication_status)),
										attribute.attribute("data-publication", series.publication_title(metadata.publication_status))
									], []),
									html.span([], [
										element.text("Publication: " <> series.publication_title(metadata.publication_status))
									])
								])
							]
						))
					}
					option.None -> html.div([class("bg-zinc-800 animate-pulse w-80 h-4")], [])
				}
			])
		]),
		case model.viewing_series {
			option.None -> html.div([], [])
			option.Some(serie) -> {
				let assert Ok(srs) = serie
				let assert Ok(metadata) = dict.get(model.metadatas, srs.id)

				html.div([], [
					html.p([], [element.text(metadata.summary)])
				])
			}
		}
	])
}
