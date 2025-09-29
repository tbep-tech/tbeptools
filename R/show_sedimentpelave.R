#' Plot summary of PEL averages by bay segment
#'
#' Plot summary of PEL averages by bay segment
#'
#' @inheritParams anlz_sedimentpel
#' @param alph numeric indicating alpha value for score category colors
#' @param ylim numeric for y axis limits
#' @param lnsz numeric for line size
#' @param base_size numeric indicating text scaling size for plot
#' @param plotly logical if matrix is created using plotly
#' @param family optional chr string indicating font family for text labels
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object or a \code{\link[plotly]{plotly}} object if \code{plotly = TRUE} showing PEL averages (average of the averages) and 95% confidence intervals for each bay segment
#'
#' @details Lines for the grades are shown on the plot. Confidence intervals may not be shown for segments with insufficient data.
#'
#' @export
#'
#' @concept show
#'
#' @examples
#' show_sedimentpelave(sedimentdata)
show_sedimentpelave <- function(sedimentdata, yrrng = c(1993, 2023), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP', alph = 1, ylim = c(0, 0.4), lnsz = 1, base_size = 12, plotly = FALSE, family = 'sans', width = NULL, height = NULL){

  # get avg pel ratios by station, then get averages
  toplo <- anlz_sedimentpelave(sedimentdata, yrrng = yrrng, bay_segment = bay_segment, funding_proj = funding_proj)

  thm <- ggplot2::theme_bw(base_size = base_size) +
    ggplot2::theme(
      panel.border = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      legend.title = ggplot2::element_blank(),
      legend.position = 'top',
      text = ggplot2::element_text(family = family)
    )

  grdtxt <- toplo %>%
    select(grandave) %>%
    unique() %>%
    mutate(grandave = paste('Grand mean:', round(grandave, 3))) %>%
    paste(collapse = ' ')

  ylb <- 'PEL summary'
  brks <- c(0.00756, 0.02052, 0.08567, 0.28026)

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = AreaAbbr, y = ave)) +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = brks[1], alpha = alph, fill = '#2DC938') +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = brks[1], ymax = brks[2], alpha = alph, fill = '#A2FD7A') +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = brks[2], ymax = brks[3], alpha = alph, fill = '#E9C318') +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = brks[3], ymax = brks[4], alpha = alph, fill = '#EE7600') +
    ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = brks[4], ymax = Inf, alpha = alph, fill = '#CC3231') +
    ggplot2::geom_point(size = 3) +
    ggplot2::scale_x_discrete(drop = F) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = lov, ymax = hiv), width = 0, na.rm = T) +
    ggplot2::geom_hline(ggplot2::aes(yintercept = grandave, linetype = grdtxt), color = 'grey', size = lnsz) +
    ggplot2::geom_hline(aes(yintercept = brks[1]), color = "black", linetype = "dotted") +
    ggplot2::geom_hline(aes(yintercept = brks[2]), color = "black", linetype = "dotted") +
    ggplot2::geom_hline(aes(yintercept = brks[3]), color = "black", linetype = "dotted") +
    ggplot2::geom_hline(aes(yintercept = brks[4]), color = "black", linetype = "dotted") +
    ggplot2::scale_linetype_manual(values = 'dashed', breaks = grdtxt) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::coord_cartesian(ylim = ylim) +
    ggplot2::labs(
      x = 'Bay segment',
      linetype = NULL,
      y = ylb
    ) +
    thm

  if(plotly)
    p <- show_sedimentpelaveplotly(p, width = width, height = height)

  return(p)

}
