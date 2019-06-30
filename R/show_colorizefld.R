#' Colorize a field with gt
#'
#' @param gtbl input \code{gt} object
#' @param fld which field to colorize
#' @param pal chr vector of colors
#' @param digits precision of digits to show
#'
#' @return An object of class \code{gt_tbl}
#'
#' @import gt
#' @export
#'
#' @details used internally in \code{\link{show_colorizetbl}}
show_colorizefld <- function(gtbl, fld, pal=c("green", "yellow", "red"), digits = 1){

  out <- gtbl %>%
    data_color(
      #columns = vars(fld),
      columns = fld,
      colors = scales::col_numeric(
        palette = pal,
        domain =  gtbl[[fld]])) %>%
    fmt_number(
      #columns = vars(fld),
      columns = fld,
      decimals = digits)

  return(out)

}
