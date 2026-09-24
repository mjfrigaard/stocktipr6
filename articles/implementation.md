# Implementation

``` r

library(stocktipr6)
#> 
#> Attaching package: 'stocktipr6'
#> The following object is masked from 'package:base':
#> 
#>     %||%
```

## Technical Implementation Details

### Shiny Integration

All R6 modules maintain full compatibility with Shiny’s module system:

1.  **UI Methods**: Return valid Shiny tag objects suitable for
    embedding in any UI
2.  **Server Methods**: Use `shiny::moduleServer(private$id, ...)`
    internally
3.  **Namespace Functions**: Store and use
    [`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) in private
    field
4.  **Reactives**: Return reactive values/expressions directly from
    `$server()` methods

### Data Pipeline Architecture

    ModInputs$server() → inputs_r (reactive list)
                           ↓
    ModOutputs$server(inputs_r) → prices_r (eventReactive on fetch)
                                    ↓
                                returns_r (reactive computation)
                                    ↓
                                perf_r (reactive summary)
                                    ↓
    ModDownload$server(inputs_r, perf_r) → handles download

### Logging Architecture

    stocktipr6/app                 # App-level events
    ├── stocktipr6/inputs        # Input module events
    ├── stocktipr6/outputs       # Output module events
    │   ├── stocktipr6/tooltip   # Tooltip dispatch
    │   └── stocktipr6/hoverinfo # Hover-info rendering
    └── stocktipr6/download      # Download module events

------------------------------------------------------------------------

## Package Configuration

### DESCRIPTION File

Key sections:

- **Package**: `stocktipr6`
- **Version**: `0.1.0`
- **Type**: Package with Shiny application
- **Imports**: R6, shiny, bslib, dplyr, tidyquant, reactable, logger,
  etc.
- **Suggests**: testthat, knitr
- **Config/testthat/edition**: 3 (modern testthat)
- **Roxygen2**: Configured for documentation generation

### renv.lock (Dependencies)

Pins exact versions for reproducibility: - R 4.5.0 - 30+ packages with
specific versions
