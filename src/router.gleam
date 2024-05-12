import gleam/int
import gleam/uri

import lumiverse/models/router

pub fn uri_to_route(uri: uri.Uri) -> router.Route {
	case uri.path {
		"/" -> router.Home
		"/login" -> router.Login
		"/series/" <> rest -> router.Series(rest)
		"/chapter/" <> rest -> {
			let assert Ok(chapter_id) = int.base_parse(rest, 10)
			router.Reader(chapter_id)
		}
		"/signout" -> router.Logout
		_ -> router.NotFound
	}
}
