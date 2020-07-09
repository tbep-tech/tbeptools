#' Creates a plotly obect for TBNI score plots
#'
#' @param p \code{\link[ggplot2]{ggplot}} object as output from \code{\link{show_tbniscr}} or \code{\link{show_tbniscrall}}
#'
#' @return A \code{\link[plotly]{plotly}} data object
#' @export
#'
#' @importFrom magrittr "%>%"
#'
#' @family visualize
#'
#' @examples
#' tbniscr <- anlz_tbniscr(fimdata)
#' p <- show_tbniscrall(tbniscr)
#' show_tbniscrplotly(p)
show_tbniscrplotly <- function(p){

  # xmax value
  xmax <- max(p$data$Year) + 0.55

  # build ggplot to extract
  pg <- ggplot2::ggplot_build(p)$data

  # get y intercept lines from perc
  perc <- pg[grepl('yintercept', lapply(pg, names))]
  perc <- lapply(perc, function(x) unique(x$yintercept)) %>% unlist

  # alpha
  alph <- pg[[1]]$alpha

  p <- plotly::ggplotly(p)

  shp1 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(255,0,0,", alph, ")"),
               x0 = 1997.45, x1 = xmax, y0 = 0, y1 = perc[1])

  shp2 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(255,255,0,", alph, ")"),
               x0 = 1997.45, x1 = xmax, y0 = perc[1], y1 = perc[2])

  shp3 <- list(type='rect', line = list(color = 'rgba(0,0,0,0)'), fillcolor=paste0("rgba(0,255,0,", alph, ")"),
               x0 = 1997.45, x1 = xmax, y0 = perc[2], y1 = 100)

  shapes <- list(shp1, shp2, shp3)

  p[['x']][['layout']][['shapes']] <- c()

  out <- plotly::layout(p, shapes = shapes)

  return(out)

}
