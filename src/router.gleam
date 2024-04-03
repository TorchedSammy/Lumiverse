import gleam/uri

import lumiverse/models/router

pub fn uri_to_route(uri: uri.Uri) -> router.Route {
	case uri.path {
		"/" -> router.Home
		"/login" -> router.Login
		"/series/" <> rest -> router.Series(rest)
		_ -> router.NotFound
	}
}
