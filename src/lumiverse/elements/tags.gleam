import gleam/list

import lustre/attribute
import lustre/element
import lustre/element/html

pub fn multiple(tags: List(String))  -> List(element.Element(Nil)) {
	let remaining: List(String) = []
	let elems: List(element.Element(Nil)) = []
	let empty = list.is_empty(remaining)
		
	case empty {
		True -> elems
		False -> {
			let tag = list.at(tags, 0)
			case tag {
				Error(err) -> panic(err)
				Ok(tag) -> {
					let elem = single(tag)
					elems
					//loopf(list.drop(remaining, 1))
				}
			}
		}
	}
}

pub fn single(tag: String) -> element.Element(Nil) {
	html.span([], [
		element.text(tag)
	])
}
