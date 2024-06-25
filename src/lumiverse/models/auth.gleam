import gleam/option
import gleam/dynamic
import gleam/json

import lustre_http as http

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
		token: String,
		refresh_token: String,
		api_key: String
	)
}

pub type Refresh {
	Refresh(
		token: String,
		refresh_token: String
	)
}
