import gleam/option
import gleam/dynamic
import gleam/json

import gleam/io

import lustre_http as http

import lumiverse/common
import lumiverse/models/auth
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

	http.post(common.kavita_api_url <> "/api/account/login", req_json, http.expect_json(decoder(), layout.LoginGot))
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
