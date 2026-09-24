# Launch the stocktipr6 Shiny App

Convenience wrapper that calls
[`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html) with
the package's
[`app_ui()`](https://mjfrigaard.github.io/stocktipr6/reference/app_ui.md)
and
[`app_server()`](https://mjfrigaard.github.io/stocktipr6/reference/app_server.md)
functions. Pass any additional arguments through to `shinyApp()` (e.g.
`options = list(port = 4321)`).

## Usage

``` r
launch(...)
```

## Arguments

- ...:

  Additional arguments forwarded to
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html).

## Value

A Shiny app object (invisibly). When called interactively the app opens
in the viewer / browser.

## Examples

``` r
if (FALSE) { # \dontrun{
stocktipr6::launch()

# Custom port
stocktipr6::launch(options = list(port = 4242, launch.browser = TRUE))
} # }
```
