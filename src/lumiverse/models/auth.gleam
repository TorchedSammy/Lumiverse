import gleam/option
import gleam/dynamic
import gleam/json

import lustre_http as http

import lumiverse/common

pub type Msg {
	LoginSubmitted
	UsernameUpdated(value: String)
	PasswordUpdated(value: String)
	AuthMessage(value: String)
}

pub type LoginDetails {
	LoginDetails(username: String, password: String)
}

pub type LoginRequest {
	LoginRequest(username: String, password: String, api_key: String)
}

pub type User {
	User(
		username: String,
		token: String
	)
}
