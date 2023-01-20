#' Creates a plotly object for average PEL plots
#'
#' @param p \code{\link[ggplot2]{ggplot}} object as output from \code{\link{show_sedimentpelave}}
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
#' p <- show_sedimentpelave(sedimentdata)
#' show_sedimentpelaveplotly(p)
show_sedimentpelaveplotly <- function(p, width = NULL, height = NULL){

  # build ggplot to extract
  pb <- ggplot2::ggplot_build(p)
  pg <- pb$data

  xmax <- pb$layout$panel_params[[1]]$x.range[2] + 1
  ymax <- pb$layout$panel_params[[1]]$y.range[2]

  # get y intercept lines from brks
  brks <- pg[which(lapply(pg, function(x) -1 %in% x$group) %>% unlist)]
  brks <- lapply(brks, function(x) unique(x$yintercept)) %>% unlist

  # alpha
  alph <- pg[[1]]$alpha

  p <- plotly::ggplotly(p, width = width, height = height)

  shp5 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(204,50,49,", alph, ")"), # red
               x0 = 0, x1 = xmax, y0 = brks[4], y1 = ymax, layer = 'below')

  shp4 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(238,118,0,", alph, ")"), # orange
               x0 = 0, x1 = xmax, y0 = brks[3], y1 = brks[4], layer = 'below')

  shp3 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(233,195,24,", alph, ")"), # yellow
               x0 = 0, x1 = xmax, y0 = brks[2], y1 = brks[3], layer = 'below')

  shp2 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(162,253,122,", alph, ")"), # lightgreen
               x0 = 0, x1 = xmax, y0 = brks[1], y1 = brks[2], layer = 'below')

  shp1 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(45,201,56,", alph, ")"), # green
               x0 = 0, x1 = xmax, y0 = 0, y1 = brks[1], layer = 'below')

  shapes <- list(shp1, shp2, shp3, shp4, shp5)

  p[['x']][['layout']][['shapes']] <- c()

  out <- plotly::layout(p, shapes = shapes) %>%
    plotly::config(
      toImageButtonOptions = list(
        format = "svg",
        filename = "myplot"
      )
    )

  return(out)

}
