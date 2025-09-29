#' Plot a matrix of Tampa Bay Nekton Index scores over time by bay segment
#'
#' Plot a matrix of Tampa Bay Nekton Index scores over time by bay segment
#'
#' @param tbniscr input data frame as returned by \code{\link{anlz_tbniscr}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB"
#' @param perc numeric values indicating break points for score categories
#' @param alph numeric indicating alpha value for score category colors
#' @param txtsz numeric for size of text in the plot
#' @param family optional chr string indicating font family for text labels
#' @param rev logical if factor levels for bay segments are reversed
#' @param position chr string of location for bay segment labels, default on top, passed to \code{\link[ggplot2]{scale_x_discrete}}
#' @param plotly logical if matrix is created using plotly
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing trends over time in TBNI scores for each bay segment
#' @export
#'
#' @concept show
#'
#' @importFrom dplyr "%>%"
#'
#' @examples
#' tbniscr <- anlz_tbniscr(fimdata)
#' show_tbnimatrix(tbniscr)
show_tbnimatrix <- function(tbniscr, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), perc = c(32, 46), alph = 1, txtsz = 3,
                            family = 'sans', rev = FALSE, position = 'top', plotly = FALSE, width = NULL, height = NULL){

  # annual average by segment
  toplo <- anlz_tbniave(tbniscr, bay_segment, rev = rev, perc = perc)

  p <- ggplot2::ggplot(toplo, aes(x = bay_segment, y = Year, fill = outcome)) +
    ggplot2::geom_tile(aes(group = Action), colour = 'black', alpha = alph) +
    ggplot2::scale_y_reverse(expand = c(0, 0), breaks = toplo$Year) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = position) +
    ggplot2::scale_fill_manual(values = c(red = '#CC3231', yellow = '#E9C318', green = '#2DC938')) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      legend.position = 'none',
      panel.grid = ggplot2::element_blank()
    )

  if(!is.null(txtsz))
    p <- p +
      ggplot2::geom_text(aes(label = outcome), size = txtsz, family = family)

  if(plotly)
    p <- show_matrixplotly(p, family = family, tooltip = 'Action', width = width, height = height)

  return(p)

}
