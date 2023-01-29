#' Make a map for sediment PEL ratios at stations in Tampa Bay
#'
#' Make a map for sediment PEL ratios at stations in Tampa Bay
#'
#' @inheritParams anlz_sedimentpel
#' @param weight numeric for outline width of station points on the map
#'
#' @return A \code{\link[leaflet]{leaflet}} object
#' @export
#'
#' @concept show
#'
#' @details The map shows average PEL ratios graded from A to F for benthic stations monitored in Tampa Bay. The PEL is a measure of how likely a contaminant is to have a toxic effect on invertebrates that inhabit the sediment. The PEL ratio is the contaminant concentration divided by the Potential Effects Levels (PEL) that applies to a contaminant, if available. Higher ratios and lower grades indicate sediment conditions that are likely unfavorable for invertebrates. The station average combines the PEL ratios across all contaminants measured at a station.
#'
#' @examples
#' show_sedimentpelmap(sedimentdata)
show_sedimentpelmap <- function(sedimentdata, yrrng = c(1993, 2021), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = c('TBEP', 'TBEP-Special', 'Apollo Beach', 'Janicki Contract', 'Rivers', 'Tidal Streams'), weight = 1.5){

  # map prep
  tomap <- anlz_sedimentpel(sedimentdata, yrrng = yrrng, bay_segment = bay_segment, funding_proj = funding_proj) %>%
    sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326)

  # for legend
  pal_exp <- leaflet::colorFactor(
    palette = c('#2DC938', '#A2FD7A', '#E9C318', '#EE7600', '#CC3231'),
    levels = c('A', 'B', 'C', 'D', 'F')
  )

  # bounding box
  bbx <- sf::st_bbox(tomap) %>%
    as.numeric()

  # create map
  out <- mapview::mapView(map.types = mapview::mapviewGetOption("basemaps")) %>%
    .@map %>%
    leaflet::addLegend(data = tomap, "topright", pal = pal_exp, values = ~Grade,
                       title = "Site categories",
                       opacity = 1
    ) %>%
    leaflet::addCircleMarkers(
      data = tomap,
      layerId = ~StationNumber,
      stroke = T,
      color = 'black',
      fill = TRUE,
      fillOpacity = 1,
      weight = weight,
      radius = 4,
      fillColor = ~pal_exp(Grade),
      label = ~paste0("StationNumber: ", StationNumber, ", Year: ", yr, ', PEL ratio: ', round(PELRatio, 5), ', Grade: ', Grade)
    ) %>%
    leaflet::fitBounds(lng1 = bbx[1], lng2 = bbx[3], lat1 = bbx[2], lat2 = bbx[4])

  return(out)

}
