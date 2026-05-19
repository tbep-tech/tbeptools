#' Plot mean AMBI scores over time by bay segment
#'
#' Plot mean AMBI scores over time by bay segment
#'
#' @param ambiscr input data frame as returned by \code{\link{anlz_ambiscr}}, the AMBI variant (conventional or Tampa Bay-specific) is detected automatically from the column names
#' @param ambiscr_tb optional second input data frame from \code{\link{anlz_ambiscr}} for overlaying the other AMBI variant on the same plot
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB", "All". When multiple segments are selected (or "All"), scores are averaged across all sites in the selected segments.
#' @param yrrng numeric vector of length two indicating the year range to plot
#' @param yscl logical indicating whether the y-axis should span the full adjusted AMBI range (0 to 10, default \code{TRUE}) or be scaled to the range of the annual means (\code{FALSE})
#' @param plotly logical if the plot is created using plotly
#' @param width numeric for width of the plot in pixels, only applies if \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies if \code{plotly = TRUE}
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing mean adjusted AMBI scores by year if \code{plotly = FALSE}, otherwise a \code{\link[plotly]{plotly}} object
#' @export
#'
#' @details
#' The background of the plot is shaded by AMBI pollution category using the adjusted score thresholds (0-10 scale, higher = healthier): Unpolluted (8.29-10, dark green), Slightly Polluted (5.29-8.29, light green), Meanly Polluted (2.89-5.29, yellow), Heavily Polluted (1.39-2.89, orange), and Extremely Polluted (0-1.39, red).
#'
#' Only sampling funded by TBEP and as part of the routine EPC benthic monitoring program are included.
#'
#' If both \code{ambiscr} and \code{ambiscr_tb} are provided, both series are shown on the same plot with dark grey used for the first series and black for the second.  The AMBI variant for each input is detected automatically from the column names (\code{AMBI} or \code{TBAMBI}).
#'
#' @concept show
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' ambiscr    <- anlz_ambiscr(benthicdata)
#' ambiscr_tb <- anlz_ambiscr(benthicdata, type = 'AMBI-TB')
#' show_ambitrend(ambiscr, ambiscr_tb)
show_ambitrend <- function(ambiscr, ambiscr_tb = NULL,
                           bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB', 'All'),
                           yrrng = c(1993, 2024), yscl = TRUE,
                           plotly = FALSE, width = NULL, height = NULL) {

  segs <- c('OTB', 'HB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')

  if ('All' %in% bay_segment) {
    seg_filter <- segs
  } else {
    seg_filter <- intersect(bay_segment, segs)
  }

  if (length(yrrng) == 1)
    yrrng <- rep(yrrng, 2)

  stopifnot(length(yrrng) == 2)
  stopifnot(yrrng[1] <= yrrng[2])

  get_means <- function(dat, score_col, type_label) {
    dat %>%
      dplyr::filter(AreaAbbr %in% seg_filter) %>%
      dplyr::filter(FundingProject %in% 'TBEP') %>%
      dplyr::filter(ProgramID %in% 4) %>%
      dplyr::filter(!is.na(.data[[score_col]])) %>%
      dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
      dplyr::group_by(yr) %>%
      dplyr::summarise(score = mean(.data[[score_col]]), .groups = 'drop') %>%
      dplyr::mutate(type = type_label)
  }

  detect_type <- function(dat, arg_name) {
    if ('AMBI' %in% names(dat))
      return(list(col = 'AMBI', label = 'GOM AMBI'))
    if ('TBAMBI' %in% names(dat))
      return(list(col = 'TBAMBI', label = 'TB AMBI'))
    stop(arg_name, " must contain an 'AMBI' or 'TBAMBI' column; run anlz_ambiscr() first.")
  }

  info1 <- detect_type(ambiscr, 'ambiscr')
  dat1  <- get_means(ambiscr, info1$col, info1$label)

  dat2 <- NULL
  if (!is.null(ambiscr_tb)) {
    info2 <- detect_type(ambiscr_tb, 'ambiscr_tb')
    dat2  <- get_means(ambiscr_tb, info2$col, info2$label)
  }

  plot_dat <- dplyr::bind_rows(dat1, dat2) %>%
    dplyr::mutate(type = factor(type, levels = c('GOM AMBI', 'TB AMBI')))

  type_col <- c('GOM AMBI' = 'darkgrey', 'TB AMBI' = 'black')

  y_lims <- if (yscl) c(0, 10) else {
    pad <- diff(range(plot_dat$score)) * 0.05
    range(plot_dat$score) + c(-pad, pad)
  }

  p <- ggplot2::ggplot(plot_dat, ggplot2::aes(x = yr, y = score)) +
    ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = 0,    ymax = 1.39, fill = '#CC3231', alpha = 0.6) +
    ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = 1.39, ymax = 2.89, fill = '#E07B39', alpha = 0.6) +
    ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = 2.89, ymax = 5.29, fill = '#E9C318', alpha = 0.6) +
    ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = 5.29, ymax = 8.29, fill = '#8DBE68', alpha = 0.6) +
    ggplot2::annotate('rect', xmin = -Inf, xmax = Inf, ymin = 8.29, ymax = 10,   fill = '#2DC938', alpha = 0.6) +
    ggplot2::geom_line(ggplot2::aes(colour = type, group = type), linewidth = 0.6) +
    ggplot2::geom_point(ggplot2::aes(colour = type), size = 1.5) +
    ggplot2::scale_colour_manual(values = type_col, name = NULL, drop = FALSE) +
    ggplot2::scale_x_continuous(breaks = seq(yrrng[1], yrrng[2], by = 2)) +
    ggplot2::scale_y_continuous(expand = c(0, 0)) +
    ggplot2::coord_cartesian(ylim = y_lims) +
    ggplot2::labs(x = NULL, y = 'Adjusted AMBI Score') +
    ggplot2::theme_bw() +
    ggplot2::theme(
      legend.position = 'bottom',
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      panel.grid = ggplot2::element_blank()
    )

  if (plotly) {

    pb <- ggplot2::ggplot_build(p)
    x_range <- pb$layout$panel_params[[1]]$x.range

    shps <- list(
      list(type = 'rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor = 'rgba(204,50,49,0.6)',
           x0 = x_range[1], x1 = x_range[2], y0 = 0,    y1 = 1.39, layer = 'below'),
      list(type = 'rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor = 'rgba(224,123,57,0.6)',
           x0 = x_range[1], x1 = x_range[2], y0 = 1.39, y1 = 2.89, layer = 'below'),
      list(type = 'rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor = 'rgba(233,195,24,0.6)',
           x0 = x_range[1], x1 = x_range[2], y0 = 2.89, y1 = 5.29, layer = 'below'),
      list(type = 'rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor = 'rgba(141,190,104,0.6)',
           x0 = x_range[1], x1 = x_range[2], y0 = 5.29, y1 = 8.29, layer = 'below'),
      list(type = 'rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor = 'rgba(45,201,56,0.6)',
           x0 = x_range[1], x1 = x_range[2], y0 = 8.29, y1 = 10,   layer = 'below')
    )

    p <- plotly::ggplotly(p, width = width, height = height)
    p[['x']][['layout']][['shapes']] <- c()
    p <- plotly::layout(p, shapes = shps,
                        xaxis = list(showgrid = FALSE),
                        yaxis = list(showgrid = FALSE)) %>%
      plotly::config(toImageButtonOptions = list(format = 'svg', filename = 'myplot'))

  }

  return(p)

}
