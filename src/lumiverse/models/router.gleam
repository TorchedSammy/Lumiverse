// Route Definition
pub type Route {
	Home
	Login
	All
	Series(String)
	NotFound
	Logout
	Reader(chapter_id: Int)
}

// Update Function with Routing
pub type Msg {
	ChangeRoute(route: Route)
}
