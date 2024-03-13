import gleam/string_builder
import wisp

import lustre/attribute
import lustre/element
import lustre/element/html

import lumiverse/layout
import lumiverse/config

pub fn page(page: element.Element(Nil)) -> wisp.Response {
	html.html([attribute.attribute("data-theme", "dark")], [
		layout.head(),
		html.body([], [
			page,
		]),
	])
	|> element.to_string_builder
	|> string_builder.prepend("<!DOCTYPE html>")
	|> wisp.html_response(200)
}


pub fn login() -> element.Element(Nil) {
	container([
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
			attribute.attribute("type", "submit"),
			attribute.value("Sign In")
		])
	], [
		element.text("New here? "),
		html.a([attribute.href("/register")], [element.text("Register")])
	])
}

fn container(contents: List(element.Element(Nil)), footer: List(element.Element(Nil))) -> element.Element(Nil) {
	html.main([attribute.class("container-fluid flex auth")], [
		html.div([attribute.class("splash")], [
			html.div([attribute.role("group")], [
				html.img([
					attribute.class("logo"),
					attribute.src(config.logo())
				]),
				html.h1([], [element.text(config.name())])
			]),
			html.article([], [
				html.form([], contents),
				html.footer([], footer)
			])
		])
	])
}
