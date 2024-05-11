import gleam/dict
import gleam/int
import gleam/option
import gleam/list

import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/common
import lumiverse/layout
import lumiverse/elements/tag
import lumiverse/elements/series
import lumiverse/models/series as series_model
import lumiverse/models/auth as auth_model
import lumiverse/model

pub fn page(model: model.Model) -> element.Element(layout.Msg) {
	let frieren = series_model.Manga(
		id: "sousou-no-frieren",
		name: "Sousou no Frieren",
		image: "https://mangadex.org/covers/b0b721ff-c388-4486-aa0f-c2b0bb321512/425098a9-e052-4fea-921d-368252ad084e.jpg",
		artists: ["Abe Tsukasa"],
		authors: ["Yamada Kanehito"],
		description: "",
		genres: ["Adventure", "Drama", "Fantasy", "Slice of Life"],
		tags: [],
		publication: series_model.Ongoing
	)

	html.div([], [
		case model.user {
			option.None -> series.card(frieren)
			option.Some(user) -> {
				html.div([attribute.id("featuredCarousel"), attribute.class("featured-carousel carousel container slide"), attribute.attribute("data-bs-ride", "carousel")], [
					html.h1([], [element.text("Newest Series")]),
					html.div([attribute.class("carousel-inner")], [
						{
							let assert Ok(srs) = list.first(model.home.carousel_smalldata)
							carousel_item(model, user, srs, True)
						},
						..list.append(
							list.map(list.drop(model.home.carousel_smalldata, 1), fn(srs: series_model.MinimalInfo) -> element.Element(layout.Msg) {
								carousel_item(model, user, srs, False)
							}),
							[
								html.div([attribute.class("featured-carousel-controls")], [
									html.button([attribute.class("carousel-control-prev"), attribute.attribute("data-bs-target", "#featuredCarousel"), attribute.attribute("data-bs-slide", "prev")], [
										html.span([attribute.class("icon-angle-left")], []),
									]),
									html.button([attribute.class("carousel-control-next"), attribute.attribute("data-bs-target", "#featuredCarousel"), attribute.attribute("data-bs-slide", "next")], [
										html.span([attribute.class("icon-angle-right")], []),
									])
								])
							]
						)
					])
				])
			}
		}
	])
}

fn carousel_item(model: model.Model, user: auth_model.User, srs: series_model.MinimalInfo, active: Bool) {
	let active_string = case active {
		True -> " active"
		False -> ""
	}
	let cover_url = common.kavita_api_url <> "/api/image/series-cover?seriesId=" <> int.to_string(srs.id) <> "&apiKey=" <> user.api_key
	let assert Ok(metadata) = dict.get(model.metadatas, srs.id)

	html.div([attribute.class("carousel-item" <> active_string)], [
		html.div([attribute.class("series-bg-image bg-image-backdrop"), attribute.style([
			#("background-image", "url(" <> cover_url <> ")"),
			#("height", "28.8rem"),
		])], []),
		html.div([attribute.class("series-bg-image bg-image-backdrop"), attribute.style([
			#("background", "linear-gradient(to bottom,rgb(var(--background-primary-rgb), .6),rgb(var(--background-primary-rgb)))"),
			#("height", "28.8rem"),
		])], []),
		html.div([attribute.class("item-detail")], [
			html.img([attribute.src(cover_url)]),
			html.div([attribute.class("item-text")], [
				html.h2([], [element.text(srs.name)]),
				html.p([], [element.text(metadata.summary)]),
				html.div([], list.append(tag.list(list.map(metadata.tags, fn(t) {t.title})), tag.list(list.map(metadata.genres, fn(t) {t.title}))))
			])
		])
	])
}
//fn hero_card()
