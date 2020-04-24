#' Plot a matrix of Tampa Bay Nekton Index scores over time by bay segment
#'
#' Plot a matrix of Tampa Bay Nekton Index scores over time by bay segment
#'
#' @param tbniscr input dat frame as returned by \code{\link{anlz_tbniscr}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB"
#' @param perc numeric values indicating break points for score categories
#' @param alph numeric indicating alpha value for score category colors
#' @param txtsz numeric for size of text in the plot
#' @param family optional chr string indicating font family for text labels
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing trends over time in TBNI scores for each bay segment
#' @export
#'
#' @family visualize
#'
#' @importFrom magrittr "%>%"
#'
#' @examples
#' tbniscr <- anlz_tbniscr(fimdata)
#' show_tbnimatrix(tbniscr)
show_tbnimatrix <- function(tbniscr, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), perc = c(32, 46), alph = 0.3, txtsz = 3, family = NA){

  # sanity checks
  stopifnot(length(perc) == 2)
  stopifnot(perc[1] < perc[2])
  stopifnot(perc[1] > 22)
  stopifnot(perc[2] < 58)

  # bay segment factor levels
  levs <- c("OTB", "HB", "MTB", "LTB")

  # annual average by segment
  toplo <- anlz_tbniave(tbniscr, bay_segment) %>%
    dplyr::mutate(
      segment_col = findInterval(Segment_TBNI, perc),
      segment_col = factor(segment_col, levels = c('0', '1', '2'), labels = c('red', 'yellow', 'green')),
      segment_col = as.character(segment_col)
    )

  p <- ggplot2::ggplot(toplo, aes(x = bay_segment, y = Year, fill = segment_col)) +
    ggplot2::geom_tile(colour = 'black', alpha = alph) +
    ggplot2::scale_y_reverse(expand = c(0, 0), breaks = toplo$Year) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = 'top') +
    ggplot2::scale_fill_manual(values = c(red = 'red', yellow = 'yellow', green = 'green')) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      legend.position = 'none',
      panel.grid = ggplot2::element_blank()
    )

  if(!is.null(txtsz))
    p <- p +
      ggplot2::geom_text(aes(label = segment_col), size = txtsz, family = family)

  return(p)

}
