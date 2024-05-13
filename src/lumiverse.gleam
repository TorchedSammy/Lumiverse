import gleam/dict
import gleam/option
import gleam/result
import gleam/list
import gleam/int
import gleam/io
import gleam/order
import gleam/javascript/promise
import gleam/uri
import juno
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre_http as http
import modem

import localstorage
import router as router_handler
import reader_util

import lumiverse/api/api
import lumiverse/api/reader
import lumiverse/api/series as series_req
import lumiverse/model
import lumiverse/models/series as series_model
import lumiverse/models/auth as auth_model
import lumiverse/models/reader as reader_model
import lumiverse/models/router
import lumiverse/layout
import lumiverse/pages/reader as reader_page
import lumiverse/pages/home
import lumiverse/pages/series as series_page
import lumiverse/pages/auth
import lumiverse/pages/not_found
import lumiverse/pages/api_down

pub fn main() {
	let app = lustre.application(init, update, view)
	let assert Ok(_) = lustre.start(app, "#app", 0)
}

fn init(_) {
	let kavita_user = localstorage.read("kavita_user")
	let user = case kavita_user {
		Ok(jsondata) -> {
			case api.decode_login_json(jsondata) {
				Ok(user) -> option.Some(user)
				Error(_) -> {
					localstorage.remove("kavita_user")
					option.None
				}
			}
		}
		Error(_) -> option.None
	}
	io.debug(router_handler.get_route())

	let route = router_handler.uri_to_route(router_handler.get_route())

	let model = model.Model(
		route: route,
		health_failed: option.None,
		user: user,
		auth: model.AuthModel(
			auth_message: "",
			user_details: auth_model.LoginDetails("", "")
		),
		home: model.HomeModel(
			carousel: [],
			carousel_smalldata: []
		),
		metadatas: dict.new(),
		series: dict.new(),
		viewing_series: option.None,
		reader_progress: option.None,
		continue_point: option.None,
		next_chapter: option.None,
		chapter_info: option.None
	)

	#(model, effect.batch([modem.init(on_url_change), api.health()]))
}

fn on_url_change(uri: uri.Uri) -> layout.Msg {
	router_handler.uri_to_route(uri) |> router.ChangeRoute |> layout.Router
}

fn homepage_display(user: option.Option(auth_model.User)) -> Effect(layout.Msg) {
	io.println("im here")
	case user {
		option.None -> {
		io.println("nope")
			effect.none()
		}
		option.Some(user) -> {
			io.println("getting recently added")
			series_req.recently_added(user.token)
		}
	}
}

fn route_effect(model: model.Model, route: router.Route) -> Effect(layout.Msg) {
	let eff = case route {
		router.Home -> homepage_display(model.user)
		router.Logout -> {
			localstorage.remove("kavita_user")
			let assert Ok(home) = uri.parse("/")
			modem.load(home)
		}
		router.Series(id) -> case model.user {
			option.None -> {
				io.println("no siri")
				effect.none()
			}
			option.Some(user) -> {
				io.println("getting serie")
				let id_parsed = int.base_parse(id, 10)
				case id_parsed {
					Ok(id_int) -> series_and_metadata(user.token, id_int)
					Error(_) -> effect.from(fn(dispatch) { router.NotFound |> router.ChangeRoute |> layout.Router |> dispatch})
				}
			}
		}
		router.Reader(id) -> case model.user {
			option.None -> todo as "handle being in reader while not logged in"
			option.Some(user) -> reader.get_progress(user.token, id)
		}
		_ -> effect.none()
	}
}

fn series_and_metadata(token: String, id: Int) -> Effect(layout.Msg) {
	effect.batch([series_req.series(id, token), series_req.metadata(id, token)])
}

fn update(model: model.Model, msg: layout.Msg) -> #(model.Model, Effect(layout.Msg)) {
	case msg {
		layout.Router(router.ChangeRoute(route)) -> {
			#(model.Model(..model, route: route, viewing_series: option.None), route_effect(model, route))
		}
		layout.HealthCheck(Ok(Nil)) -> #(model.Model(..model, health_failed: option.Some(False)), route_effect(model, router_handler.uri_to_route(router_handler.get_route())))
		layout.HealthCheck(Error(_)) -> #(model.Model(..model, health_failed: option.Some(True)), effect.none())
		layout.HomeRecentlyAddedUpdate(Ok(series)) -> {
			case model.user {
				option.Some(user) -> {
					let metadata_fetchers = list.map(series, fn(s: series_model.MinimalInfo) {
						series_req.metadata(s.id, user.token)
					})
					let new_series = dict.from_list(list.map(series, fn(s: series_model.MinimalInfo) {
						#(s.id, s)
					}))
					|> dict.merge(model.series)
					#(model.Model(..model, home: model.HomeModel(..model.home, carousel_smalldata: series), series: new_series), effect.batch(metadata_fetchers))
				}
				option.None -> #(model, effect.none())
			}
		}
		layout.HomeRecentlyAddedUpdate(Error(e)) -> {
			io.println("failure")
			io.debug(e)
			#(model, effect.none())
		}
		layout.SeriesRetrieved(maybe_serie) -> {
			let series_store = case maybe_serie {
				Ok(serie) -> model.series |> dict.insert(serie.id, serie)
				Error(_) -> model.series
			}
			#(model.Model(
				..model,
				viewing_series: option.Some(maybe_serie),
				series: series_store
			), effect.none())
		}
		layout.SeriesMetadataRetrieved(Ok(metadata)) -> {
			#(model.Model(..model, metadatas: model.metadatas |> dict.insert(metadata.id, metadata)), effect.none())
		}
		layout.SeriesMetadataRetrieved(Error(e)) -> {
			io.println("metadata fetch failed")
			io.debug(e)
			#(model, effect.none())
		}
		layout.AuthPage(auth_model.LoginSubmitted) -> {
			#(model, api.login(model.auth.user_details.username, model.auth.user_details.password))
		}
		layout.AuthPage(auth_model.UsernameUpdated(username)) -> {
			#(model.Model(..model, auth: model.AuthModel(..model.auth, user_details: auth_model.LoginDetails(..model.auth.user_details, username: username))), effect.none())
		}
		layout.AuthPage(auth_model.PasswordUpdated(password)) -> {
			#(model.Model(..model, auth: model.AuthModel(..model.auth, user_details: auth_model.LoginDetails(..model.auth.user_details, password: password))), effect.none())
		}
		layout.AuthPage(auth_model.AuthMessage(message)) -> {
			io.println("im infected")
			#(model.Model(..model, auth: model.AuthModel(..model.auth, auth_message: message)), effect.none())
		}
		layout.AuthPage(_) -> #(model, effect.none())
		layout.LoginGot(Ok(user)) -> {
			io.println("we got a user!")
			let assert Ok(home) = uri.parse("/")
			localstorage.write("kavita_user", api.encode_login_json(user))
			#(model.Model(..model, user: option.Some(user)), modem.load(home))
		}
		layout.LoginGot(Error(e)) -> {
			io.println("this is sad")
			let eff = case e {
				http.Unauthorized -> {
					io.println("not authorized??")
					effect.from(fn(dispatch) {
						"Incorrect username or password"
						|> auth_model.AuthMessage
						|> layout.AuthPage
						|> dispatch
					})
				}
				e -> {
					io.debug(e)
					todo as "handle login error not being unauthorized"
				}
			}

			#(model, eff)
		}
		layout.Read -> {
			case model.user {
				option.Some(user) -> {
					let assert option.Some(Ok(serie)) = model.viewing_series
					#(model, reader.continue_point(user.token, serie.id))
				}
				option.None -> todo as "decide what should be done if read is used while not logged in"
			}
		}
		layout.ReaderPrevious -> {
			io.println("WAIT GO BACK")
			let assert option.Some(current_progress) = model.reader_progress
			case current_progress.page_number - 1 {
				-1 -> #(model, effect.none())
				num -> {
					let assert option.Some(user) = model.user
					let advanced_progress = reader_model.Progress(..current_progress, page_number: num)
					reader_util.scroll()
					#(model.Model(..model, reader_progress: option.Some(advanced_progress)), reader.save_progress(user.token, advanced_progress))
				}
			}
		}
		layout.ReaderNext -> {
			io.println("next, reader!")
			let assert option.Some(user) = model.user
			let assert option.Some(current_progress) = model.reader_progress
			let advanced_progress = reader_model.Progress(..current_progress, page_number: current_progress.page_number + 1)
			let assert option.Some(cont_point) = model.continue_point
			case int.compare(advanced_progress.page_number + 1, cont_point.pages) {
				order.Gt -> {
					let assert Ok(next_uri) = case model.next_chapter {
						option.None -> uri.parse("/series/" <> int.to_string(current_progress.series_id))
						option.Some(next_chapter) -> uri.parse("/chapter/" <> int.to_string(next_chapter))
					}
					#(model.Model(..model, reader_progress: option.None), modem.load(next_uri))
				}
				_ -> {
					reader_util.scroll()
					#(model.Model(..model, reader_progress: option.Some(advanced_progress)), reader.save_progress(user.token, advanced_progress))
				}
			}
		}
		layout.NextChapterRetrieved(Ok(next)) -> #(model.Model(..model, next_chapter: option.Some(next)), effect.none())
		layout.NextChapterRetrieved(Error(_)) -> todo as "handle next chapter fail"
		layout.ProgressUpdated(Ok(Nil)) -> #(model, effect.none())
		layout.ProgressUpdated(Error(_)) -> todo as "handle if progress update failed"
		layout.ContinuePointRetrieved(Ok(cont_point)) -> {
			#(model.Model(..model, continue_point: option.Some(cont_point)), case model.route {
				router.Reader(_) -> effect.none()
				_ -> {
					let assert Ok(reader) = uri.parse("/chapter/" <> int.to_string(cont_point.id))
					modem.load(reader)
				}
			})
		}
		layout.ContinuePointRetrieved(Error(_)) -> todo as "handle continue point having an error"
		layout.ProgressRetrieved(Ok(progress)) -> {
			let assert option.Some(user) = model.user
			#(model.Model(
				..model,
				reader_progress: option.Some(progress)
			), reader.chapter_info(user.token, progress.chapter_id))
		}
		layout.ProgressRetrieved(Error(_)) -> todo as "handle progress error??"
		layout.ChapterInfoRetrieved(Ok(inf)) -> {
			let assert option.Some(user) = model.user
			let assert option.Some(prog) = model.reader_progress
			#(model.Model(
				..model,
				chapter_info: option.Some(inf),
				reader_progress: option.Some(reader_model.Progress(
					..prog,
					volume_id: inf.volume_id,
					chapter_id: prog.chapter_id,
					library_id: inf.library_id,
					series_id: inf.series_id
				))
			), effect.batch([
				reader.next_chapter(user.token, inf.series_id, inf.volume_id, prog.chapter_id),
				reader.continue_point(user.token, inf.series_id),
				series_and_metadata(user.token, inf.series_id)]
			))
		}
		layout.ChapterInfoRetrieved(Error(_)) -> todo as "handle chapter info error"
	}
}

fn view(model: model.Model) -> Element(layout.Msg) {
	case model.health_failed {
		option.None -> html.div([], [])
		option.Some(True) -> api_down.page()
		option.Some(False) -> {
			let page = case model.route {
				router.Home -> home.page(model)
				router.Login -> auth.login(model)
				router.Logout -> auth.logout()
				router.Series(id) -> series_page.page(model)
				router.Reader(id) -> reader_page.page(model)
				router.NotFound -> not_found.page()
			}

			let supposed_to_serve = case model.route {
				router.Login -> page
				router.Logout -> page
				router.NotFound -> page
				_ -> html.div([], [
					layout.nav(model),
					page,
				])
			}
		}
	}
}
