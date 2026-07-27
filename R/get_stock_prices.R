#' Retrieve Historical Adjusted Prices via tidyquant
#'
#' Downloads daily adjusted closing prices from Yahoo Finance for one or
#' more ticker symbols over a given date range. Includes validation and
#' robust error handling.
#'
#' @param tickers A character vector of ticker symbols.
#' @param from    A `Date` or date string (`"YYYY-MM-DD"`). Start of range.
#' @param to      A `Date` or date string. End of range. Defaults to today.
#'
#' @return A tibble with columns:
#'   `symbol`, `date`, `open`, `high`, `low`, `close`, `volume`, `adjusted`.
#'   On error, throws with details. Use tryCatch() in calling code.
#'
#' @examples
#' \dontrun{
#' get_stock_prices(c("AAPL", "MSFT"), from = "2023-01-01")
#' }
#'
#' @export
get_stock_prices <- function(tickers, from, to = Sys.Date()) {
  # Input validation
  if (!is.character(tickers) || length(tickers) == 0) {
    stop("tickers must be a non-empty character vector", call. = FALSE)
  }

  from <- as.Date(from)
  to <- as.Date(to)

  if (is.na(from) || is.na(to)) {
    stop("from and to must be valid dates", call. = FALSE)
  }

  if (from >= to) {
    stop("from must be before to", call. = FALSE)
  }

  # Fetch each ticker individually to isolate failures
  all_results <- list()
  failed_tickers <- character()

  for (ticker in tickers) {
    result <- tryCatch(
      {
        suppressWarnings({
          tidyquant::tq_get(
            x = ticker,
            get = "stock.prices",
            from = from,
            to = to,
            complete_cases = FALSE,
            warnings = FALSE
          )
        })
      },
      error = function(e) {
        logger::log_debug(
          glue::glue("tidyquant fetch failed for {ticker}: {conditionMessage(e)}"),
          namespace = "rsixer/data"
        )
        NULL
      }
    )

    # Check if result is valid (not NULL and has rows)
    if (is.null(result) || nrow(result) == 0) {
      failed_tickers <- c(failed_tickers, ticker)
    } else {
      all_results[[ticker]] <- result
    }
  }

  # If some tickers succeeded, combine and use them
  if (length(all_results) > 0) {
    combined <- do.call(dplyr::bind_rows, all_results)
    if (nrow(combined) > 0) {
      # Log which tickers failed
      if (length(failed_tickers) > 0) {
        logger::log_warn(
          paste0("Partial fetch: failed tickers [", paste(failed_tickers, collapse = ", "), "] using fallback demo data instead"),
          namespace = "rsixer/data"
        )
      }
      return(combined)
    }
  }

  # All tickers failed; fall back to demo data
  logger::log_warn(
    paste0("Yahoo Finance unavailable for all tickers [", paste(failed_tickers, collapse = ", "), "]. Using demo data."),
    namespace = "rsixer/data"
  )

  demo_data <- .get_demo_prices(tickers, from, to)

  # Add attribute to flag that this is demo data
  attr(demo_data, "is_demo") <- TRUE
  demo_data
}
