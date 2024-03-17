import gleam/uri
import lustre/effect

import lumiverse/layout
import lumiverse/models/router

pub fn init() -> effect.Effect(layout.Msg) {
	effect.from(fn(dispatch) {
		do_init(fn(uri) {
			uri
			|> handle_uri
			|> dispatch
		})
	})
}


@external(javascript, "./router.ffi.mjs", "init")
fn do_init(_dispatch: fn(uri.Uri) -> Nil) -> Nil {
	Nil
}

fn handle_uri(uri: uri.Uri) -> layout.Msg {
	case uri.path {
		"/" -> layout.Router(router.ChangeRoute(router.Home))
		"/login" -> layout.Router(router.ChangeRoute(router.Login))
		"/series/" <> rest -> layout.Router(router.ChangeRoute(router.Series(rest)))
		_ -> layout.Router(router.ChangeRoute(router.NotFound))
	}
}
