#' Colorize a field with gt
#'
#' @param gtbl input \code{gt} object
#' @param fld which field to colorize
#' @param pal chr vector of colors
#'
#' @return An object of class \code{gt_tbl}
#'
#' @import gt
#' @export
#'
#' @details used internally in \code{\link{show_colorizetbl}}
show_colorizefld <- function(gtbl, fld, pal=c("green", "yellow", "red")){

  out <- gtbl %>%
    data_color(
      #columns = vars(fld),
      columns = fld,
      colors = scales::col_factor(
        palette = pal,
        domain =  gtbl[[fld]],
        levels = pal
        )
      )

  return(out)

}
