import gleam/dict
import gleam/option

import lustre_http as http

import lumiverse/models/reader
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
		series: dict.Dict(Int, series.MinimalInfo),
		viewing_series: option.Option(Result(series.MinimalInfo, http.HttpError)),
		reader_progress: option.Option(reader.Progress),
		continue_point: option.Option(reader.ContinuePoint)
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
