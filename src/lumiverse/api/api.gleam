import gleam/option
import gleam/dynamic
import gleam/http
import gleam/http/request
import gleam/json

import gleam/io

import lustre_http

import router

import lumiverse/models/auth
import lumiverse/models/stream
import lumiverse/layout

fn decoder() {
	dynamic.decode3(
		auth.User,
		dynamic.field("username", dynamic.string),
		dynamic.field("token", dynamic.string),
		dynamic.field("apiKey", dynamic.string),
	)
}

pub fn login(username: String, password: String) {
	let req_json = json.object([
		#("username", json.string(username)),
		#("password", json.string(password)),
		#("apiKey", json.string(""))
	])

	lustre_http.post(router.direct("/api/account/login"), req_json, lustre_http.expect_json(decoder(), layout.LoginGot))
}

pub fn decode_login_json(jd: String) -> Result(auth.User, json.DecodeError) {
	json.decode(jd, decoder())
}

pub fn encode_login_json(user: auth.User) -> String {
	json.object([
		#("username", json.string(user.username)),
		#("token", json.string(user.token)),
		#("apiKey", json.string(user.api_key)),
	])
	|> json.to_string
}

pub fn health() {
	lustre_http.get(router.direct("/api/health"), lustre_http.expect_anything(layout.HealthCheck))
}

fn dashboard_decoder() {
	dynamic.list(dynamic.decode6(
		stream.DashboardItem,
		dynamic.field("id", dynamic.int),
		dynamic.field("name", dynamic.string),
		dynamic.field("isProvided", dynamic.bool),
		dynamic.field("order", dynamic.int),
		dynamic.field("streamType", stream.dynamic_streamtype),
		dynamic.field("visible", dynamic.bool),
	))
}

pub fn dashboard(token: String) {
	let assert Ok(req) = request.to(router.direct("/api/stream/dashboard"))

	let req = req
	|> request.set_method(http.Get)
	|> request.set_body(json.object([]) |> json.to_string)
	|> request.set_header("Authorization", "Bearer " <> token)
	|> request.set_header("Accept", "application/json")
	|> request.set_header("Content-Type", "application/json")

	lustre_http.send(req, lustre_http.expect_json(dashboard_decoder(), layout.DashboardRetrieved))
}
