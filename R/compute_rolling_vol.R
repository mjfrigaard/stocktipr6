#' Compute Rolling Annualised Volatility
#'
#' Computes a rolling standard deviation of daily log returns, annualised
#' by multiplying by `sqrt(252)`. Validates window and handles edge cases.
#'
#' @param returns A tibble returned by [get_stock_returns()].
#' @param window  Integer. Rolling window in trading days. Default 30.
#'
#' @return The input tibble with an additional `rolling_vol` column.
#'
#' @export
compute_rolling_vol <- function(returns, window = 30L) {
  if (!inherits(returns, "data.frame") || nrow(returns) == 0) {
    stop("returns must be a non-empty data frame", call. = FALSE)
  }

  if (!all(c("symbol", "daily_return") %in% names(returns))) {
    stop("returns must contain symbol and daily_return columns", call. = FALSE)
  }

  window <- as.integer(window)
  if (window < 1) {
    stop("window must be a positive integer", call. = FALSE)
  }

  result <- returns |>
    dplyr::group_by(.data$symbol) |>
    dplyr::mutate(
      rolling_vol = slider::slide_dbl(
        .x = .data$daily_return,
        .f = sd,
        .before = window - 1L,
        .complete = TRUE
      ) * sqrt(252)
    ) |>
    dplyr::ungroup()

  result
}
