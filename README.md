# htmz

[![Package Version](https://img.shields.io/hexpm/v/htmz)](https://hex.pm/packages/htmz)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/htmz/)

## Quick start

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```

## Installation

If available on Hex this package can be added to your Gleam project:

```sh
gleam add htmz
```

Its documentation can be found at <https://hexdocs.pm/htmz>.

## Usage

### Examples

```gleam
import htmz.{Html, Title, Head, Body, Div} as z
import gleam/io

pub fn main() {
  let html =
    Html
    |> z.child(
      Body
      |> z.child(
        Div
        |> z.text("Hello World"),
      ),
    )

   html
   |> z.to_string()
   |> io.debug()
}
```

```gleam
fn nav(inner: Htmz) -> Htmz {
  Z(".admins")
  |> z.children([
    Header
    |> z.children([
      H2
      |> z.text("Administratorzy"),
      Menu
      |> z.class("sub-menu")
      |> z.hx_target("#admins-main")
      |> z.hx_push_url("true")
      |> z.hx_indicator("#indicator")
      |> z.hx_sync("closest menu:replace")
      |> z.children([
        Li
        |> z.child(
          Button
          |> z.hx_get("/admin/admins")
          |> z.text("Lista"),
        ),
        Li
        |> z.child(
          Button
          |> z.hx_get("/admin/admins/new")
          |> z.text("Dodaj"),
        ),
      ]),
    ]),
    Z("article#admins-main")
    |> z.child(inner),
  ])
}
```

```gleam

pub fn main() {
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
   |> io.debug()
}
```

### "type=" issue

The "type" is a keyword in gleam, so you can't use it as a field name. Use "type_" instead.

```gleam
Input
|> z.type_("text")
```

### "Z" element

You can use "Z" element to create any element using css selector notation

```gleam
Z("sl-button")
|> z.attr("variant", "success")
|> z.label("Click me")
```

```gleam
Z(".foo#bar[baz=qux]")
// <div class="foo" id="bar" baz="qux"></div>
```

```gleam
Z("i.fa.fa-user")
// <i class="fa fa-user"></i>
```

```gleam
Z("input#password-input.form-control[type=password][name=password]")
// <input id="name-input" class="form-control" type="text" placeholder="Name" />
```

### HTMX support

All [htmx](https://htmx.org) attributes are supported.

```gleam
Button
|> z.HxGet("/load-me")
|> z.HxSwap("outerHTML")
|> z.HxTrigger("load")
```

### Alpine.js support

All [Alpine.js](https://alpinejs.dev/) attributes are supported.

```gleam
Div
|> z.x_data("{ username: 'calebporzio' }")
|> z.children([
  Text("Username: "),
  Strong
  |> z.x_text("username"),
])
```

### Inserting text

Text is just a Text node but it has a value parameter. You can insert text nodes like this:

```gleam
Div |> z.child(Text("Hello World"))
```

However, since this is a common operation, there is a `text(el: Htmz, value: String)` helper function:

```gleam
Div |> z.text("Hello World")
```

The `z.text()` does exactly the same thing as the previous example.

### Conditions

Using `case` you can conditionally render elements:

```gleam
Div
|> z.children([
  H3 
  |> z.text("Title"),
  case maybe_user {
    Ok(user) -> z.text(user.name)
    Error(_) -> z.text("No user")
  }
])
```

Sometimes it's required to not insert anything. In this case, there is a special node: `Nothing`

```gleam
Div
|> z.children([
  H3 |> z.text("Title"),
  case user 
    Ok(user) -> z.text(user.name)
    Error(_) -> Nothing
  }
])
```

For conditionally inserting attributes follow this pattern:

```gleam
Div
|> case is_active {
  True -> z.class(_, "active")
  False -> z.nothing(_)
}
|> z.text("Hello World")
```

