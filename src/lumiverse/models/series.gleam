pub type Series {
	Manga(
		name: String,
		id: String,
		image: String,
		description: String,
		authors: List(String),
		artists: List(String),
		genres: List(String)
	)

}

pub type Chapter {
	Chapter(
		name: String,
		id: String,
		image: String
	)
}
