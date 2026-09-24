#' Execute an Expression with Structured Error and Warning Logging
#'
#' Wraps `expr` in a `tryCatch()` that:
#' * logs warnings via [logger::log_warn()] and re-issues them so Shiny can
#'   also handle them
#' * logs errors via [logger::log_error()] and re-throws so the caller /
#'   Shiny sees the error normally
#'
#' @param expr    Expression to evaluate (passed unevaluated via `...`).
#' @param context Short string identifying the call site, e.g.
#'   `"mod_outputs / prices_r"`.  Prepended to every log message.
#' @param ns      Logger namespace string.
#'   Defaults to `"stocktipr6/app"`.
#'
#' @return The value of `expr` on success; re-throws on error.
#'
#' @examples
#' \dontrun{
#' result <- with_logging(
#'   context = "my_module / compute",
#'   ns = "stocktipr6/app",
#'   sqrt(4)
#' )
#' }
#'
#' @export
with_logging <- function(expr, context = "", ns = "stocktipr6/app") {
  tryCatch(
    withCallingHandlers(
      expr,
      warning = function(w) {
        logger::log_warn(
          "[{context}] Warning: {conditionMessage(w)}",
          namespace = ns
        )
        invokeRestart("muffleWarning")
      }
    ),
    error = function(e) {
      logger::log_error(
        "[{context}] Error: {conditionMessage(e)}",
        namespace = ns
      )
      stop(e)
    }
  )
}
