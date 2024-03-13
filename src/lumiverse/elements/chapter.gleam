import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/models/series

pub fn card(chp: series.Series) -> element.Element(Nil) {
	html.article([attribute.class("chapter")], [
		html.span([], [
			element.text(chp.name)
		])
	])
}
