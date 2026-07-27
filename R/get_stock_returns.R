#' Compute Daily Log Returns from Price Data
#'
#' Calculates daily log returns from the adjusted closing price column
#' produced by [get_stock_prices()]. Validates input and handles edge cases.
#'
#' @param prices A tibble returned by [get_stock_prices()].
#'
#' @return A tibble with columns `symbol`, `date`, `daily_return`.
#'
#' @export
get_stock_returns <- function(prices) {
  if (!inherits(prices, "data.frame") || nrow(prices) == 0) {
    stop("prices must be a non-empty data frame", call. = FALSE)
  }

  if (!all(c("symbol", "date", "adjusted") %in% names(prices))) {
    stop("prices must contain symbol, date, and adjusted columns", call. = FALSE)
  }

  if (any(is.na(prices$adjusted))) {
    warning("Removing NA values from adjusted prices", call. = FALSE)
  }

  result <- prices |>
    dplyr::arrange(.data$symbol, .data$date) |>
    dplyr::group_by(.data$symbol) |>
    dplyr::mutate(
      daily_return = log(.data$adjusted / dplyr::lag(.data$adjusted))
    ) |>
    dplyr::ungroup() |>
    dplyr::filter(!is.na(.data$daily_return)) |>
    dplyr::select("symbol", "date", "daily_return")

  if (nrow(result) == 0) {
    stop("No valid returns computed from input data", call. = FALSE)
  }

  result
}
