#' Make a map for tidal creek report card
#'
#' Make a map for tidal creek report card
#'
#' @param dat input score card data returned from \code{\link{anlz_tdlcrk}}
#'
#' @return A \code{\link[leaflet]{leaflet}} object
#'
#' @export
#'
#' @family visualize
#'
#' @examples
#' dat <- anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2018)
#' show_tdlcrk(dat)
show_tdlcrk <- function(dat) {

  # color palette
  pal_exp <- leaflet::colorFactor(
    palette = c('lightblue', 'green', 'yellow', 'orange', 'coral'),
    levels = c('No Data', 'Target', 'Caution', 'Investigate', 'Act')
  )

  # join data to tidalcreeks sf
  tomap <- tidalcreeks %>%
    dplyr::inner_join(dat, by = c('id', 'wbid', 'JEI', 'class')) %>%
    dplyr::mutate(
      score = factor(score, levels = c('No Data', 'Target', 'Caution', 'Investigate', 'Act'))
    )

  out <- mapview::mapview(tomap, homebutton = F) %>%
    .@map %>%
    leaflet::clearMarkers() %>%
    leaflet::clearShapes() %>%
    leaflet::clearControls() %>%
    leaflet::addLegend(data = tomap, "topright", pal = pal_exp, values = ~score,
              title = "Creek scores",
              opacity = 1
    ) %>%
    leaflet::addPolylines(data = tomap, opacity = 1, weight = 1.5, color = ~pal_exp(score),
              layerId = ~id, label = ~paste0("WBID: ", wbid, ", JEI:", JEI, ', Creek score:', score)
    )

  return(out)

}
