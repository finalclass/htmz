# CLAUDE.md - htmz project guidelines

## Commands
- Run all tests: `gleam test`
- Run a single test: `gleam test -t test_name` (e.g., `gleam test -t basic_usage_test`)
- Run Erlang shell: `gleam shell`
- Add dependency: `gleam add <package_name>`
- Build project: `gleam build`

## Code Style
- **Imports**: Group by package with alias `z` for htmz
  ```gleam
  import htmz.{Html, Div, Button} as z
  import gleam/list
  ```
- **Types**: PascalCase for types, snake_case for parameters
- **Functions**: snake_case with pipe-first style (|>)
- **Error handling**: Use Option/Result types from gleam/option and gleam/result
- **HTML Elements**: Use PascalCase constructors (Div, Html, etc.)
- **Formatting**: 2-space indentation, Gleam standard style
- **Attributes**: For HTML attributes, use z.attr() or specific helpers like z.class()
- **Selectors**: Use Z("selector") syntax for CSS-style selectors
- **Conditionals**: Use case expressions with Nothing for empty cases

## Special Notes
- Use `type_` instead of `type` (Gleam keyword)
- The library supports HTMX and Alpine.js attributes