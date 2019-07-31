#' @title Create a colorized table for indicator reporting
#'
#' @description Create a colorized table for indicator reporting
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
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
#' @import ggplot2
#'
#' @examples
#' \dontrun{
#' show_matrix(epcdata)
#' }
show_matrix <- function(epcdata){

  # process data to plot
  avedat <- anlz_avedat(epcdata)
  toplo <- anlz_attain(avedat) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB'))
    )

  # make the table
  # out <- epcdata %>%
  #   anlz_avedat %>%
  #   .[['ann']] %>%
  #   filter(var %in% !!thr) %>%
  #   spread(var, val) %>%
  #   spread(bay_segment, !!thr) %>%
  #   rename(Year = yr) %>%
  #   gt::gt() %>%
  #   show_colorizetbl()

  p <- ggplot(toplo, aes(x = bay_segment, y = yr)) +
    geom_tile(colour = 'black', fill = toplo$outcome) +
    scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    scale_x_discrete(expand = c(0, 0), position = 'top') +
    geom_text(aes(label = outcome), size = 3) +
    theme_bw(base_family = 'serif') +
    theme(axis.title = element_blank())

  return(p)

}
