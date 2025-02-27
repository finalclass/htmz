import gleeunit
import gleeunit/should
import gleam/string
import htmz.{
  A, Body, Div, H1, Head, Html, Input, Label, Li, Main, Menu, Meta, Nothing, Text, Title, Z,
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

pub fn z_custom_element_test() {
  let str = Z("custom-element.foo#bar[attr=value]")

  str
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal("<custom-element class=\"foo\" id=\"bar\" attr=\"value\"></custom-element>")
}

pub fn z_multiple_classes_test() {
  let str = Z("div.class1.class2.class3")

  str
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal("<div class=\"class1 class2 class3\"></div>")
}

pub fn z_multiple_attributes_test() {
  let str = Z("input[type=text][name=username][placeholder=Enter username]")

  str
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal("<input placeholder=\"Enter username\" name=\"username\" type=\"text\"/>")
}

pub fn conditional_rendering_test() {
  let has_user = True
  let username = "testuser"

  let el = 
    Div
    |> z.children([
      H1
      |> z.text("Profile"),
      case has_user {
        True -> Div
          |> z.class("user-info")
          |> z.text("Welcome, " <> username)
        False -> Nothing
      }
    ])

  el
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal("<div><h1>Profile</h1><div class=\"user-info\">Welcome, testuser</div></div>")
}

pub fn nothing_element_test() {
  let el =
    Div
    |> z.children([
      H1
      |> z.text("Header"),
      Nothing,
      Text("Footer")
    ])

  el
  |> z.to_string()
  |> string.replace("\n", "")
  |> should.equal("<div><h1>Header</h1>Footer</div>")
}
