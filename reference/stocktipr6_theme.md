# Setup stocktipr6 theme and styling

Creates a custom bslib theme with a dark terminal aesthetic inspired by
financial trading platforms. Called internally by
[`app_ui()`](https://mjfrigaard.github.io/stocktipr6/reference/app_ui.md)
to apply global theming.

## Usage

``` r
stocktipr6_theme()
```

## Value

A `bs_theme()` object with custom variables and CSS

## Details

The theme defines a dark, Bloomberg-terminal inspired aesthetic:

- **Palette:** near-black background, cyan primary, amber accents,
  green/red data

- **Typography:** IBM Plex Mono for fixed-width terminal feel

- **Surfaces:** flat panels with custom border colors

## Examples

``` r
if (FALSE) { # \dontrun{
theme <- stocktipr6_theme()
} # }
```
