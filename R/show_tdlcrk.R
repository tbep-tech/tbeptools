#' Make a map for tidal creek report card
#'
#' Make a map for tidal creek report card
#'
#' @param dat input creek score data returned from \code{\link{anlz_tdlcrk}}
#' @param weight numeric for weight of polylines, passed to \code{\link[leaflet]{addPolylines}}
#'
#' @return A \code{\link[leaflet]{leaflet}} object
#'
#' @export
#'
#' @concept show
#'
#' @examples
#' dat <- anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2021)
#' show_tdlcrk(dat)
show_tdlcrk <- function(dat, weight = 1.5) {

  # color palette
  pal_exp <- leaflet::colorFactor(
    palette = c('#ADD8E6', '#2DC938', '#E9C318', '#EE7600', '#FF4040'), # lightblue, green, yellow, darkorange2, brown1
    levels = c('No Data', 'Monitor', 'Caution', 'Investigate', 'Prioritize')
  )

  # join data to tidalcreeks sf
  tomap <- tidalcreeks %>%
    dplyr::inner_join(dat, by = c('id', 'wbid', 'JEI', 'class', 'name')) %>%
    dplyr::mutate(
      score = factor(score, levels = c('No Data', 'Monitor', 'Caution', 'Investigate', 'Prioritize'))
    )

  sf::st_crs(tomap) <- 4326

  out <- mapview::mapview(tomap, homebutton = F) %>%
    .@map %>%
    leaflet::clearMarkers() %>%
    leaflet::clearShapes() %>%
    leaflet::clearControls() %>%
    leaflet::addLegend(data = tomap, "topright", pal = pal_exp, values = ~score,
              title = "Creek scores",
              opacity = 1
    ) %>%
    leaflet::addPolylines(data = tomap, opacity = 1, weight = weight, color = ~pal_exp(score),
              layerId = ~id, label = ~paste0("WBID: ", wbid, ", JEI: ", JEI, ', Name: ', name, ', Creek score: ', score)
    )

  return(out)

}
