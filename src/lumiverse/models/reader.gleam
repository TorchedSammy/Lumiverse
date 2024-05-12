pub type Progress {
	Progress(
		volume_id: Int,
		chapter_id: Int,
		page_number: Int,
		series_id: Int,
		library_id: Int
	)
}

pub type ContinuePoint {
	ContinuePoint(
		id: Int,
		pages_read: Int,
		pages: Int
	)
}
