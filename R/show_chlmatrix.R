#' @title Create a colorized table for chlorophyll exceedances
#'
#' @description Create a colorized table for chlorophyll exceedances
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param txtsz numeric for size of text in the plot, applies only if \code{tab = FALSE}
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#' @param yrrng numeric vector indicating min, max years to include
#'
#' @family visualize
#'
#' @return A static \code{ggplot} object is returned
#'
#' @seealso \code{\link{show_matrix}}
#' @export
#'
#' @importFrom magrittr "%>%"
#'
#' @import ggplot2
#'
#' @examples
#' show_chlmatrix(epcdata)
show_chlmatrix <- function(epcdata, txtsz = 3, trgs = NULL, yrrng = c(1975, 2018)){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # process data to plot
  avedat <- anlz_avedat(epcdata) %>%
    .$ann
  toplo <- avedat %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(var %in% 'mean_chla') %>%
    dplyr::left_join(trgs, by = 'bay_segment') %>%
    dplyr::select(bay_segment, yr, var, val, chla_thresh) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB')),
      outcome = dplyr::case_when(
        val < chla_thresh ~ 'green',
        val >= chla_thresh ~ 'red'
      )
    )

  # ggplot
  p <- ggplot(toplo, aes(x = bay_segment, y = yr)) +
    geom_tile(colour = 'black', fill = toplo$outcome) +
    scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    scale_x_discrete(expand = c(0, 0), position = 'top') +
    theme_bw(base_family = 'serif') +
    theme(
      axis.title = element_blank(),
      text = element_text(family = 'serif')
    )

  if(!is.null(txtsz))
    p <- p +
      geom_text(aes(label = outcome), size = txtsz)

  return(p)

}
