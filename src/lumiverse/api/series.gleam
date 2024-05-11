import gleam/fetch
import gleam/dynamic
import gleam/http
import gleam/http/request
import gleam/int
import gleam/json
import gleam/option

import gleam/io

import lustre_http

import lumiverse/common
import lumiverse/models/series
import lumiverse/layout

fn minimal_decoder() {
	dynamic.decode2(
		series.MinimalInfo,
		dynamic.field("id", dynamic.int),
		dynamic.field("name", dynamic.string),
	)
}

fn metadata_decoder() {
	dynamic.decode5(
		series.Metadata,
		dynamic.field("id", dynamic.int),
		dynamic.field("genres", dynamic.list(tag_decoder())),
		dynamic.field("tags", dynamic.list(tag_decoder())),
		dynamic.field("summary", dynamic.string),
		dynamic.field("seriesId", dynamic.int)
	)
}

fn tag_decoder() {
	dynamic.decode2(
		series.Tag,
		dynamic.field("id", dynamic.int),
		dynamic.field("title", dynamic.string)
	)
}

pub fn recently_added(token: String) {
	let assert Ok(req) = request.to(common.kavita_api_url <> "/api/series/recently-added-v2?pageNumber=1&pageSize=5")

	let req = req
	|> request.set_method(http.Post)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(dynamic.list(minimal_decoder()), layout.HomeRecentlyAddedUpdate))
}

pub fn metadata(series_id: Int, token: String) {
	let assert Ok(req) = request.to(common.kavita_api_url <> "/api/series/metadata?seriesId=" <> int.to_string(series_id))

	let req = req
	|> request.set_method(http.Get)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(metadata_decoder(), layout.SeriesMetadataRetrieved))
}
