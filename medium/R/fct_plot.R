#' plot
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
to_date <- function(x, origin = "1974-01-01", tz = "GMT", ...) {
  seconds <- (x - 1974) * 365 * 24 * 3600
  as.POSIXct(seconds, origin = origin, tz = tz)
}
