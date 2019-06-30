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
#' @import gt
#' @importFrom magrittr "%>%"
#'
#' @examples
#' \dontrun{
#' show_matrix(epcdata, thr = 'chl')
#' }
show_matrix <- function(epcdata, thr = c('chla', 'la')){

  thr <- match.arg(thr)
  thr <- paste0('mean_', thr)

  colorize_fld <- function(gtbl, fld, pal=c("green", "yellow", "red"), digits=1){
    gtbl %>%
      data_color(
        #columns = vars(fld),
        columns = fld,
        colors = scales::col_numeric(
          palette = pal,
          domain =  gtbl[[fld]])) %>%
      fmt_number(
        #columns = vars(fld),
        columns = fld,
        decimals = 1)
  }

  colorize_tbl <- function(gtbl, exclude_cols="Year", pal=c("green", "yellow", "red"), digits=1){
    flds <- setdiff(names(gtbl), exclude_cols)
    for (fld in flds){
      gtbl <- colorize_fld(gtbl, fld, pal, digits)
    }
    gtbl
  }

  # make the table
  out <- epcdata %>%
    anlz_avedat %>%
    .[['ann']] %>%
    filter(var %in% !!thr) %>%
    spread(var, val) %>%
    spread(bay_segment, !!thr) %>%
    rename(Year = yr) %>%
    gt() %>%
    colorize_tbl()

  return(out)

}
