import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/layout
import lumiverse/models/series

pub fn card(srs: series.Series) -> element.Element(layout.Msg) {
	html.a([attribute.href("/series/" <> srs.id)], [
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
