import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

import lumiverse/layout
import lumiverse/config
import lumiverse/models/auth

pub fn login() -> element.Element(layout.Msg) {
	container([
		html.div([attribute.class("card border-0 border-top border-primary border-4")], [
			html.div([attribute.class("auth-content")], [
				html.h1([], [element.text("Sign in to your account")]),
				html.form([], [
					html.div([attribute.class("mb-3")], [
						html.label([attribute.class("form-label")], [element.text("Username")]),
						html.input([attribute.attribute("type", "username"), attribute.class("form-control border-0 focus-ring bg-secondary")])
					]),
					html.div([attribute.class("mb-3")], [
						html.label([attribute.class("form-label")], [element.text("Password")]),
						html.input([attribute.attribute("type", "password"), attribute.class("form-control border-0 focus-ring bg-secondary")])
					]),
					html.a([attribute.href("/recover"), attribute.class("text-primary")], [element.text("Forgot your password?")]),
					html.div([attribute.class("mb-3 mt-3")], [
						html.button([attribute.attribute("type", "submit"), attribute.class("btn btn-primary"), event.on_submit(layout.AuthPage(auth.LoginSubmitted))], [element.text("Sign In")])
					])
				])
			]),
			html.div([attribute.class("card-footer justify-content-center border-0")], [
				html.p([attribute.class("text-secondary")], [
					element.text("New here? "),
					html.a([attribute.href("/register"), attribute.class("text-primary")], [element.text("Register")])
				])
			])
		])
	])
}

fn container(contents: List(element.Element(layout.Msg))) -> element.Element(layout.Msg) {
	html.main([attribute.class("container-fluid d-flex auth fullscreen align-items-center justify-content-center")], [
		html.div([attribute.class("splash")], [
			html.div([attribute.class("auth-head d-flex mb-5 justify-content-center align-items-baseline")], [
				html.img([
					attribute.class("logo"),
					attribute.src(config.logo())
				]),
				html.h1([], [element.text(config.name())])
			]),
			html.article([], contents)
		])
	])
}
