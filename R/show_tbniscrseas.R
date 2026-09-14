#' Plot seasonal Tampa Bay Nekton Index results by month and bay segment
#'
#' Plot seasonal Tampa Bay Nekton Index results by month and bay segment
#'
#' @param tbniscr input dat frame as returned by \code{\link{anlz_tbniscr}}
#' @param bay_segment chr string for the bay segment to plot, one of "OTB", "HB", "MTB", "LTB"
#' @param yr numeric for the year to plot
#' @param metric chr string for the column in \code{tbniscr} to plot on the y-axis, defaults to \code{NULL} to plot \code{"TBNI_Score"}, otherwise an individual TBNI metric can be specified, one of "TBNI_Score", "NumTaxa", "BenthicTaxa", "TaxaSelect", "NumGuilds", or "Shannon"
#' @param perc numeric values indicating break points for score categories, only used if \code{metric} is \code{NULL} or \code{"TBNI_Score"}
#' @param alph numeric indicating alpha value for the score category background colors and the boxplot fill, only used if \code{metric} is \code{NULL} or \code{"TBNI_Score"}
#' @param plotly logical if matrix is created using plotly
#' @param family optional chr string indicating font family for text labels
#' @param width numeric for width of the plot in pixels, only applies of \code{plotly = TRUE}
#' @param height numeric for height of the plot in pixels, only applies of \code{plotly = TRUE}
#'
#' @details Boxplots show the distribution of site-level results by month for \code{yr} in \code{bay_segment}, with individual site values overlaid as jittered points.  If \code{metric} is \code{NULL} or \code{"TBNI_Score"}, the TBNI score is plotted with the same red/yellow/green score category background and break lines from \code{perc} as in \code{\link{show_tbniscr}}.  If a different metric is specified, it is plotted as raw values with no background (note that scored metrics cannot be shown).  Metric options include \code{"TBNI_Score"} or \code{NULL} (default), \code{"NumTaxa"}, \code{"BenthicTaxa"}, \code{"TaxaSelect"}, \code{"NumGuilds"}, and \code{"Shannon"}.  The y-axis title includes \code{yr}, \code{bay_segment}, and the plotted metric.
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing monthly results for \code{yr} in \code{bay_segment} for the selected metric, or a \code{\link[plotly]{plotly}} object if \code{plotly = TRUE}
#' @export
#'
#' @concept show
#'
#' @importFrom dplyr "%>%"
#'
#' @examples
#' tbniscr <- anlz_tbniscr(fimdata)
#' show_tbniscrseas(tbniscr, bay_segment = 'OTB', yr = 2018)
show_tbniscrseas <- function(tbniscr, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), yr, metric = NULL, perc = c(32, 46),
                            alph = 1, plotly = FALSE, family = 'sans', width = NULL, height = NULL){

  # plain english labels for metric columns in tbniscr
  metlab <- c(
    TBNI_Score = 'TBNI Score',
    NumTaxa = 'Number of Taxa',
    BenthicTaxa = 'Benthic Taxa',
    TaxaSelect = 'Selected Taxa',
    NumGuilds = 'Number of Guilds',
    Shannon = 'Shannon Diversity'
  )

  # sanity checks
  bay_segment <- match.arg(bay_segment, c('OTB', 'HB', 'MTB', 'LTB'))
  if(!yr %in% tbniscr$Year)
    stop(paste('yr must be one of', paste(range(tbniscr$Year, na.rm = TRUE), collapse = ' to ')))

  # resolve metric, defaults to TBNI_Score if not specified
  if(is.null(metric))
    metric <- 'TBNI_Score'
  else
    metric <- match.arg(metric, names(metlab))

  # perc only applies if TBNI_Score is plotted
  useperc <- metric == 'TBNI_Score'
  if(useperc){

    stopifnot(length(perc) == 2)
    stopifnot(perc[1] < perc[2])
    stopifnot(perc[1] > 22)
    stopifnot(perc[2] < 58)

  }

  # bay segment factor levels
  levs <- c("OTB", "HB", "MTB", "LTB")

  # data to plot
  toplo <- tbniscr %>%
    dplyr::filter(Year == !!yr) %>%
    dplyr::filter(bay_segment == !!bay_segment) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = levs),
      Month = factor(month.abb[Month], levels = month.abb)
    )
  toplo$val <- toplo[[metric]]

  # boxplot colors
  boxcol <- 'grey88'
  
  # plot
  out <- ggplot2::ggplot(toplo, ggplot2::aes(x = Month, y = val))

  # score category background and break lines, TBNI_Score only
  if(useperc)
    out <- out +
      ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = perc[1], alpha = alph, fill = '#CC3231') + # red
      ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = perc[1], ymax = perc[2], alpha = alph, fill = '#E9C318') + # yellow
      ggplot2::annotate("rect", xmin = -Inf, xmax = Inf, ymin = perc[2], ymax = Inf, alpha = alph, fill = '#2DC938') + # green
      ggplot2::geom_hline(ggplot2::aes(yintercept = perc[1]), color = "black", linetype = "dotted") +
      ggplot2::geom_hline(ggplot2::aes(yintercept = perc[2]), color = "black", linetype = "dotted")

  # station shown on point mouseover, plotly only
  ptaes <- ggplot2::aes()
  if(plotly)
    ptaes <- ggplot2::aes(text = Reference)

  out <- out +
    ggplot2::geom_boxplot(alpha = alph, outlier.shape = NA, fill = boxcol) +
    suppressWarnings(ggplot2::geom_point(ptaes, position = ggplot2::position_jitter(width = 0.2), size = 1.5, alpha = 0.7)) +
    ggplot2::scale_x_discrete(drop = FALSE) +
    ggplot2::scale_y_continuous(name = paste(yr, bay_segment, metlab[[metric]])) +
    ggplot2::theme(
      axis.title.x = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_text(size = 12),
      axis.text.x = ggplot2::element_text(size = 12),
      legend.position = 'none',
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      text = ggplot2::element_text(family = family)
    )

  if(plotly & useperc)
    out <- show_tbniscrplotly(out, width = width, height = height)
  else if(plotly)
    out <- plotly::ggplotly(out, width = width, height = height)

  return(out)

}
