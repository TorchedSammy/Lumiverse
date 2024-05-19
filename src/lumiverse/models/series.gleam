import gleam/dynamic

pub type Manga {
	Manga(
		name: String,
		id: String,
		image: String,
		description: String,
		authors: List(String),
		artists: List(String),
		genres: List(String),
		tags: List(String),
		publication: Publication
	)
}

pub type Metadata {
	Metadata(
		id: Int,
		genres: List(Tag),
		tags: List(Tag),
		summary: String,
		publication_status: Publication,
		series_id: Int
	)
}

pub type Tag {
	Tag(
		id: Int,
		title: String
	)
}

pub type MinimalInfo {
	MinimalInfo(
		id: Int,
		name: String
	)
}

pub fn minimal_decoder() {
	dynamic.decode2(
		MinimalInfo,
		dynamic.field("id", dynamic.int),
		dynamic.field("name", dynamic.string),
	)
}

pub type Publication {
	Ongoing
	Hiatus
	Completed
	Cancelled
	Ended
}

pub type Chapter {
	Chapter(
		name: String,
		id: String,
		image: String
	)
}

pub fn publication_title(publication: Publication) -> String {
	case publication {
		Ongoing -> "ongoing"
		Hiatus -> "hiatus"
		Completed -> "completed"
		Cancelled -> "cancelled"
		Ended -> "ended"
	}
}
