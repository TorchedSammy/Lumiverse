import gleam/uri
import lustre/effect

// Route Definition
pub type Route {
	Home
	Login
	Series(String)
	NotFound
}

// Update Function with Routing
pub type Msg {
	ChangeRoute(route: Route)
	NoOp
}

pub fn init() -> effect.Effect(Msg) {
	effect.from(fn(dispatch) {
		do_init(fn(uri) {
			uri
			|> handle_uri
			|> dispatch
		})
	})
}


@external(javascript, "../router.ffi.mjs", "init")
fn do_init(_dispatch: fn(uri.Uri) -> Nil) -> Nil {
	Nil
}

fn handle_uri(uri: uri.Uri) -> Msg {
	case uri.path {
		"/" -> ChangeRoute(Home)
		"/login" -> ChangeRoute(Login)
		"/series/" <> rest -> ChangeRoute(Series(rest))
		_ -> ChangeRoute(NotFound)
	}
}
