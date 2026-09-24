#' Set the Application-wide Log Threshold
#'
#' A thin wrapper around [logger::log_threshold()] that applies the chosen
#' level to every logger namespace used by **stocktipr6**.
#'
#' Log levels from lowest to highest verbosity:
#' `TRACE`, `DEBUG`, `INFO`, `SUCCESS`, `WARN`, `ERROR`, `FATAL`.
#' The default threshold is `INFO` — `TRACE` and `DEBUG` lines are silent
#' in production.
#'
#' Internally, `lapply()` iterates over the namespace vector and calls
#' [logger::log_threshold()] for each entry.  The return value of `lapply()`
#' is discarded; only `level` is returned (invisibly).
#'
#' @param level A `logger` log-level object, e.g. [logger::DEBUG],
#'   [logger::INFO] (default), [logger::WARN].
#'
#' @return Invisibly returns `level`.
#'
#' @examples
#' \dontrun{
#' # Verbose output during development
#' app_set_log_threshold(logger::DEBUG)
#'
#' # Quiet production mode
#' app_set_log_threshold(logger::WARN)
#' }
#'
#' @export
app_set_log_threshold <- function(level = logger::INFO) {
  namespaces <- c(
    "global",
    "stocktipr6/app",
    "stocktipr6/inputs",
    "stocktipr6/outputs",
    "stocktipr6/download",
    "stocktipr6/tooltip",
    "stocktipr6/hoverinfo"
  )
  lapply(namespaces, \(ns) logger::log_threshold(level, namespace = ns))
  invisible(level)
}
