#' @title Create a colorized table for indicator reporting
#'
#' @description Create a colorized table for indicator reporting
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param thr chr string indicating which water quality value to show, one of "chl" for chlorophyll and "la" for light availability
#'
#' @family visualize
#'
#' @return An object of class \code{gt_tbl}
#'
#' @seealso \code{\link[gt]{gt}}
#' @export
#'
#' @importFrom magrittr "%>%"
#'
#' @examples
#' \dontrun{
#' show_matrix(epcdata, thr = 'chl')
#' }
show_matrix <- function(epcdata, thr = c('chla', 'la')){

  thr <- match.arg(thr)
  thr <- paste0('mean_', thr)

  # make the table
  out <- epcdata %>%
    anlz_avedat %>%
    .[['ann']] %>%
    filter(var %in% !!thr) %>%
    spread(var, val) %>%
    spread(bay_segment, !!thr) %>%
    rename(Year = yr) %>%
    gt::gt() %>%
    show_colorizetbl()

  # make some changes for hard breaks here...

  return(out)

}
