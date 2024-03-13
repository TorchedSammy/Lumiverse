import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/models/series

pub fn card(srs: series.Series) -> element.Element(Nil) {
	html.a([attribute.href("/series/" <> srs.slug)], [
		html.article([attribute.class("series-card")], [
			html.header([], [
				html.img([attribute.src(srs.image)])
			]),
			html.h1([attribute.class("title mb-0")],[
				element.text(srs.name)
			])
		])
	])
}
