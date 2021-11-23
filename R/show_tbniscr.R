#' Plot Tampa Bay Nekton Index scores over time by bay segment
#'
#' Plot Tampa Bay Nekton Index scores over time by bay segment
#'
#' @param tbniscr input dat frame as returned by \code{\link{anlz_tbniscr}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB"
#' @param perc numeric values indicating break points for score categories
#' @param alph numeric indicating alpha value for score category colors
#' @param ylim numeric for y axis limits
#' @param rev logical if factor levels for bay segments are reversed
#' @param plotly logical if matrix is created using plotly
#' @param family optional chr string indicating font family for text labels
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing trends over time in TBNI scores for each bay segment or a \code{\link[plotly]{plotly}} object if \code{plotly = TRUE}
#' @export
#'
#' @concept show
#'
#' @importFrom dplyr "%>%"
#'
#' @examples
#' tbniscr <- anlz_tbniscr(fimdata)
#' show_tbniscr(tbniscr)
show_tbniscr <- function(tbniscr, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), perc = c(32, 46), alph = 0.3,
                         ylim = c(22 ,58), rev = FALSE, plotly = FALSE, family = NA, width = NULL, height = NULL){

  # sanity checks
  stopifnot(length(perc) == 2)
  stopifnot(perc[1] < perc[2])
  stopifnot(perc[1] > 22)
  stopifnot(perc[2] < 58)

  # bay segment factor levels
  levs <- c("OTB", "HB", "MTB", "LTB")

  # annual average by segment
  toplo <- anlz_tbniave(tbniscr, bay_segment, rev = rev, perc = perc)

  # plot
  out <- ggplot2::ggplot(toplo) +
    annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = perc[1], alpha = alph, fill = 'red') +
    annotate("rect", xmin = -Inf, xmax = Inf, ymin = perc[1], ymax = perc[2], alpha = alph, fill = 'yellow') +
    annotate("rect", xmin = -Inf, xmax = Inf, ymin = perc[2], ymax = Inf, alpha = alph, fill = 'green') +
    ggplot2::geom_line(aes(x = Year, y = Segment_TBNI, linetype = bay_segment, color = bay_segment), size = 1.25) +
    # stat_summary(fun.y=sum, geom="line") +
    ggplot2::scale_linetype_manual(name = "",
                          breaks = levs,
                          labels = levs,
                          values = c("dashed", "dotdash", "dotted", "solid")) +
    ggplot2::scale_color_manual(name = "",
                       breaks = levs,
                       labels = levs,
                       values = c("black", "black", "gray40", "gray40")) +
    ggplot2::scale_y_continuous(name = "TBNI by bay segment", limits = ylim, breaks = seq(ylim[1], ylim[2], 4)) +
    ggplot2::scale_x_continuous(breaks = seq(1998,max(toplo$Year), 1), expand = c(0.025, 0.025)) +
    ggplot2::geom_hline(aes(yintercept = perc[1]), color = "black", linetype = "dotted") +
    ggplot2::geom_hline(aes(yintercept = perc[2]), color = "black", linetype = "dotted") +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(size = 12),
      axis.text.x = ggplot2::element_text(size = 12, angle = 90, vjust = 0.5),
      legend.title = ggplot2::element_text(size=12, face="bold"),
      legend.justification = c(1,0),
      legend.position = c(1,0),
      legend.key.size = grid::unit(1, 'lines'),
      legend.key.width = grid::unit(6, "line"),
      legend.key = ggplot2::element_blank(),
      legend.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      text = ggplot2::element_text(family = family)
    )

  if(plotly)
    out <- show_tbniscrplotly(out, width = width, height = height)

  return(out)

}
