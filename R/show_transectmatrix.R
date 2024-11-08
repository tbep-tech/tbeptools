#' Show matrix of seagrass frequency occurrence by bay segments and year
#'
#' @param transectocc data frame returned by \code{\link{anlz_transectocc}}
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"
#' @param total logical indicating if average frequency occurrence is calculated for the entire bay across segments
#' @param neutral logical indicating if a neutral and continuous color scheme is used
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
#' @details Results are based on averages across species by date and transect in each bay segment
#'
#' @return A \code{\link[ggplot2]{ggplot}} object showing trends over time for each bay segment if \code{plotly = FALSE}, otherwise a \code{\link[plotly]{plotly}} object
#' @export
#'
#' @concept show
#'
#' @importFrom dplyr "%>%"
#'
#' @details
#' The color scheme is based on arbitrary breaks at 25, 50, and 75 percent frequency occurrence.  These don't necessarily translate to any ecological breakpoints.  Use \code{neutral = TRUE} to use a neutral and continuous color palette.
#'
#' @references
#' This plot is a representation of Table 1 in R. Johansson (2016) Seagrass Transect Monitoring in Tampa Bay: A Summary of Findings from 1997 through 2015, Technical report #08-16, Tampa Bay Estuary Program, St. Petersburg, Florida.
#'
#' @examples
#' \dontrun{
#' transect <- read_transect()
#' }
#' transectocc <- anlz_transectocc(transect)
#' show_transectmatrix(transectocc)
show_transectmatrix <- function(transectocc, bay_segment = c('OTB', 'HB', 'MTB', 'LTB', 'BCB'), total = TRUE, neutral = FALSE,
                                yrrng = c(1998, 2024), alph = 1, txtsz = 3, family = NA, rev = FALSE, position = 'top',
                                plotly = FALSE, width = NULL, height = NULL){

  # annual average by segment
  toplo <- anlz_transectave(transectocc, bay_segment = bay_segment, total = total, rev = rev, yrrng = yrrng)

  # plot

  # stoplight
  if(!neutral){

    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = bay_segment, y = yr, fill = focat)) +
      ggplot2::geom_tile(colour = 'black', alpha = alph) +
      ggplot2::scale_fill_manual(values = levels(toplo$focat))

  }

  # neutral
  if(neutral){

    p <- ggplot2::ggplot(toplo, ggplot2::aes(x = bay_segment, y = yr, fill = foest)) +
      ggplot2::geom_tile(colour = 'black', alpha = alph) +
      ggplot2::scale_fill_gradient2(low = 'white', mid = '#7fcdbb', high = '#2c7fb8', limits = c(0, 100), midpoint = 50)

  }

  # format plot
  p <- p +
    ggplot2::scale_y_reverse(expand = c(0, 0), breaks = toplo$yr) +
    ggplot2::scale_x_discrete(expand = c(0, 0), position = position) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.title = ggplot2::element_blank(),
      legend.position = 'none',
      panel.grid = ggplot2::element_blank()
    )

  # add horizontal line if total
  if(total){

    # get location of line
    val <- 1
    fudge <- 0.5
    if(rev){
      fudge <- -1 * fudge
      val <- length(bay_segment) + 2 - val
    }

    p <- p +
      ggplot2::geom_vline(xintercept = val + fudge, size = 2)

  }

  if(!is.null(txtsz))
    p <- p +
      ggplot2::geom_text(aes(label = round(foest, 0)), size = txtsz, family = family)

  if(plotly)
    p <- show_matrixplotly(p, family = family, tooltip = NULL, width = width, height = height)


  return(p)

}
