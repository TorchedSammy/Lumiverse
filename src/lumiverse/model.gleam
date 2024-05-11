import gleam/option

import lumiverse/models/router
import lumiverse/models/auth
import lumiverse/models/series

pub type Model {
	Model(
		route: router.Route,
		user: option.Option(auth.User),
		auth: AuthModel,
		home: HomeModel
	)
}

pub type AuthModel {
	AuthModel(
		auth_message: String,
		user_details: auth.LoginDetails
	)
}

pub type HomeModel {
	HomeModel(
		carousel: List(series.MinimalInfo)
	)
}
