import gleam/list as gleam_list
import gleam/option.{Some}
import gleam/string
import htmz/selector_parser.{ParseResult, parse_css_selector}

pub type Attr {
  Attr(name: String, value: String)
}

type ElTuple =
  #(String, List(Attr), List(Htmz))

pub type Htmz {
  El(tag: String, attrs: List(Attr), children: List(Htmz))
  Z(css_selector: String)
  Text(text: String)
  Nothing

  Html
  Head
  Title
  Body
  Div
  Form
  Label
  Input
  A
  Link
  Meta
  Abbr
  Address
  Article
  Aside
  Audio
  B
  Bdi
  Bdo
  Blockquote
  Br
  Button
  Canvas
  Caption
  Cite
  Code
  Col
  Colgroup
  Data
  Datalist
  Dd
  Del
  Details
  Dfn
  Dialog
  Dl
  Dt
  Em
  Embed
  Fieldset
  Figcaption
  Figure
  Footer
  H1
  H2
  H3
  H4
  H5
  H6
  Header
  Hr
  I
  Iframe
  Img
  Ins
  Kbd
  Legend
  Li
  Main
  Mark
  Menu
  Menuitem
  Meter
  Nav
  Noscript
  Object
  Ol
  Optgroup
  Option
  Output
  P
  Param
  Picture
  Pre
  Progress
  Q
  Rp
  Rt
  Ruby
  S
  Samp
  Script
  Section
  Select
  Slot
  Small
  Source
  Span
  Strong
  Sub
  Summary
  Sup
  Table
  Tbody
  Td
  Template
  Textarea
  Tfoot
  Th
  Thead
  Time
  Tr
  Track
  U
  Ul
  Var
  Video
  Wbr
}

pub fn escape(content: String) -> String {
  do_escape("", content)
}

/// Taken from "HTMB" library, written by @lpil
fn do_escape(escaped: String, content: String) -> String {
  case string.pop_grapheme(content) {
    Ok(#("<", xs)) -> do_escape(escaped <> "&lt;", xs)
    Ok(#(">", xs)) -> do_escape(escaped <> "&gt;", xs)
    Ok(#("&", xs)) -> do_escape(escaped <> "&amp;", xs)
    Ok(#(x, xs)) -> do_escape(escaped <> x, xs)
    Error(_) -> escaped <> content
  }
}

fn children_to_string(children: List(Htmz)) -> String {
  children
  |> gleam_list.map(to_string)
  |> string.join("")
}

fn attrs_to_string(attrs: List(Attr)) -> String {
  let str =
    attrs
    |> gleam_list.map(fn(attr) {
      let name = string.lowercase(attr.name)
      case name {
        "" -> ""
        _ ->
          case attr.value {
            "" -> name
            _ -> name <> "=\"" <> escape(attr.value) <> "\""
          }
      }
    })
    |> string.join(" ")

  case str {
    "" -> ""
    _ -> " " <> str
  }
}

pub fn to_string(el: Htmz) -> String {
  case el {
    Text(text) -> escape(text)
    _ -> {
      let #(tag, attrs, children) = to_tuple(el)

      case tag {
        "" -> ""

        "input" | "br" | "hr" | "img" | "link" | "meta" -> {
          "<" <> tag <> attrs_to_string(attrs) <> "/>\n"
        }

        _ -> {
          "<"
          <> tag
          <> attrs_to_string(attrs)
          <> ">\n"
          <> children_to_string(children)
          <> "</"
          <> tag
          <> ">"
        }
      }
    }
  }
}

fn to_tuple(el: Htmz) -> ElTuple {
  case el {
    El(tag, attrs, children) -> #(tag, attrs, children)
    Z(css_selector) -> {
      let assert Some(ParseResult(tag, attrs)) =
        parse_css_selector(css_selector)

      let attrs = gleam_list.map(attrs, fn(t) { Attr(t.0, t.1) })

      #(tag, attrs, [])
    }
    Text(_) -> #("", [], [])
    Nothing -> #("", [], [])
    Html -> #("html", [], [])
    Head -> #("head", [], [])
    Title -> #("title", [], [])
    Body -> #("body", [], [])
    Div -> #("div", [], [])
    Form -> #("form", [], [])
    Label -> #("label", [], [])
    Input -> #("input", [], [])
    A -> #("a", [], [])
    Link -> #("link", [], [])
    Meta -> #("meta", [], [])
    Abbr -> #("abbr", [], [])
    Address -> #("address", [], [])
    Article -> #("article", [], [])
    Aside -> #("aside", [], [])
    Audio -> #("audio", [], [])
    B -> #("b", [], [])
    Bdi -> #("bdi", [], [])
    Bdo -> #("bdo", [], [])
    Blockquote -> #("blockquote", [], [])
    Br -> #("br", [], [])
    Button -> #("button", [], [])
    Canvas -> #("canvas", [], [])
    Caption -> #("caption", [], [])
    Cite -> #("cite", [], [])
    Code -> #("code", [], [])
    Col -> #("col", [], [])
    Colgroup -> #("colgroup", [], [])
    Data -> #("data", [], [])
    Datalist -> #("datalist", [], [])
    Dd -> #("dd", [], [])
    Del -> #("del", [], [])
    Details -> #("details", [], [])
    Dfn -> #("dfn", [], [])
    Dialog -> #("dialog", [], [])
    Dl -> #("dl", [], [])
    Dt -> #("dt", [], [])
    Em -> #("em", [], [])
    Embed -> #("embed", [], [])
    Fieldset -> #("fieldset", [], [])
    Figcaption -> #("figcaption", [], [])
    Figure -> #("figure", [], [])
    Footer -> #("footer", [], [])
    H1 -> #("h1", [], [])
    H2 -> #("h2", [], [])
    H3 -> #("h3", [], [])
    H4 -> #("h4", [], [])
    H5 -> #("h5", [], [])
    H6 -> #("h6", [], [])
    Header -> #("header", [], [])
    Hr -> #("hr", [], [])
    I -> #("i", [], [])
    Iframe -> #("iframe", [], [])
    Img -> #("img", [], [])
    Ins -> #("ins", [], [])
    Kbd -> #("kbd", [], [])
    Legend -> #("legend", [], [])
    Li -> #("li", [], [])
    Main -> #("main", [], [])
    Mark -> #("mark", [], [])
    Menu -> #("menu", [], [])
    Menuitem -> #("menuitem", [], [])
    Meter -> #("meter", [], [])
    Nav -> #("nav", [], [])
    Noscript -> #("noscript", [], [])
    Object -> #("object", [], [])
    Ol -> #("ol", [], [])
    Optgroup -> #("optgroup", [], [])
    Option -> #("option", [], [])
    Output -> #("output", [], [])
    P -> #("p", [], [])
    Param -> #("param", [], [])
    Picture -> #("picture", [], [])
    Pre -> #("pre", [], [])
    Progress -> #("progress", [], [])
    Q -> #("q", [], [])
    Rp -> #("rp", [], [])
    Rt -> #("rt", [], [])
    Ruby -> #("ruby", [], [])
    S -> #("s", [], [])
    Samp -> #("samp", [], [])
    Script -> #("script", [], [])
    Section -> #("section", [], [])
    Select -> #("select", [], [])
    Slot -> #("slot", [], [])
    Small -> #("small", [], [])
    Source -> #("source", [], [])
    Span -> #("span", [], [])
    Strong -> #("strong", [], [])
    Sub -> #("sub", [], [])
    Summary -> #("summary", [], [])
    Sup -> #("sup", [], [])
    Table -> #("table", [], [])
    Tbody -> #("tbody", [], [])
    Td -> #("td", [], [])
    Template -> #("template", [], [])
    Textarea -> #("textarea", [], [])
    Tfoot -> #("tfoot", [], [])
    Th -> #("th", [], [])
    Thead -> #("thead", [], [])
    Time -> #("time", [], [])
    Tr -> #("tr", [], [])
    Track -> #("track", [], [])
    U -> #("u", [], [])
    Ul -> #("ul", [], [])
    Var -> #("var", [], [])
    Video -> #("video", [], [])
    Wbr -> #("wbr", [], [])
  }
}

pub fn children(el: Htmz, children: List(Htmz)) -> Htmz {
  let #(tag, attrs, _) = to_tuple(el)
  El(tag, attrs, children)
}

pub fn child(el: Htmz, child: Htmz) -> Htmz {
  let #(tag, attrs, children) = to_tuple(el)
  El(tag, attrs, [child, ..children])
}

//
// ATTRIBUTES
//

pub fn remove_attr(el: Htmz, attr_name: String) -> Htmz {
  let #(tag, attrs, children) = to_tuple(el)
  let attrs =
    attrs
    |> gleam_list.filter(fn(attr) { attr.name != attr_name })
  El(tag, attrs, children)
}

pub fn attr(el: Htmz, attr_name: String, attr_value: String) -> Htmz {
  let #(tag, attrs, children) =
    el
    |> remove_attr(attr_name)
    |> to_tuple()

  let attrs = [Attr(attr_name, attr_value), ..attrs]

  El(tag, attrs, children)
}

pub fn nothing(el: Htmz) -> Htmz {
  attr(el, "", "")
}

pub fn text(el: Htmz, text: String) -> Htmz {
  child(el, Text(text))
}

pub fn accept(el: Htmz, value: String) -> Htmz {
  attr(el, "accept", value)
}

pub fn accept_charset(el: Htmz, value: String) -> Htmz {
  attr(el, "acceptCharset", value)
}

pub fn accesskey(el: Htmz, value: String) -> Htmz {
  attr(el, "accesskey", value)
}

pub fn action(el: Htmz, value: String) -> Htmz {
  attr(el, "action", value)
}

pub fn alt(el: Htmz, value: String) -> Htmz {
  attr(el, "alt", value)
}

pub fn async_attr(el: Htmz, value: String) -> Htmz {
  attr(el, "async", value)
}

pub fn autocapitalize(el: Htmz, value: String) -> Htmz {
  attr(el, "autocapitalize", value)
}

pub fn autofocus(el: Htmz, value: String) -> Htmz {
  attr(el, "autofocus", value)
}

pub fn autocomplete(el: Htmz, value: String) -> Htmz {
  attr(el, "autocomplete", value)
}

pub fn charset(el: Htmz, value: String) -> Htmz {
  attr(el, "charset", value)
}

pub fn checked(el: Htmz, value: String) -> Htmz {
  attr(el, "checked", value)
}

pub fn class(el: Htmz, value: String) -> Htmz {
  attr(el, "class", value)
}

pub fn cols(el: Htmz, value: String) -> Htmz {
  attr(el, "cols", value)
}

pub fn columngap(el: Htmz, value: String) -> Htmz {
  attr(el, "columngap", value)
}

pub fn colspan(el: Htmz, value: String) -> Htmz {
  attr(el, "colspan", value)
}

pub fn content(el: Htmz, value: String) -> Htmz {
  attr(el, "content", value)
}

pub fn contenteditable(el: Htmz, value: String) -> Htmz {
  attr(el, "contenteditable", value)
}

pub fn contextmenu(el: Htmz, value: String) -> Htmz {
  attr(el, "contextmenu", value)
}

pub fn controls(el: Htmz, value: String) -> Htmz {
  attr(el, "controls", value)
}

pub fn coords(el: Htmz, value: String) -> Htmz {
  attr(el, "coords", value)
}

pub fn crossorigin(el: Htmz, value: String) -> Htmz {
  attr(el, "crossorigin", value)
}

pub fn data(el: Htmz, key: String, value: String) -> Htmz {
  attr(el, "data-" <> key, value)
}

pub fn datetime(el: Htmz, value: String) -> Htmz {
  attr(el, "datetime", value)
}

pub fn defer(el: Htmz) -> Htmz {
  attr(el, "defer", "")
}

pub fn dir(el: Htmz, value: String) -> Htmz {
  attr(el, "dir", value)
}

pub fn dirname(el: Htmz, value: String) -> Htmz {
  attr(el, "dirname", value)
}

pub fn disabled(el: Htmz) -> Htmz {
  attr(el, "disabled", "")
}

pub fn download(el: Htmz, value: String) -> Htmz {
  attr(el, "download", value)
}

pub fn draggable(el: Htmz, value: String) -> Htmz {
  attr(el, "draggable", value)
}

pub fn dropzone(el: Htmz, value: String) -> Htmz {
  attr(el, "dropzone", value)
}

pub fn enctype(el: Htmz, value: String) -> Htmz {
  attr(el, "enctype", value)
}

pub fn enterkeyhint(el: Htmz, value: String) -> Htmz {
  attr(el, "enterkeyhint", value)
}

pub fn for(el: Htmz, value: String) -> Htmz {
  attr(el, "for", value)
}

pub fn formaction(el: Htmz, value: String) -> Htmz {
  attr(el, "formaction", value)
}

pub fn formenctype(el: Htmz, value: String) -> Htmz {
  attr(el, "formenctype", value)
}

pub fn formmethod(el: Htmz, value: String) -> Htmz {
  attr(el, "formmethod", value)
}

pub fn formnovalidate(el: Htmz, value: String) -> Htmz {
  attr(el, "formnovalidate", value)
}

pub fn formtarget(el: Htmz, value: String) -> Htmz {
  attr(el, "formtarget", value)
}

pub fn frameborder(el: Htmz, value: String) -> Htmz {
  attr(el, "frameborder", value)
}

pub fn headers(el: Htmz, value: String) -> Htmz {
  attr(el, "headers", value)
}

pub fn height(el: Htmz, value: String) -> Htmz {
  attr(el, "height", value)
}

pub fn hidden(el: Htmz, value: String) -> Htmz {
  attr(el, "hidden", value)
}

pub fn high(el: Htmz, value: String) -> Htmz {
  attr(el, "high", value)
}

pub fn href(el: Htmz, value: String) -> Htmz {
  attr(el, "href", value)
}

pub fn hreflang(el: Htmz, value: String) -> Htmz {
  attr(el, "hreflang", value)
}

pub fn http_equiv(el: Htmz, value: String) -> Htmz {
  attr(el, "httpEquiv", value)
}

pub fn id(el: Htmz, value: String) -> Htmz {
  attr(el, "id", value)
}

pub fn inputmode(el: Htmz, value: String) -> Htmz {
  attr(el, "inputmode", value)
}

pub fn integrity(el: Htmz, value: String) -> Htmz {
  attr(el, "integrity", value)
}

pub fn is(el: Htmz, value: String) -> Htmz {
  attr(el, "is", value)
}

pub fn ismap(el: Htmz, value: String) -> Htmz {
  attr(el, "ismap", value)
}

pub fn kind(el: Htmz, value: String) -> Htmz {
  attr(el, "kind", value)
}

pub fn label(el: Htmz, value: String) -> Htmz {
  attr(el, "label", value)
}

pub fn lang(el: Htmz, value: String) -> Htmz {
  attr(el, "lang", value)
}

pub fn language(el: Htmz, value: String) -> Htmz {
  attr(el, "language", value)
}

pub fn list(el: Htmz, value: String) -> Htmz {
  attr(el, "list", value)
}

pub fn loop_attr(el: Htmz, value: String) -> Htmz {
  attr(el, "loop", value)
}

pub fn low(el: Htmz, value: String) -> Htmz {
  attr(el, "low", value)
}

pub fn max(el: Htmz, value: String) -> Htmz {
  attr(el, "max", value)
}

pub fn maxlength(el: Htmz, value: String) -> Htmz {
  attr(el, "maxlength", value)
}

pub fn method(el: Htmz, value: String) -> Htmz {
  attr(el, "method", value)
}

pub fn min(el: Htmz, value: String) -> Htmz {
  attr(el, "min", value)
}

pub fn minlength(el: Htmz, value: String) -> Htmz {
  attr(el, "minlength", value)
}

pub fn multiple(el: Htmz, value: String) -> Htmz {
  attr(el, "multiple", value)
}

pub fn name(el: Htmz, value: String) -> Htmz {
  attr(el, "name", value)
}

pub fn novalidate(el: Htmz, value: String) -> Htmz {
  attr(el, "novalidate", value)
}

pub fn on(el: Htmz, event: String, value: String) -> Htmz {
  attr(el, "on" <> event, value)
}

pub fn open(el: Htmz, value: String) -> Htmz {
  attr(el, "open", value)
}

pub fn pattern(el: Htmz, value: String) -> Htmz {
  attr(el, "pattern", value)
}

pub fn placeholder(el: Htmz, value: String) -> Htmz {
  attr(el, "placeholder", value)
}

pub fn poster(el: Htmz, value: String) -> Htmz {
  attr(el, "poster", value)
}

pub fn preload(el: Htmz, value: String) -> Htmz {
  attr(el, "preload", value)
}

pub fn readonly(el: Htmz, value: String) -> Htmz {
  attr(el, "readonly", value)
}

pub fn rel(el: Htmz, value: String) -> Htmz {
  attr(el, "rel", value)
}

pub fn required(el: Htmz) -> Htmz {
  attr(el, "required", "")
}

pub fn reversed(el: Htmz, value: String) -> Htmz {
  attr(el, "reversed", value)
}

pub fn rows(el: Htmz, value: String) -> Htmz {
  attr(el, "rows", value)
}

pub fn rowspan(el: Htmz, value: String) -> Htmz {
  attr(el, "rowspan", value)
}

pub fn sandbox(el: Htmz, value: String) -> Htmz {
  attr(el, "sandbox", value)
}

pub fn scope(el: Htmz, value: String) -> Htmz {
  attr(el, "scope", value)
}

pub fn selected(el: Htmz) -> Htmz {
  attr(el, "selected", "")
}

pub fn shape(el: Htmz, value: String) -> Htmz {
  attr(el, "shape", value)
}

pub fn size(el: Htmz, value: String) -> Htmz {
  attr(el, "size", value)
}

pub fn sizes(el: Htmz, value: String) -> Htmz {
  attr(el, "sizes", value)
}

pub fn slot(el: Htmz, value: String) -> Htmz {
  attr(el, "slot", value)
}

pub fn spellcheck(el: Htmz, value: String) -> Htmz {
  attr(el, "spellcheck", value)
}

pub fn src(el: Htmz, value: String) -> Htmz {
  attr(el, "src", value)
}

pub fn srcdoc(el: Htmz, value: String) -> Htmz {
  attr(el, "srcdoc", value)
}

pub fn srclang(el: Htmz, value: String) -> Htmz {
  attr(el, "srclang", value)
}

pub fn start(el: Htmz, value: String) -> Htmz {
  attr(el, "start", value)
}

pub fn step(el: Htmz, value: String) -> Htmz {
  attr(el, "step", value)
}

pub fn style(el: Htmz, value: String) -> Htmz {
  attr(el, "style", value)
}

pub fn tabindex(el: Htmz, value: String) -> Htmz {
  attr(el, "tabindex", value)
}

pub fn target(el: Htmz, value: String) -> Htmz {
  attr(el, "target", value)
}

pub fn title(el: Htmz, value: String) -> Htmz {
  attr(el, "title", value)
}

pub fn translate(el: Htmz, value: String) -> Htmz {
  attr(el, "translate", value)
}

pub fn type_(el: Htmz, value: String) -> Htmz {
  attr(el, "type", value)
}

pub fn usemap(el: Htmz, value: String) -> Htmz {
  attr(el, "usemap", value)
}

pub fn value(el: Htmz, value: String) -> Htmz {
  attr(el, "value", value)
}

pub fn width(el: Htmz, value: String) -> Htmz {
  attr(el, "width", value)
}

pub fn wrap(el: Htmz, value: String) -> Htmz {
  attr(el, "wrap", value)
}

pub fn hx_boost(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-boost", value)
}

pub fn hx_confirm(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-confirm", value)
}

pub fn hx_delete(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-delete", value)
}

pub fn hx_disabled_elt(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-disabled-elt", value)
}

pub fn hx_sync(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-sync", value)
}

pub fn hx_disinherit(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-disinherit", value)
}

pub fn hx_encoding(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-encoding", value)
}

pub fn hx_ext(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-ext", value)
}

pub fn hx_get(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-get", value)
}

pub fn hx_headers(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-headers", value)
}

pub fn hx_history(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-history", value)
}

pub fn hx_history_elt(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-history-elt", value)
}

pub fn hx_include(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-include", value)
}

pub fn hx_indicator(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-indicator", value)
}

pub fn hx_on(el: Htmz, event: String, value: String) -> Htmz {
  attr(el, "hx-on:" <> event, value)
}

pub fn hx_params(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-params", value)
}

pub fn hx_post(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-post", value)
}

pub fn hx_put(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-put", value)
}

pub fn hx_patch(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-patch", value)
}

pub fn hx_push_url(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-push-url", value)
}

pub fn hx_select(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-select", value)
}

pub fn hx_select_oob(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-select-oob", value)
}

pub fn hx_swap(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-swap", value)
}

pub fn hx_swap_oob(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-swap-oob", value)
}

pub fn hx_target(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-target", value)
}

pub fn hx_trigger(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-trigger", value)
}

pub fn hx_vals(el: Htmz, value: String) -> Htmz {
  attr(el, "hx-vals", value)
}

pub fn x_data(el: Htmz, value: String) -> Htmz {
  attr(el, "x-data", value)
}

pub fn x_init(el: Htmz, value: String) -> Htmz {
  attr(el, "x-init", value)
}

pub fn x_show(el: Htmz, value: String) -> Htmz {
  attr(el, "x-show", value)
}

pub fn x_bind(el: Htmz, field: String, value: String) -> Htmz {
  attr(el, "x-bind:" <> field, value)
}

pub fn x_on(el: Htmz, event: String, value: String) -> Htmz {
  attr(el, "x-on:" <> event, value)
}

pub fn x_text(el: Htmz, value: String) -> Htmz {
  attr(el, "x-text", value)
}

pub fn x_html(el: Htmz, value: String) -> Htmz {
  attr(el, "x-html", value)
}

pub fn x_model(el: Htmz, value: String) -> Htmz {
  attr(el, "x-model", value)
}

pub fn x_modelable(el: Htmz, value: String) -> Htmz {
  attr(el, "x-modelable", value)
}

pub fn x_for(el: Htmz, value: String) -> Htmz {
  attr(el, "x-for", value)
}

pub fn x_transition(el: Htmz) -> Htmz {
  attr(el, "x-transition", "")
}

pub fn x_transition_a(el: Htmz, modifier: String, value: String) -> Htmz {
  attr(el, "x-transition:" <> modifier, value)
}

pub fn x_effect(el: Htmz, value: String) -> Htmz {
  attr(el, "x-effect", value)
}

pub fn x_ignore(el: Htmz, value: String) -> Htmz {
  attr(el, "x-ignore", value)
}

pub fn x_ref(el: Htmz, value: String) -> Htmz {
  attr(el, "x-ref", value)
}

pub fn x_cloak(el: Htmz, value: String) -> Htmz {
  attr(el, "x-cloak", value)
}

pub fn x_teleport(el: Htmz, value: String) -> Htmz {
  attr(el, "x-teleport", value)
}

pub fn x_if(el: Htmz, value: String) -> Htmz {
  attr(el, "x-if", value)
}

pub fn x_id(el: Htmz, value: String) -> Htmz {
  attr(el, "x-id", value)
}
