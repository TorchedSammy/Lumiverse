import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/layout
import lumiverse/models/series

pub fn card(srs: series.Series, chp: series.Chapter) -> element.Element(layout.Msg) {
	html.article([attribute.class("chapter")], [
		html.span([
			attribute.href("/series/" <> srs.name <> "/" <> "/chapter/" <> chp.id)
		], [
			element.text(chp.name)
		])
	])
}
