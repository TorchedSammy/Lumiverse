import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

import lumiverse/model
import lumiverse/layout
import lumiverse/config
import lumiverse/models/auth

pub fn login(model: model.Model) -> element.Element(layout.Msg) {
	container([
		html.div([attribute.class("card border-0 border-top border-primary border-4")], [
			html.div([attribute.class("auth-content")], [
				html.h1([], [element.text("Sign in to your account")]),
				html.p([attribute.class("text-primary mb-2")], [element.text(model.auth.auth_message)]),
				html.form([], [
					html.div([attribute.class("mb-3")], [
						html.label([attribute.class("form-label")], [element.text("Username")]),
						html.input([
							attribute.attribute("type", "username"),
							attribute.class("form-control border-0 focus-ring bg-secondary"),
							event.on_input(fn(a) {
								layout.AuthPage(auth.UsernameUpdated(a))
							})
						])
					]),
					html.div([attribute.class("mb-3")], [
						html.label([attribute.class("form-label")], [element.text("Password")]),
						html.input([
							attribute.attribute("type", "password"),
							attribute.class("form-control border-0 focus-ring bg-secondary"),
							event.on_input(fn(a) {
								layout.AuthPage(auth.PasswordUpdated(a))
							})
						])
					]),
					html.a([attribute.href("/recover"), attribute.class("text-primary")], [element.text("Forgot your password?")]),
				]),
				html.div([attribute.class("mb-3 mt-3")], [
					html.button([
						attribute.attribute("type", "submit"),
						attribute.class("btn btn-primary"),
						event.on_click(layout.AuthPage(auth.LoginSubmitted))],
						[element.text("Sign In")
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

pub fn logout() -> element.Element(layout.Msg) {
	container([
		html.div([attribute.class("card border-0 border-top border-primary border-4")], [
			html.div([attribute.class("auth-content")], [
				html.h1([], [element.text("Signing out...")])
			])
		])
	])
}

fn container(contents: List(element.Element(layout.Msg))) -> element.Element(layout.Msg) {
	html.main([attribute.class("container-fluid d-flex auth fullscreen align-items-center justify-content-center")], [
		html.div([attribute.class("splash")], [
			html.div([attribute.class("d-flex auth-head mb-5 justify-content-center")], [
				html.img([
					attribute.class("logo"),
					attribute.src(config.logo())
				]),
				html.h1([attribute.class("mb-0")], [element.text(config.name())])
			]),
			html.article([], contents)
		])
	])
}
