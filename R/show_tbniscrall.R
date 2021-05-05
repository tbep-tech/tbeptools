#' Plot Tampa Bay Nekton Index scores over time as average across bay segments
#'
#' Plot Tampa Bay Nekton Index scores over time as average across bay segments
#'
#' @param tbniscr input dat frame as returned by \code{\link{anlz_tbniscr}}
#' @param perc numeric values indicating break points for score categories
#' @param alph numeric indicating alpha value for score category colors
#' @param ylim numeric for y axis limits
#' @param rev logical if factor levels for bay segments are reversed
#' @param plotly logical if matrix is created using plotly
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
#' show_tbniscrall(tbniscr)
show_tbniscrall <- function(tbniscr, perc = c(32, 46), alph = 0.3, ylim = c(22 ,58), rev = FALSE, plotly = FALSE){

  # sanity checks
  stopifnot(length(perc) == 2)
  stopifnot(perc[1] < perc[2])
  stopifnot(perc[1] > 22)
  stopifnot(perc[2] < 58)

  # annual average by segment
  toplo <- tbniscr %>%
    dplyr::group_by(Year) %>%
    dplyr::summarize(
      TBNI_Scoreall = round(mean(TBNI_Score), 0),
      seval = sd(TBNI_Score) / sqrt(n())
    ) %>%
    dplyr::ungroup() %>%
    dplyr::rename(TBNI_Score = TBNI_Scoreall)

  secol <- 'grey88'
  if(plotly)
    secol <- 'grey60'

  # plot
  out <- ggplot2::ggplot(toplo) +
    annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = perc[1], alpha = alph, fill = 'red') +
    annotate("rect", xmin = -Inf, xmax = Inf, ymin = perc[1], ymax = perc[2], alpha = alph, fill = 'yellow') +
    annotate("rect", xmin = -Inf, xmax = Inf, ymin = perc[2], ymax = Inf, alpha = alph, fill = 'green') +
    geom_ribbon(aes(x = Year, ymin = TBNI_Score - seval, ymax = TBNI_Score + seval), fill = secol) +
    ggplot2::geom_line(aes(x = Year, y = TBNI_Score), size = 1.25) +
    ggplot2::scale_y_continuous(name = "TBNI average of bay segments", limits = ylim, breaks = seq(ylim[1], ylim[2], 4)) +
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
      panel.grid.minor = ggplot2::element_blank()
    )

  if(plotly)
    out <- show_tbniscrplotly(out)

  return(out)

}
