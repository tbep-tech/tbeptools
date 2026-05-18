#' Plot a matrix of AMBI scores over time by bay segment
#'
#' Plot a matrix of AMBI scores over time by bay segment
#'
#' @param ambiscr input data frame as returned by \code{\link{anlz_ambiscr}}; the AMBI variant is detected automatically from the column names
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB", "All"
#' @param yrrng numeric indicating year ranges to evaluate
#' @param window logical indicating whether to use a rolling 5-year window (default TRUE) or single year values (FALSE) for the bay segment categories, see details
#' @param alph numeric indicating alpha value for score category colors
#' @param txtsz numeric for size of text in the plot
#' @param family optional chr string indicating font family for text labels
#' @param rev logical if factor levels for bay segments are reversed
#' @param position chr string of location for bay segment labels, default on top, passed to \code{\link[ggplot2]{scale_x_discrete}}
#' @param plotly logical if matrix is created using plotly
#' @param width numeric for width of the plot in pixels, only applies if \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies if \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing trends over time in AMBI scores for each bay segment if \code{plotly = FALSE}, otherwise a \code{\link[plotly]{plotly}} object
#' @export
#'
#' @details
#' An additional summary is provided for the entire bay as an unweighted summary across categories ("All").
#'
#' The default behavior is to use a rolling five-year window to calculate the percent of sites in each AMBI category by bay segment.  This applies only to years 2005 and later, where the counts from the current year and the prior four years are summed to calculate the percentages.  This is intended to help smooth out inter-annual variability due to reduced sampling effort from 2005 to present.  If \code{window = FALSE}, then only single year values are used.
#'
#' The color scale reflects the adjusted AMBI classification (0-10 scale): Unpolluted (dark green), Slightly Polluted (light green), Meanly Polluted (yellow), Heavily Polluted (orange), and Extremely Polluted (red).
#'
#' The matrix tile for each bay segment and year shows the dominant AMBI category based on the plurality of sites.  The dominant category is the one with the highest proportion of sites in that year and bay segment.
#'
#' @concept show
#'
#' @importFrom dplyr "%>%"
#'
#' @examples
#' ambiscr <- anlz_ambiscr(benthicdata)
#' show_ambimatrix(ambiscr)
show_ambimatrix <- function(ambiscr,
                            bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB', 'All'),
                            yrrng = c(1993, 2024), window = TRUE, alph = 1, txtsz = 3,
                            family = 'sans', rev = FALSE, position = 'top',
                            plotly = FALSE, width = NULL, height = NULL) {

  cat_levs <- c('Unpolluted', 'Slightly Polluted', 'Meanly Polluted', 'Heavily Polluted', 'Extremely Polluted')
  cat_cols <- c(
    'Unpolluted'        = '#2DC938',
    'Slightly Polluted' = '#8DBE68',
    'Meanly Polluted'   = '#E9C318',
    'Heavily Polluted'  = '#E07B39',
    'Extremely Polluted' = '#CC3231'
  )

  toplo_wide <- anlz_ambimed(ambiscr, bay_segment = bay_segment,
                             rev = rev, yrrng = yrrng, window = window)

  # find dominant category per row (highest proportion among the five categories)
  toplo <- toplo_wide %>%
    tidyr::pivot_longer(
      cols = dplyr::any_of(cat_levs),
      names_to = 'AMBICat',
      values_to = 'per'
    ) %>%
    dplyr::group_by(bay_segment, yr) %>%
    dplyr::slice_max(per, n = 1, with_ties = FALSE) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(AMBICat = factor(AMBICat, levels = cat_levs))

  p <- ggplot2::ggplot(toplo, ggplot2::aes(x = bay_segment, y = yr, fill = AMBICat)) +
    ggplot2::geom_tile(colour = 'black', alpha = alph) +
    ggplot2::scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = position) +
    ggplot2::scale_fill_manual(values = cat_cols) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      legend.position = 'none',
      panel.grid = ggplot2::element_blank()
    )

  if (!is.null(txtsz))
    p <- p +
      ggplot2::geom_text(ggplot2::aes(label = AMBICat), size = txtsz, family = family)

  if (plotly)
    p <- show_matrixplotly(p, family = family, tooltip = NULL, width = width, height = height)

  return(p)

}
