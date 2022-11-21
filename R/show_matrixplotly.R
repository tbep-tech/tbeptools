#' Creates a plotly matrix from any matrix function input
#'
#' @param mat input matrix as output from \code{\link{show_matrix}}, \code{\link{show_segmatrix}}, \code{\link{show_wqmatrix}}, or \code{\link{show_tbnimatrix}}
#' @param family optional chr string indicating font family for text labels
#' @param tooltip chr string indicating the column name for tooltip
#' @param width numeric for width of the plot in pixels
#' @param height numeric for height of the plot in pixels
#' @param hmp logical indicating if input is from \code{\link{show_hmpreport}}
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
show_matrixplotly <- function(mat, family = NA, tooltip = 'Result', width = NULL, height = NULL, hmp = FALSE){

  # matrix, new theme
  plo <- mat +
    ggplot2::theme(
      axis.text = ggplot2::element_text(size = 12),
      text = ggplot2::element_text(family = family),
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank()
    )

  if(!hmp){

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

    out <- plotly::ggplotly(plo, tooltip = tooltip, width = width, height = height) %>%
      plotly::add_bars(x = collev,y = seq(1, length(collev)), xaxis = 'x2', inherit = F, showlegend = F) %>%
      plotly::layout(xaxis2 = ax)

  }

  if(hmp){

    # get number of columns
    collev <- levels(mat$data$metric)

    # plotly secondary axis
    ax2 <- list(
      tickfont = list(size=8),
      overlaying = "x",
      nticks = length(collev),
      side = "top",
      tickangle = 335,
      ticktext = collev,
      ticklabelposition = 'outside right'
      )

    mxyr <- max(mat$data$year) + 1
    ax3 <- list(
      tickfont = list(size=12),
      overlaying = "x",
      side = "bottom",
      tickangle = 0,
      ticklabelposition = 'outside',
      ticktext = c('Subtidal', 'Intertidal', 'Supratidal')
    )

    out <- plotly::ggplotly(plo, tooltip = tooltip, width = width, height = height) %>%
      plotly::add_bars(x = collev,y = seq(1, length(collev)), xaxis = 'x2', inherit = F, showlegend = F) %>%
      plotly::add_bars(x =c('Subtidal', 'Intertidal', 'Supratidal'), y = c(1, 2, 3), xaxis = 'x3', inherit = F, showlegend = F) %>%
      plotly::layout(xaxis2 = ax2, xaxis3 = ax3, margin = list(l=5, r=5, b=5, t=100), legend = list(y = 0.5))

    out$x$data[c(6, 7, 8)] <- NULL

  }

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
