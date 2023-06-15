#' Map Fecal Indicator Bacteria (FIB) results by month, year, and location
#'
#' @inheritParams anlz_fibcat
#'
#' @return a leaflet map
#'
#' @concept anlz
#'
#' @export
#'
#' @examples
#' show_fibmap(fibdata, yrsel = 2020, mosel = 7, areasel = 'Hillsborough')
show_fibmap <- function(fibdata, yrsel, mosel, areasel){

  fibcat <- anlz_fibcat(fibdata, yrsel = yrsel, mosel = mosel, areasel = areasel)

  tomap <- fibcat %>%
    dplyr::filter(!is.na(Longitude)) %>%
    dplyr::filter(!is.na(Latitude)) %>%
    dplyr::filter(!is.na(cat)) %>%
    sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326, remove = F) %>%
    dplyr::mutate(
      colnm = factor(col,
                                  levels = c('#2DC938', '#E9C318', '#EE7600', '#CC3231'),
                                  labels = c('green', 'yellow', 'orange', 'red')
                                  ),
      indnm = factor(ind,
                                  levels = c('E. coli', 'Enterococcus'),
                                  labels = c('ecoli', 'ecocci')
                           )
    ) %>%
    tidyr::unite('grp', indnm, colnm, remove = F)

  levs <- expand.grid(levels(tomap$colnm), levels(tomap$indnm)) %>%
    unite('levs', Var2, Var1) %>%
    pull(levs)

  # get correct levels
  tomap <- tomap %>%
    dplyr::mutate(
      grp = factor(grp, levels = levs)
    ) %>%
    dplyr::select(-colnm, -indnm)


  icons <- leaflet::iconList(
    ecoli_green <- leaflet::makeIcon(iconUrl = system.file('ecoli_green.png', package = 'tbeptools'),
                            iconWidth = 18, iconHeight = 18),
    ecoli_yellow <- leaflet::makeIcon(iconUrl = system.file('ecoli_yellow.png', package = 'tbeptools'),
                             iconWidth = 18, iconHeight = 18),
    ecoli_orange <- leaflet::makeIcon(iconUrl = system.file('ecoli_orange.png', package = 'tbeptools'),
                           iconWidth = 18, iconHeight = 18),
    ecoli_red <- leaflet::makeIcon(iconUrl = system.file('ecoli_red.png', package = 'tbeptools'),
                            iconWidth = 18, iconHeight = 18),
    ecocci_green <- leaflet::makeIcon(iconUrl = system.file('ecocci_green.png', package = 'tbeptools'),
                             iconWidth = 18, iconHeight = 18),
    ecocci_yellow <- leaflet::makeIcon(iconUrl = system.file('ecocci_yellow.png', package = 'tbeptools'),
                           iconWidth = 18, iconHeight = 18),
    ecocci_orange <- leaflet::makeIcon(iconUrl = system.file('ecocci_orange.png', package = 'tbeptools'),
                              iconWidth = 18, iconHeight = 18),
    ecocci_red <- leaflet::makeIcon(iconUrl = system.file('ecocci_red.png', package = 'tbeptools'),
                               iconWidth = 18, iconHeight = 18)
  )

  esri <- rev(grep("^Esri", leaflet::providers, value = TRUE))

  bnds <- sf::st_bbox(tomap)

  m <- leaflet::leaflet() %>%
    leaflet::fitBounds(bnds[['xmin']], bnds[['ymin']], bnds[['xmax']], bnds[['ymax']])

  for (provider in esri) {
    m <- m %>% leaflet::addProviderTiles(provider, group = provider)
  }

  out <- m %>%
    leaflet::addLayersControl(baseGroups = names(esri),
                     options = leaflet::layersControlOptions(collapsed = T)) %>%
    leaflet::addMarkers(data = tomap, lng = ~Longitude, lat = ~Latitude, icon = ~icons[as.numeric(grp)]) %>%
    leaflet::addMiniMap(
      tiles = leaflet::providers$Esri.WorldGrayCanvas,
      toggleDisplay = TRUE,
      position = 'bottomleft'
      ) #%>%
    # htmlwidgets::onRender("
    #   function(el, x) {
    #     var myMap = this;
    #     myMap.on('baselayerchange',
    #       function (e) {
    #         myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
    #       })
    #   }")

  return(out)

}
