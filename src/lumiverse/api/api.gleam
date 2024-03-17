import gleam/dynamic
import gleam/fetch
import gleam/http
import gleam/http/request
import gleam/http/response
import gleam/javascript/promise
import gleam/json

import gleam/io

import juno

import lumiverse/common

pub type LoginRequest {
	LoginRequest(username: String, password: String, api_key: String)
}

pub type User {
	Username(String)
}

pub fn login(username: String, password: String) {
	let req_json = json.object([
		#("username", json.string(username)),
		#("password", json.string(password)),
		#("apiKey", json.string(""))
	]) |> json.to_string

	let assert Ok(req_orig) = request.to(common.kavita_api_url <> "/api/login")
	let req = request.set_method(req_orig, http.Post)
	let req = request.set_body(req, req_json)

	// Send the HTTP request to the server
	use resp <- promise.try_await(fetch.send(req))
	use resp <- promise.try_await(fetch.read_text_body(resp))

	let login_resp = login_from_json(resp.body)

	promise.resolve(Ok(login_resp))
}

pub fn login_from_json(jsondata: String) {
	juno.decode_object(jsondata, [
		dynamic.decode1(Username, dynamic.field("username", dynamic.string))
	])
}
