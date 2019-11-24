#' Colorize multiple fields with gt
#'
#' @param gtbl input \code{gt} object
#' @param exclude_cols which field(s) not to colorize
#' @param pal chr vector of colors
#'
#' @return An object of class \code{gt_tbl}
#' @export
#'
#' @details used internally in \code{\link{show_matrix}}
show_colorizetbl <- function(gtbl, exclude_cols="Year", pal=c("green", "yellow", "red")){

  flds <- setdiff(names(gtbl$`_data`), exclude_cols)

  for (fld in flds){
    gtbl <- show_colorizefld(gtbl, fld, pal)
  }

  return(gtbl)

}
