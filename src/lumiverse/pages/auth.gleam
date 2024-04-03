import lustre/attribute
import lustre/element
import lustre/element/html
import lustre/event

import lumiverse/layout
import lumiverse/config
import lumiverse/models/auth

pub fn login() -> element.Element(layout.Msg) {
	container([
		html.form([], [
			html.h2([], [element.text("Sign in to your account")]),
			html.fieldset([attribute.class("credentials")], [
				html.label([], [
					element.text("Username"),
					html.input([
						attribute.name("username"),
						attribute.autocomplete("nickname")
					])
				]),
				html.label([], [
					element.text("Password"),
					html.input([
						attribute.name("pass"),
						attribute.attribute("type", "password")
					])
				]),
			]),
			html.fieldset([attribute.class("credentials-actions")], [
				html.label([], [
					html.input([
						attribute.attribute("type", "checkbox"),
					]),
					element.text("Remember Me")
				]),
				html.a([attribute.href("/recover")], [element.text("Forgot Password?")])
			]),
			html.input([
				attribute.attribute("type", "button"),
				attribute.attribute("value", "Sign In"),
				event.on_submit(layout.AuthPage(auth.LoginSubmitted))
			])
		]),
		html.footer([], [
			element.text("New here? "),
			html.a([attribute.href("/register")], [element.text("Register")])
		])
	])
}

fn container(contents: List(element.Element(layout.Msg))) -> element.Element(layout.Msg) {
	html.main([attribute.class("container-fluid flex auth")], [
		html.div([attribute.class("splash")], [
			html.div([attribute.role("group")], [
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
