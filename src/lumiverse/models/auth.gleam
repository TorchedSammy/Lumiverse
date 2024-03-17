import lumiverse/api/api

pub type Msg {
	LoginSubmitted
	LoginGot(api.User)
}
