# Tests

``` r

library(stocktipr6)
#> 
#> Attaching package: 'stocktipr6'
#> The following object is masked from 'package:base':
#> 
#>     %||%
```

## `tests/testthat/` Directory (Test Suite)

Comprehensive test coverage across 7 test files:

1.  **`test_mod_inputs.R`** - 7 test cases
    - R6 instantiation, UI structure, namespace IDs, server reactives,
      isolation
2.  **`test_mod_outputs.R`** - 6 test cases
    - R6 instantiation, UI structure with 5 tabs, namespace IDs,
      reactive performance tibble
3.  **`test_mod_download.R`** - 6 test cases
    - R6 instantiation, server integration with reactives, namespace
      isolation, UI/server ID matching, report rendering
4.  **`test_utils_data.R`** - 11 test cases
    - Log return computation, NA handling, performance metrics, rolling
      volatility
5.  **`test_utils_logging.R`** - 7 test cases
    - Expression execution, error re-throwing, warning suppression,
      null-coalescing operator
6.  **`test_mod_tooltip.R`** - 10 test cases
    - Backend dispatching (`bslib`, `shinyhelper`, `prompter`,
      `shinyalert`), style/size parameters
7.  **`test_mod_hoverinfo.R`** - 11 test cases
    - Span tag generation, title attributes, named vectors, style/size
      handling

**Total Test Cases**: 58

### Test Execution

``` bash
cd /Users/mjfrigaard/projects/apps/R/stocktipr6
devtools::test()  # Runs all 58 tests
```

### Coverage

| Category           | Test File              | Test Cases   |
|--------------------|------------------------|--------------|
| **R6 Classes**     | `test_mod_inputs.R`    | 7            |
|                    | `test_mod_outputs.R`   | 6            |
|                    | `test_mod_download.R`  | 6            |
| **Data Utilities** | `test_utils_data.R`    | 11           |
| **Logging**        | `test_utils_logging.R` | 7            |
| **UI Helpers**     | `test_mod_tooltip.R`   | 10           |
|                    | `test_mod_hoverinfo.R` | 11           |
| **Total**          | 7 files                | **58 tests** |

### Test Patterns Used

1.  **Unit Tests**: Direct function/method calls with assertions
2.  **Shiny-Specific Tests**:
    [`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html)
    for reactive logic
3.  **Integration Tests**: R6 module composition and data flow
4.  **Error Handling**: Validation of error messages and edge cases
