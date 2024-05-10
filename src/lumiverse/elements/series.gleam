import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/layout
import lumiverse/models/series

pub fn card(srs: series.Manga) -> element.Element(layout.Msg) {
	html.a([attribute.href("/series/" <> srs.id)], [
		html.div([attribute.class("card series-card border-0")], [
			//html.article([attribute.class("series-card")], [
			html.img([attribute.src(srs.image), attribute.class("card-img-top img-fluid")]),
			html.div([attribute.class("card-footer title mb-0")],[
				element.text(srs.name)
			])
			//])
		])
	])
}
