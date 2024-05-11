import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/string

import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/common
import lumiverse/model
import lumiverse/layout
import lumiverse/models/series
import lumiverse/elements/tag
import lumiverse/elements/chapter
import lumiverse/pages/not_found

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
	let placeholder_class = case model.viewing_series {
		option.None -> " placeholder placeholder-glow"
		option.Some(_) -> ""
	}

	html.main([attribute.class("container series-page")], [
		html.div([], [
			html.div([attribute.class("series-bg-image bg-image-backdrop"), attribute.style(case model.viewing_series {
				option.Some(serie) -> {
					let assert Ok(srs) = serie
					let assert Ok(metadata) = dict.get(model.metadatas, srs.id)
					let assert option.Some(user) = model.user
					let cover_url = common.kavita_api_url <> "/api/image/series-cover?seriesId=" <> int.to_string(srs.id) <> "&apiKey=" <> user.api_key

					[#("background-image", "url('" <> cover_url <> "')")]
				}
				option.None -> []
			})], []),
			html.div([attribute.attribute("loading", "lazy"), attribute.class("series-bg-image bg-image-backdrop"), attribute.style([
				#("background", "linear-gradient(67.81deg,rgba(0,0,0,.64) 35.51%,transparent)"),
				#("backdrop-filter", "blur(4px)")
			])], [])
		]),
		html.div([attribute.class("info")], [
			case model.viewing_series {
				option.Some(serie) -> {
					let assert Ok(srs) = serie
					let assert Ok(metadata) = dict.get(model.metadatas, srs.id)
					let assert option.Some(user) = model.user
					let cover_url = common.kavita_api_url <> "/api/image/series-cover?seriesId=" <> int.to_string(srs.id) <> "&apiKey=" <> user.api_key

					html.img([
						attribute.attribute("loading", "lazy"),
						attribute.src(cover_url),
						attribute.class("img-fluid cover")
					])
				}
				option.None -> {
					html.img([
						attribute.attribute("loading", "lazy"),
						attribute.class("img-fluid cover placeholder")
					])
				}
			},
			html.div([attribute.class("names d-flex")],
			case model.viewing_series {
				option.Some(serie) -> {
					let assert Ok(srs) = serie
					let assert Ok(metadata) = dict.get(model.metadatas, srs.id)
					let assert option.Some(user) = model.user
					let cover_url = common.kavita_api_url <> "/api/image/series-cover?seriesId=" <> int.to_string(srs.id) <> "&apiKey=" <> user.api_key

					[
						html.h1([attribute.class("title")], [element.text(srs.name)]),
						html.p([attribute.class("subtitle")], [element.text(srs.name)]),
						html.div([attribute.style([
							#("flex-grow", "1"),
							#("display", "block")
						])], []),
						html.span([attribute.class("authors")], [
							element.text(string.join(["Yamada Kanehito", "Abe Tsukasa"], ", "))
						])
					]
				}
				option.None -> [
					html.h1([attribute.class("title placeholder placeholder-glow col-4 placeholder-lg")], []),
					html.p([attribute.class("subtitle placeholder placeholder-glow col-4 placeholder-sm")], []),
					html.div([attribute.style([
						#("flex-grow", "1"),
						#("display", "block")
					])], []),
					html.span([attribute.class("authors placeholder placeholder-glow col-4 placeholder-xs")], [
						element.text(string.join(["Yamada Kanehito", "Abe Tsukasa"], ", "))
					])
				]
			}),
			html.div([attribute.class("buttons")], [
				html.button([attribute.attribute("type", "button"), attribute.class("btn btn-primary btn-lg" <> placeholder_class)], [
					html.span([attribute.class("icon-book")], []),
					element.text("Start Reading")
				])
			]),
			case model.viewing_series {
				option.Some(serie) -> {
					let assert Ok(srs) = serie
					let assert Ok(metadata) = dict.get(model.metadatas, srs.id)

					html.div([attribute.class("d-flex tagandpub")], [
						tag.list(list.append(list.map(metadata.tags, fn(t) {t.title}), list.map(metadata.genres, fn(t) {t.title}))),
						html.div([attribute.class("publication")], [
							html.span([attribute.class("icon-circle"), attribute.attribute("data-publication", series.publication_title(metadata.publication_status))], []),
							html.span([attribute.class("publication-text")], [element.text("Publication: " <> series.publication_title(metadata.publication_status))])
						])
					])
				}
				option.None -> html.div([attribute.class("d-flex tagandpub")], [
					html.div([attribute.class("d-flex tag-list col-6 placeholder placeholder-glow placeholder-sm")], []),
					html.div([attribute.class("publication")], [
						html.span([attribute.class("publication-text placeholder placeholder-glow placeholder-sm")], [])
					])
				])
			},
			case model.viewing_series {
				option.Some(serie) -> {
					let assert Ok(srs) = serie
					let assert Ok(metadata) = dict.get(model.metadatas, srs.id)

					html.div([attribute.style([
						#("grid-area", "summary")
					])], [
						html.p([], [
							element.text(metadata.summary)
						])
					])
				}
				option.None -> html.div([attribute.class("d-flex justify-content-center")], [
					html.div([attribute.class("spinner-border")], [])
				])
			}
		]),
	])
}
