import gleam/list
import gleam/json
import gleam/dynamic

pub type SmartFilter {
	SmartFilter(
		id: Int,
		name: String,
		statements: List(SmartFilterStatement),
		combination: Int,
		sort_options: SmartFilterSortOptions,
		limit_to: Int,
		for_dashboard: Bool,
		order: Int
	)
}

pub type SmartFilterStatement {
	SmartFilterStatement(
		comparison: Int,
		field: Int,
		value: String
	)
}

pub type SmartFilterSortOptions {
	SmartFilterSortOptions(
		sort_field: Int,
		ascending: Bool
	)
}

pub fn smart_filter_decoder(for_dashboard: Bool, order: Int) {
	dynamic.decode8(
		SmartFilter,
		dynamic.field("id", dynamic.int),
		dynamic.field("name", dynamic.string),
		dynamic.field("statements", dynamic.list(smart_filter_statement_decoder())),
		dynamic.field("combination", dynamic.int),
		dynamic.field("sortOptions", smart_filter_sort_options_decoder()),
		dynamic.field("limitTo", dynamic.int),
		fn(_) {
			Ok(for_dashboard)
		},
		fn(_) {
			Ok(order)
		}
	)
}

fn smart_filter_statement_decoder() {
	dynamic.decode3(
		SmartFilterStatement,
		dynamic.field("comparison", dynamic.int),
		dynamic.field("field", dynamic.int),
		dynamic.field("value", dynamic.string),
	)
}

fn smart_filter_sort_options_decoder() {
	dynamic.decode2(
		SmartFilterSortOptions,
		dynamic.field("sortField", dynamic.int),
		dynamic.field("isAscending", dynamic.bool),
	)
}

pub fn encode_smart_filter(filter: SmartFilter) {
	json.object([
		#("id", json.int(filter.id)),
		#("name", json.string(filter.name)),
		#("statements", json.preprocessed_array(list.map(filter.statements, fn(stmt) {
			json.object([
				#("comparison", json.int(stmt.comparison)),
				#("field", json.int(stmt.field)),
				#("value", json.string(stmt.value)),
			])
		}))),
		#("combination", json.int(filter.combination)),
		#("sortOptions", json.object([
			#("sortField", json.int(filter.sort_options.sort_field)),
			#("isAscending", json.bool(filter.sort_options.ascending))
		])),
		#("limitTo", json.int(filter.limit_to))
	])
}
