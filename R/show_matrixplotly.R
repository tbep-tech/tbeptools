#' Creates a plotly matrix from any matrix function input
#'
#' @param mat input matrix as output from \code{\link{show_matrix}}, \code{\link{show_segmatrix}}, \code{\link{show_wqmatrix}}, or \code{\link{show_tbnimatrix}}
#' @param family optional chr string indicating font family for text labels
#' @param tooltip chr string indicating the column name for tooltip
#'
#' @return A plotly data object
#' @export
#'
#' @importFrom magrittr "%>%"
#'
#' @family visualize
#'
#' @examples
#' mat <- show_wqmatrix(epcdata)
#' show_matrixplotly(mat)
show_matrixplotly <- function(mat, family = NA, tooltip = 'Result'){

  # get number of columns
  collev <- mat$data[, mat$labels$x, drop = TRUE] %>%
    droplevels %>%
    levels %>%
    factor(., levels = .)

  # plotly secondary axix
  ax <- list(
    tickfont = list(size=14),
    overlaying = "x",
    nticks = length(collev),
    side = "top"
  )

  # matrix, new theme
  plo <- mat +
    ggplot2::theme(
      axis.text = ggplot2::element_text(size = 12),
      text = ggplot2::element_text(family = family),
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank()
    )

  # plotly output
  out <- plotly::ggplotly(plo, tooltip = tooltip) %>%
    plotly::add_bars(x = collev,y = seq(1, length(collev)), xaxis = "x2", inherit = F) %>%
    plotly::layout(xaxis2 = ax) %>%
    plotly::config(displayModeBar = FALSE)

  return(out)

}
