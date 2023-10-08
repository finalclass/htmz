import gleeunit
import gleeunit/should
import gleam/string
import htmz.{
  A, Body, Div, H1, Head, Html, Input, Label, Li, Main, Menu, Meta, Title, Z,
} as z

pub fn main() {
  gleeunit.main()
}

pub fn basic_usage_test() {
  let el =
    Html
    |> z.child(
      Body
      |> z.child(
        Div
        |> z.text("Hello World"),
      ),
    )

  el
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal("<html><body><div>Hello World</div></body></html>")
}

pub fn self_closing_tags_test() {
  let el =
    Div
    |> z.children([
      Label
      |> z.for("name")
      |> z.text("Name"),
      Input
      |> z.value("Hello World")
      |> z.type_("text"),
    ])

  el
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal(
    "<div><label for=\"name\">Name</label><input type=\"text\" value=\"Hello World\"/></div>",
  )
}

pub fn full_page_test() {
  let el =
    Html
    |> z.children([
      Head
      |> z.children([
        Title
        |> z.text("Hello World"),
        Meta
        |> z.charset("utf-8"),
      ]),
      Body
      |> z.children([
        Menu
        |> z.children([
          Li
          |> z.child(
            A
            |> z.href("/about")
            |> z.text("About"),
          ),
          Li
          |> z.child(
            A
            |> z.href("/contact")
            |> z.text("Contact"),
          ),
        ]),
        Main
        |> z.children([
          H1
          |> z.text("Hello World"),
        ]),
      ]),
    ])

  el
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal(
    "<html><head><title>Hello World</title><meta charset=\"utf-8\"/></head><body><menu><li><a href=\"/about\">About</a></li><li><a href=\"/contact\">Contact</a></li></menu><main><h1>Hello World</h1></main></body></html>",
  )
}

pub fn z_test() {
  let str = Z(".foo#bar[baz=qux]")

  str
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal("<div class=\"foo\" id=\"bar\" baz=\"qux\"></div>")
}
