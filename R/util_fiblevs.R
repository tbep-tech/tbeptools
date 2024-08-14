#' A list of Fecal Indicator Bacteria (FIB) category breakpoints and labels
#'
#' @return A \code{list} showing cut points and labels for FIB categories
#' @export
#'
#' @examples
#' util_fiblevs()
util_fiblevs <- function(){

  out <- list(
    ecolilev = c(-Inf, 126, 410, 1e3, Inf),
    ecolilbs = c('< 126', '126 - 409', '410 - 999', '> 999'),
    enterolev = c(-Inf, 35, 130, 1e3, Inf),
    enterolbs = c('< 35', '35 - 129', '130 - 999', '> 999')
  )

  return(out)

}
