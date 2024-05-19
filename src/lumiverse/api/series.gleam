import gleam/fetch
import gleam/dynamic
import gleam/http
import gleam/http/request
import gleam/int
import gleam/json
import gleam/option

import gleam/io

import lustre_http

import lumiverse/models/series
import lumiverse/models/stream
import lumiverse/layout
import router

fn minimal_decoder() {
	dynamic.decode2(
		series.MinimalInfo,
		dynamic.field("id", dynamic.int),
		dynamic.field("name", dynamic.string),
	)
}

fn metadata_decoder() {
	dynamic.decode6(
		series.Metadata,
		dynamic.field("id", dynamic.int),
		dynamic.field("genres", dynamic.list(tag_decoder())),
		dynamic.field("tags", dynamic.list(tag_decoder())),
		dynamic.field("summary", dynamic.string),
		dynamic.field("publicationStatus", dynamic_publication),
		dynamic.field("seriesId", dynamic.int)
	)
}

fn dynamic_publication(from: dynamic.Dynamic) -> Result(series.Publication, List(dynamic.DecodeError)) {
	let publication = dynamic.int(from)
	case publication {
		Ok(num) -> case num {
			// https://github.com/Kareadita/Kavita/blob/develop/API/Entities/Enums/PublicationStatus.cs
			0 -> Ok(series.Ongoing)
			_ -> Error([dynamic.DecodeError(
				expected: "expected publicationStatus to be int of range 0-4",
				found: "it wasnt?? lol",
				path: ["what?"]
			)])
		}
		Error(e) -> Error(e)
	}
}

fn tag_decoder() {
	dynamic.decode2(
		series.Tag,
		dynamic.field("id", dynamic.int),
		dynamic.field("title", dynamic.string)
	)
}

pub fn recently_added(token: String, order: Int, title: String) {
	let assert Ok(req) = request.to(router.direct("/api/series/recently-added-v2?pageNumber=1&pageSize=10"))

	let req = req
	|> request.set_method(http.Post)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(stream.dashboard_series_list_decoder(order, title), layout.DashboardItemRetrieved))
}

pub fn recently_updated(token: String, order: Int, title: String) {
	let assert Ok(req) = request.to(router.direct("/api/series/recently-updated-series?pageNumber=1&pageSize=10"))

	let req = req
	|> request.set_method(http.Post)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(stream.dashboard_recently_updated_decoder(order, title), layout.DashboardItemRetrieved))
}

pub fn on_deck(token: String, order: Int, title: String) {
	let assert Ok(req) = request.to(router.direct("/api/series/on-deck?pageNumber=1&pageSize=10"))

	let req = req
	|> request.set_method(http.Post)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(stream.dashboard_series_list_decoder(order, title), layout.DashboardItemRetrieved))
}

pub fn series(series_id: Int, token: String) {
	let assert Ok(req) = request.to(router.direct("/api/series/" <> int.to_string(series_id)))

	let req = req
	|> request.set_method(http.Get)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(minimal_decoder(), layout.SeriesRetrieved))
}

pub fn metadata(series_id: Int, token: String) {
	let assert Ok(req) = request.to(router.direct("/api/series/metadata?seriesId=" <> int.to_string(series_id)))

	let req = req
	|> request.set_method(http.Get)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(metadata_decoder(), layout.SeriesMetadataRetrieved))
}
