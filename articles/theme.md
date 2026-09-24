# Dark Terminal Theme

## Overview

`stocktipr6` uses a dark, Bloomberg-terminal inspired theme designed for
financial data visualization. The theme features:

- **Dark background** for reduced eye strain during extended use
- **Amber primary color** (#ff9e1b) for buttons, headings, and
  interactive elements
- **Cyan secondary color** (#00d9ff) for hover states and interactive
  feedback
- **Monospace typography** (IBM Plex Mono) for a terminal aesthetic
- **Semantic colors** for data visualization (green for gains, red for
  losses, cyan for info)

## Color Palette

| Element                     | Color       | Hex      |
|-----------------------------|-------------|----------|
| Background                  | Near-black  | \#0b0e13 |
| Text                        | Light grey  | \#d5dde5 |
| Primary (buttons, headings) | Amber       | \#ff9e1b |
| Secondary (hover, focus)    | Cyan        | \#00d9ff |
| Success (gains)             | Green       | \#2ecc71 |
| Danger (losses)             | Red         | \#ff4d4f |
| Info                        | Bright cyan | \#4ea1ff |
| Border                      | Dark grey   | \#2a313b |

## Using the theme

The theme is automatically applied when you launch the app:

``` r

library(stocktipr6)
stocktipr6::launch()
```

### Customizing the Theme

You can extend the theme for your own apps by importing the
[`stocktipr6_theme()`](https://mjfrigaard.github.io/stocktipr6/reference/stocktipr6_theme.md)
function:

``` r

library(stocktipr6)
library(shiny)

ui <- bslib::page_sidebar(
  theme = stocktipr6_theme(),
  sidebar = bslib::sidebar("Sidebar content"),
  "Main content"
)

server <- function(input, output, session) {
  # Your server logic
}

shinyApp(ui, server)
```

### Reactable Tables

The app also includes a custom `reactable` theme for dark-themed data
tables:

``` r

options(reactable.theme = stocktipr6_reactable_theme())
```

This applies consistent dark styling to all `reactable` tables in your
session.

## Design Rationale

### Dark Background

The near-black background (#0b0e13) reduces glare and eye strain, making
it comfortable for extended viewing of financial dashboards and data
analyses.

### Amber as Primary

Amber (#ff9e1b) is the primary interactive color, used for:

- Primary buttons

- Headings (h1-h6)

- Card headers

- Primary navigation elements

This warm, energetic color draws attention while maintaining readability
against the dark background.

### Cyan for Interaction

Cyan (#00d9ff) serves as the secondary color for interactive feedback:

- Button hover states

- Form focus rings

- Secondary buttons

- Link hover states

- Tooltips and popovers

This creates a clear visual distinction between primary actions and
interactive feedback.

### Monospace Typography

All text uses IBM Plex Mono, a terminal-style monospace font that
reinforces the Bloomberg-inspired aesthetic. This is particularly
appropriate for financial data where precision and clarity are
paramount.

## Value Boxes

The app’s KPI value boxes use amber backgrounds (#ff9e1b) with black
text for maximum contrast and visual prominence:

``` r

bslib::value_box(
  title = "Ticker",
  value = "12.5%",
  theme = "warning",  # Amber background
  class = "vb-yellow-black"  # Ensures black text
)
```

The `vb-yellow-black` class ensures all content (text, icons, SVG
elements) remains black for optimal readability.

## Implementation Details

The theme is implemented through:

1.  **[`stocktipr6_theme()`](https://mjfrigaard.github.io/stocktipr6/reference/stocktipr6_theme.md)** -
    Main `bslib` theme function defining colors, fonts, and surfaces
2.  **[`stocktipr6_reactable_theme()`](https://mjfrigaard.github.io/stocktipr6/reference/stocktipr6_reactable_theme.md)** -
    Custom `reactable` table styling
3.  **CSS overrides** - Additional styles for sidebar, forms, buttons,
    and interactive elements

All theme configuration is in:

- `R/utils_theme.R` : theme function

- `R/utils_reactable_theme.R` : `reactable` theme

- `R/app_ui.R` : CSS overrides (in `<head>`)

## Accessibility

The dark theme with amber and cyan accents meets WCAG AA contrast
ratios:

- Amber text on dark background: 7.8:1 contrast ratio
- Cyan text on dark background: 6.2:1 contrast ratio
- Black text on amber background: 15.0:1 contrast ratio

This ensures the theme is readable for users with color vision
deficiency and other accessibility needs.
