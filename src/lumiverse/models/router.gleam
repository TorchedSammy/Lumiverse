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
}
