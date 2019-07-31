#' @title Create a colorized table for indicator reporting
#'
#' @description Create a colorized table for indicator reporting
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param tab logical indicating if a \code{gt_tbl} object is returned
#'
#' @family visualize
#'
#' @return An object of class \code{gt_tbl} if \code{tab = TRUE}, otherwise a \code{ggplot} object is returned, both have similar appearances
#'
#' @seealso \code{\link[gt]{gt}}
#' @export
#'
#' @importFrom magrittr "%>%"
#'
#' @import ggplot2
#'
#' @examples
#' \dontrun{
#' show_matrix(epcdata)
#' }
show_matrix <- function(epcdata, tab = FALSE){

  # process data to plot
  avedat <- anlz_avedat(epcdata)
  toplo <- anlz_attain(avedat) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB'))
    )

  if(tab){

    # make the table
    tab <- toplo %>%
      dplyr::select(-chl_la) %>%
      tidyr::spread(bay_segment, outcome) %>%
      dplyr::rename(Year = yr) %>%
      gt::gt() %>%
      show_colorizetbl()

    return(tab)

  }

  p <- ggplot(toplo, aes(x = bay_segment, y = yr)) +
    geom_tile(colour = 'black', fill = toplo$outcome) +
    scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    scale_x_discrete(expand = c(0, 0), position = 'top') +
    geom_text(aes(label = outcome), size = 3) +
    theme_bw(base_family = 'serif') +
    theme(axis.title = element_blank())

  return(p)

}
