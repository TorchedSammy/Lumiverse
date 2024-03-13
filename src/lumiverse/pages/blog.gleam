import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html

pub fn list_page() -> element.Element(Nil) {
	html.main([attribute.class("container")], [
		html.div([attribute.class("grid")], [
			post_card("test"),
			post_card("test2"),
			post_card("test3"),
		])
	])
}

pub fn post_page(name: String) -> element.Element(Nil) {
	html.main([attribute.class("container")], [
		html.h1([], [element.text(name)])
	])
}

fn post_card(name: String) -> element.Element(Nil) {
	let img_url = "https://support.edapp.com/hubfs/image-png-2.png"

	html.article([], [
		html.header([
			attribute.class("blog-card"),
			attribute.style([
				#("background-image", "url('" <> img_url <> "')")
			])
		], []),
		html.h1([], [
			element.text(name)
		]),
		html.p([], [
			element.text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum")
		])
	])
}
