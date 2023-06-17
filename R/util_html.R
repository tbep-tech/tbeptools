#' Convert character string to html class
#'
#' @param text character string input
#'
#' @return The same input character string with html class
#'
#' @details Adapted from \code{\link[htmltools]{HTML}}
#'
#' @concept util

#' @export
#'
#' @examples
#' util_html('abd')
util_html <- function (text){

  attr(text, "html") <- TRUE
  attr(text, "noWS") <- NULL
  class(text) <- c("html", "character")

  out <- text

  return(out)

}
