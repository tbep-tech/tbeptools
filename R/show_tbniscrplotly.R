#' Creates a plotly object for TBNI score plots
#'
#' @param p \code{\link[ggplot2]{ggplot}} object as output from \code{\link{show_tbniscr}}, \code{\link{show_tbniscrall}}, or \code{\link{show_tbniscrseas}} (with \code{metric = NULL})
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
#' tbniscr <- anlz_tbniscr(fimdata)
#' p <- show_tbniscrall(tbniscr)
#' show_tbniscrplotly(p)
show_tbniscrplotly <- function(p, width = NULL, height = NULL){

  # build ggplot to extract
  pb <- ggplot2::ggplot_build(p)
  pg <- pb$data

  # axis ranges, i.e., including expansion so background rects cover the full panel
  xrng <- pb$layout$panel_params[[1]]$x.range
  yrng <- pb$layout$panel_params[[1]]$y.range

  # get y intercept lines from perc
  perc <- pg[grepl('yintercept', lapply(pg, names))]
  perc <- lapply(perc, function(x) unique(x$yintercept)) %>% unlist

  # alpha
  alph <- pg[[1]]$alpha

  p <- plotly::ggplotly(p, width = width, height = height)

  shp1 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(204,50,49,", alph, ")"), # red
               x0 = xrng[1], x1 = xrng[2], y0 = yrng[1], y1 = perc[1], layer = 'below')

  shp2 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(233,195,24,", alph, ")"), # yellow
               x0 = xrng[1], x1 = xrng[2], y0 = perc[1], y1 = perc[2], layer = 'below')

  shp3 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(45,201,56,", alph, ")"), # green
               x0 = xrng[1], x1 = xrng[2], y0 = perc[2], y1 = yrng[2], layer = 'below')

  shapes <- list(shp1, shp2, shp3)

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
