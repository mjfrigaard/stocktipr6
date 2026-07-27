#' Summarise Performance Metrics by Ticker
#'
#' Computes annualised return, annualised volatility, and Sharpe ratio
#' (assuming zero risk-free rate) for each ticker. Validates input and
#' handles edge cases (zero volatility, missing returns).
#'
#' @param returns A tibble returned by [get_stock_returns()].
#'
#' @return A tibble with columns:
#'   `symbol`, `ann_return`, `ann_vol`, `sharpe`.
#'
#' @export
summarise_performance <- function(returns) {
  if (!inherits(returns, "data.frame") || nrow(returns) == 0) {
    stop("returns must be a non-empty data frame", call. = FALSE)
  }

  if (!all(c("symbol", "daily_return") %in% names(returns))) {
    stop("returns must contain symbol and daily_return columns", call. = FALSE)
  }

  result <- returns |>
    dplyr::summarise(
      ann_return = mean(.data$daily_return, na.rm = TRUE) * 252,
      ann_vol = sd(.data$daily_return, na.rm = TRUE) * sqrt(252),
      .by = symbol
    ) |>
    dplyr::mutate(
      sharpe = dplyr::if_else(
        .data$ann_vol > 0,
        .data$ann_return / .data$ann_vol,
        0  # Zero volatility edge case
      )
    )

  if (nrow(result) == 0) {
    stop("No performance metrics computed from input data", call. = FALSE)
  }

  result
}
