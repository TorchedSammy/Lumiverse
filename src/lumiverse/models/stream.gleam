import gleam/dynamic
import lumiverse/models/series
import lumiverse/model

pub type DashboardItem {
	DashboardItem(
		id: Int,
		name: String,
		provided: Bool,
		order: Int,
		stream_type: StreamType,
		visible: Bool
		//smart_filter_encoded: String,
		//smart_filter_id: String,
	)
}

pub type StreamType {
	OnDeck
	RecentlyUpdated
	NewlyAdded
	SmartFilter
	MoreInGenre
}

pub fn dynamic_streamtype(from: dynamic.Dynamic) -> Result(StreamType, List(dynamic.DecodeError)) {
	let streamtype = dynamic.int(from)
	case streamtype {
		Ok(num) -> case num {
			// https://github.com/Kareadita/Kavita/blob/97ffdd097504ff9896f626bc7e0deb0c6e743d9d/UI/Web/src/app/_models/dashboard/stream-type.enum.ts
			1 -> Ok(OnDeck)
			2 -> Ok(RecentlyUpdated)
			3 -> Ok(NewlyAdded)
			4 -> Ok(SmartFilter)
			5 -> Ok(MoreInGenre)
			_ -> Error([dynamic.DecodeError(
				expected: "expected streamType to be int of range 1-5",
				found: "it wasnt?? lol",
				path: ["what?"]
			)])
		}
		Error(e) -> Error(e)
	}
}

pub fn dashboard_series_list_decoder(order: Int, title: String) {
	fn(from: dynamic.Dynamic) {
		let decoder = dynamic.list(series.minimal_decoder())
		case decoder(from) {
			Ok(series) -> Ok(model.SeriesList(items: series, title: title, idx: order))
			Error(e) -> Error(e)
		}
	}
}
