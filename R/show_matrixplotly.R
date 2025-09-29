#' Creates a plotly matrix from any matrix function input
#'
#' @param mat input matrix as output from \code{\link{show_matrix}}, \code{\link{show_segmatrix}}, \code{\link{show_wqmatrix}}, or \code{\link{show_tbnimatrix}}
#' @param family optional chr string indicating font family for text labels
#' @param tooltip chr string indicating the column name for tooltip
#' @param width numeric for width of the plot in pixels
#' @param height numeric for height of the plot in pixels
#'
#' @return A \code{\link[plotly]{plotly}} data object
#' @export
#'
#' @importFrom dplyr "%>%"
#'
#' @concept show
#'
#' @examples
#' mat <- show_wqmatrix(epcdata)
#' show_matrixplotly(mat)
show_matrixplotly <- function(mat, family = 'sans', tooltip = 'Result', width = NULL, height = NULL){

  # matrix, new theme
  plo <- mat +
    ggplot2::theme(
      axis.text = ggplot2::element_text(size = 12),
      text = ggplot2::element_text(family = family),
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank()
    )

  # get number of columns
  collev <- mat$data[, ggplot2::as_label(mat$mapping$x), drop = TRUE] %>%
    droplevels %>%
    levels %>%
    factor(., levels = .)

  # plotly secondary axix
  ax <- list(
    tickfont = list(size=14),
    overlaying = "x",
    nticks = length(collev),
    side = "top",
    automargin = T
  )

  out <- plotly::ggplotly(plo, tooltip = tooltip, width = width, height = height) %>%
    plotly::add_bars(x = collev, y = seq(1, length(collev)), xaxis = 'x2', inherit = F, showlegend = F) %>%
    plotly::layout(
      xaxis2 = ax
      )

  # plotly output
  out <- out %>%
    plotly::config(
      toImageButtonOptions = list(
        format = "svg",
        filename = "myplot"
      )
    )

  return(out)

}
