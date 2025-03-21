#' Plot a matrix of Tampa Bay Benthic Index scores over time by bay segment
#'
#' Plot a matrix of Tampa Bay Benthic Index scores over time by bay segment
#'
#' @param tbbiscr input data frame as returned by \code{\link{anlz_tbbiscr}}
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB", "All", "All (wt)"
#' @param yrrng numeric indicating year ranges to evaluate
#' @param alph numeric indicating alpha value for score category colors
#' @param txtsz numeric for size of text in the plot
#' @param family optional chr string indicating font family for text labels
#' @param rev logical if factor levels for bay segments are reversed
#' @param position chr string of location for bay segment labels, default on top, passed to \code{\link[ggplot2]{scale_x_discrete}}
#' @param plotly logical if matrix is created using plotly
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing trends over time in TBBI scores for each bay segment if \code{plotly = FALSE}, otherwise a \code{\link[plotly]{plotly}} object
#' @export
#'
#' @details
#' Additional summaries are provided for the entire bay, as a summary across categories ("All") and a summary weighted across the relative sizes of each bay segment ("All (wt)").
#'
#' @concept show
#'
#' @importFrom dplyr "%>%"
#'
#' @examples
#' tbbiscr <- anlz_tbbiscr(benthicdata)
#' show_tbbimatrix(tbbiscr)
show_tbbimatrix <- function(tbbiscr, bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB', 'All', 'All (wt)'),
                            yrrng = c(1993, 2023), alph = 1, txtsz = 3, family = NA, rev = FALSE, position = 'top',
                            plotly = FALSE, width = NULL, height = NULL){

  # annual average by segment
  toplo <- anlz_tbbimed(tbbiscr, bay_segment, rev = rev, yrrng = yrrng)

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = bay_segment, y = yr, fill = TBBICat)) +
    geom_tile(colour = 'black', alpha = alph) +
    ggplot2::scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = position) +
    ggplot2::scale_fill_manual(values = c(Poor = '#CC3231', Fair = '#E9C318', Good = '#2DC938')) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      legend.position = 'none',
      panel.grid = ggplot2::element_blank()
    )

  if(!is.null(txtsz))
    p <- p +
      ggplot2::geom_text(aes(label = TBBICat), size = txtsz, family = family)

  if(plotly)
    p <- show_matrixplotly(p, family = family, tooltip = NULL, width = width, height = height)

  return(p)

}
