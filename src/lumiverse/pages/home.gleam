import gleam/int
import gleam/option
import gleam/list

import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/common
import lumiverse/layout
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
				html.div([attribute.id("featuredCarousel"), attribute.class("carousel slide"), attribute.attribute("data-bs-ride", "carousel")], [
					html.div([attribute.class("carousel-inner")], [
						{
							let assert Ok(srs) = list.first(model.home.carousel)
							carousel_item(user, srs, True)
						},
						..list.append(
							list.map(list.drop(model.home.carousel, 1), fn(srs: series_model.MinimalInfo) -> element.Element(layout.Msg) {
								carousel_item(user, srs, False)
							}),
							[
								html.div([attribute.class("featured-carousel-controls")], [
									html.button([attribute.class("carousel-control-prev"), attribute.attribute("data-bs-target", "#featuredCarousel"), attribute.attribute("data-bs-slide", "prev")], [
										html.span([attribute.class("carousel-control-prev-icon")], [])
									]),
									html.button([attribute.class("carousel-control-next"), attribute.attribute("data-bs-target", "#featuredCarousel"), attribute.attribute("data-bs-slide", "next")], [
										html.span([attribute.class("carousel-control-next-icon")], [])
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

fn carousel_item(user: auth_model.User, srs: series_model.MinimalInfo, active: Bool) {
	let active_string = case active {
		True -> " active"
		False -> ""
	}
	let cover_url = common.kavita_api_url <> "/api/image/series-cover?seriesId=" <> int.to_string(srs.id) <> "&apiKey=" <> user.api_key

	html.div([attribute.class("carousel-item" <> active_string)], [
		html.div([attribute.class("series-bg-image bg-image-backdrop"), attribute.style([
			#("background-image", "url(" <> cover_url <> ")"),
			#("height", "25.4rem"),
		])], []),
		html.img([attribute.src(cover_url)])
	])
}
//fn hero_card()
