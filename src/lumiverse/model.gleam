import gleam/option

import lumiverse/models/router
import lumiverse/models/auth

pub type AuthModel {
	AuthModel(
		auth_message: String,
		user_details: auth.LoginDetails
	)
}

pub type Model {
	Model(
		route: router.Route,
		user: option.Option(auth.User),
		auth: AuthModel
	)
}
