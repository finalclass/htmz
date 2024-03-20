import gleam/result
import gleam/io
import gleam/list
import gleam/iterator
import gleam/string
import gleam/option.{None, type Option, Some, map}

pub type ParseResult {
  ParseResult(tag_name: String, attrs: List(#(String, String)))
}

type SymbolType {
  Tag
  Class
  Id
  AttributeName
  AttributeValue
}

type ParseAcc {
  ParseAcc(
    tag_name: String,
    attrs: List(#(String, String)),
    word: String,
    attr_name: String,
    symbol_type: SymbolType,
    classes: List(String),
  )
}

pub fn parse_css_selector(css_selector: String) -> Option(ParseResult) {
  let acc =
    string.to_graphemes(css_selector)
    |> iterator.from_list()
    |> iterator.fold(
      from: Some(ParseAcc(
        tag_name: "",
        attr_name: "",
        classes: [],
        attrs: [],
        word: "",
        symbol_type: Tag,
      )),
      with: fn(acc, char) {
        case acc {
          None -> None
          Some(acc) -> {
            process_char(acc, char)
          }
        }
      },
    )

  case acc {
    None -> None
    Some(acc) -> {
      let acc = finish_prefix(acc)
      use acc <- map(acc)
      let attrs = case list.is_empty(acc.classes) {
        True -> acc.attrs
        False -> {
          let class_in_attr = case find_class_in_attrs(acc.attrs) {
            "" -> ""
            cls -> cls <> " "
          }

          let cls =
            class_in_attr <> {
              acc.classes
              |> list.unique()
              |> list.reverse()
              |> string.join(with: " ")
            }

          [
            #("class", cls),
            ..acc.attrs
            |> list.reverse()
          ]
        }
      }

      ParseResult(tag_name: tag_name(acc.tag_name), attrs: attrs)
    }
  }
}

fn find_class_in_attrs(attrs: List(#(String, String))) -> String {
  let class_attr =
    attrs
    |> list.find(fn(attr) {
      case attr {
        #("class", _) -> True
        _ -> False
      }
    })
    |> result.unwrap(#("", ""))

  case class_attr {
    #("class", cls) -> cls
    _ -> ""
  }
}

fn process_char(acc: ParseAcc, char: String) -> Option(ParseAcc) {
  case char {
    "#" -> {
      case acc.symbol_type {
        Tag ->
          Some(
            ParseAcc(
              ..acc,
              tag_name: tag_name(acc.word),
              word: "",
              symbol_type: Id,
            ),
          )
        Class -> {
          let classes = [acc.word, ..acc.classes]
          Some(ParseAcc(..acc, classes: classes, symbol_type: Id, word: ""))
        }
        _ -> {
          io.debug(#("failed1", acc))
          None
        }
      }
    }

    "." ->
      map(finish_prefix(acc), fn(acc) { ParseAcc(..acc, symbol_type: Class) })

    "[" ->
      map(
        finish_prefix(acc),
        fn(acc) { ParseAcc(..acc, symbol_type: AttributeName) },
      )

    "=" ->
      map(
        finish_prefix(acc),
        fn(acc) { ParseAcc(..acc, symbol_type: AttributeValue) },
      )

    "]" ->
      map(finish_prefix(acc), fn(acc) { ParseAcc(..acc, symbol_type: Tag) })
    _ ->
      case acc.symbol_type {
        AttributeName -> Some(ParseAcc(..acc, attr_name: acc.attr_name <> char))
        _ -> Some(ParseAcc(..acc, word: acc.word <> char))
      }
  }
}

fn finish_prefix(acc: ParseAcc) -> Option(ParseAcc) {
  case acc.symbol_type {
    Tag -> {
      let tag = case acc.tag_name {
        "" -> tag_name(acc.word)
        _ -> acc.tag_name
      }

      Some(ParseAcc(..acc, tag_name: tag, word: ""))
    }
    Id -> {
      Some(ParseAcc(..acc, attrs: [#("id", acc.word), ..acc.attrs], word: ""))
    }
    Class -> {
      case acc.word {
        "" -> {
          io.debug(#("failed2", acc))
          None
        }
        _ -> Some(ParseAcc(..acc, classes: [acc.word, ..acc.classes], word: ""))
      }
    }
    AttributeName -> {
      case acc.tag_name {
        "" -> {
          io.debug(#("failed3", acc))
          None
        }
        _ -> Some(acc)
      }
    }
    AttributeValue -> {
      case acc.word {
        "" -> {
          io.debug(#("failed4", acc))
          None
        }
        _ ->
          Some(
            ParseAcc(
              ..acc,
              attrs: [#(acc.attr_name, acc.word), ..acc.attrs],
              attr_name: "",
              word: "",
            ),
          )
      }
    }
  }
}

fn tag_name(word: String) {
  case word {
    "" -> "div"
    _ -> word
  }
}
