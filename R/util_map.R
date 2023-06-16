#' Create an empty leaflet map from sf input
#'
#' @param tomap \code{sf} input object
#' @param minimap character string indicating location of minimap, use \code{minimap = NULL} to suppress
#'
#' @return A \code{leaflet} object with optional minimap and ESRI provider tiles
#' @export
#'
#' @concept util

#' @examples
#' tomap <- tibble::tibble(
#'   lon = -82.6365,
#'   lat = 27.75822
#'   )
#' tomap <- sf::st_as_sf(tomap, coords = c('lon', 'lat'), crs = 4326)
#' util_map(tomap)
util_map <- function(tomap, minimap = 'bottomleft'){

  bnds <- sf::st_bbox(tomap)

  esri <- rev(grep("^Esri", leaflet::providers, value = TRUE))

  m <- leaflet::leaflet() %>%
    leaflet::fitBounds(bnds[['xmin']], bnds[['ymin']], bnds[['xmax']], bnds[['ymax']])

  for (provider in esri) {
    m <- m %>% leaflet::addProviderTiles(provider, group = provider)
  }

  out <- m %>%
    leaflet::addLayersControl(baseGroups = names(esri),
                              options = leaflet::layersControlOptions(collapsed = T),
                              position = 'topleft')

  # add inset minimap if not null
  if(!is.null(minimap))
    out <- out %>%
      leaflet::addMiniMap(
        tiles = leaflet::providers$Esri.WorldGrayCanvas,
        toggleDisplay = TRUE,
        position = minimap,
        minimized = TRUE
      ) %>%
    htmlwidgets::onRender("
      function(el, x) {
        var myMap = this;
        myMap.on('baselayerchange',
          function (e) {
            myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
          })
      }")

  return(out)

}
