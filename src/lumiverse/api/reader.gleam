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
import lumiverse/models/reader
import lumiverse/layout

fn progress_decoder() {
	dynamic.decode5(
		reader.Progress,
		dynamic.field("volumeId", dynamic.int),
		dynamic.field("chapterId", dynamic.int),
		dynamic.field("pageNum", dynamic.int),
		dynamic.field("seriesId", dynamic.int),
		dynamic.field("libraryId", dynamic.int),
	)
}

fn continue_decoder() {
	dynamic.decode3(
		reader.ContinuePoint,
		dynamic.field("id", dynamic.int),
		dynamic.field("pagesRead", dynamic.int),
		dynamic.field("pages", dynamic.int),
	)
}
pub fn get_progress(token: String, chapter_id: Int) {
	let assert Ok(req) = request.to(common.kavita_api_url <> "/api/reader/get-progress?chapterId=" <> int.to_string(chapter_id))

	let req = req
	|> request.set_method(http.Get)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(progress_decoder(), layout.ProgressRetrieved))
}

pub fn continue_point(token: String, series_id: Int) {
	let assert Ok(req) = request.to(common.kavita_api_url <> "/api/reader/continue-point?seriesId=" <> int.to_string(series_id))

	let req = req
	|> request.set_method(http.Get)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(continue_decoder(), layout.ContinuePointRetrieved))
}

pub fn save_progress(token: String, progress: reader.Progress) {
	let assert Ok(req) = request.to(common.kavita_api_url <> "/api/reader/progress")

	let req_body = json.object([
		#("volumeId", json.int(progress.volume_id)),
		#("chapterId", json.int(progress.chapter_id)),
		#("pageNum", json.int(progress.page_number)),
		#("seriesId", json.int(progress.series_id)),
		#("libraryId", json.int(progress.library_id)),
	])

	let req = req
	|> request.set_method(http.Post)
	|> request.set_body(req_body |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_anything(layout.ProgressUpdated))
}
