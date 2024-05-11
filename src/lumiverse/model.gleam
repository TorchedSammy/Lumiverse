import gleam/dict
import gleam/option

import lumiverse/models/router
import lumiverse/models/auth
import lumiverse/models/series

pub type Model {
	Model(
		route: router.Route,
		user: option.Option(auth.User),
		auth: AuthModel,
		home: HomeModel,
		metadatas: dict.Dict(Int, series.Metadata),
		series: dict.Dict(Int, series.MinimalInfo)
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
		carousel_smalldata: List(series.MinimalInfo),
		carousel: List(series.Metadata)
	)
}
