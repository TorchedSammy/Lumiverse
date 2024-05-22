import gleam/list
import gleam/order
import gleam/string

// colored red
pub const explicit = [
	"hentai",
	"sexual violence",
	"gore",
	"adult",
	"erotica",
	"explicit-test-tag"
]

// colored orange
pub const beware = [
	"suggestive",
	"ecchi",
	"beware-test-tag"
]

pub fn compare(a: String, b: String) -> order.Order {
	let a_is_explicit = list.contains(explicit, string.lowercase(a))
	let b_is_explicit = list.contains(explicit, string.lowercase(b))
	
	let a_is_beware = list.contains(beware, string.lowercase(a))
	let b_is_beware = list.contains(beware, string.lowercase(b))

	case a_is_explicit, b_is_explicit, a_is_beware, b_is_beware {
		_, True, _, _ -> order.Gt
		True, _, _, _ -> order.Lt
		_, _, _, True -> order.Gt
		_, _, True, _ -> order.Lt
		_, _, _, _ -> string.compare(a, b)
	}
}
