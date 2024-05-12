import gleam/io
import gleam/int
import gleam/option
import gleam/uri

import lumiverse/common
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

pub fn root_url() -> String {
	let route = get_route()
	let assert option.Some(host) = route.host
	case host {
		"localhost:1234" -> {
			let assert Ok(local) = uri.parse(common.kavita_dev_api)
			common.kavita_dev_api
		}
		_ -> uri.to_string(route)
	}
}

@external(javascript, "./router.ffi.mjs", "get_current_href")
pub fn get_route() -> uri.Uri {}
