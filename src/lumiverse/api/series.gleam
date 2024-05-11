import gleam/fetch
import gleam/dynamic
import gleam/http
import gleam/http/request
import gleam/json
import gleam/option

import gleam/io

import lustre_http

import lumiverse/common
import lumiverse/models/series
import lumiverse/layout

fn decoder() {
	dynamic.decode2(
		series.MinimalInfo,
		dynamic.field("id", dynamic.int),
		dynamic.field("name", dynamic.string),
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

	lustre_http.send(req, lustre_http.expect_json(dynamic.list(decoder()), layout.HomeRecentlyAddedUpdate))
}
