import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

import lumiverse/layout

pub fn page() -> element.Element(layout.Msg) {
	html.main([attribute.class("container-fluid fullscreen d-flex align-items-center justify-content-center flex-column")], [
		html.img([attribute.src("/priv/static/logo.svg"), attribute.width(128), attribute.height(128)])
	])
}

