#' Generate Demo Stock Prices
#'
#' Creates realistic demo data for testing when Yahoo Finance is unavailable.
#' Used internally by [get_stock_prices()] as fallback.
#'
#' @param tickers Character vector of ticker symbols
#' @param from Start date
#' @param to End date
#'
#' @return Tibble with price data
#'
#' @keywords internal
.get_demo_prices <- function(tickers, from, to) {
  set.seed(4821)
  days <- as.integer(to - from) + 1

  tidyr::expand_grid(
    symbol = tickers,
    date = seq(from, to, by = "day")
  ) |>
    dplyr::mutate(
      base_price = dplyr::case_when(
        symbol == "LLY" ~ 580,
        symbol == "MRK" ~ 75,
        symbol == "JNJ" ~ 158,
        symbol == "PFE" ~ 38,
        symbol == "ABBV" ~ 180,
        symbol == "BMY" ~ 85,
        symbol == "AMGN" ~ 335,
        .default = 100
      ),
      noise = rnorm(dplyr::n(), 0, 1),
      adjusted = base_price + cumsum(noise) / 100
    ) |>
    dplyr::mutate(
      open = adjusted + rnorm(dplyr::n(), 0, 1),
      high = pmax(open, adjusted) + abs(rnorm(dplyr::n(), 0, 1)),
      low = pmin(open, adjusted) - abs(rnorm(dplyr::n(), 0, 1)),
      close = adjusted,
      volume = rpois(dplyr::n(), lambda = 5000000)
    ) |>
    dplyr::select(symbol, date, open, high, low, close, volume, adjusted)
}
