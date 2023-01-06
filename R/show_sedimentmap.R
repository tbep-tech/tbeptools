#' Make a map for sediment contaminants at stations in Tampa Bay
#'
#' Make a map for sediment contaminants at stations in Tampa Bay
#'
#' @param sedimentdata input sediment \code{data.frame} as returned by \code{\link{read_importsediment}}
#' @param param chr string for which parameter to plot
#' @param yrrng numeric vector indicating min, max years to include, use single year for one year of data
#' @param weight numeric for outline width of station points on the map
#'
#' @return A \code{\link[leaflet]{leaflet}} object
#' @export
#'
#' @concept show
#'
#' @details The map shows sediment contaminant concentrations for the selected parameter relative to Threshold Effects Levels (TEL) and Potential Effects Levels (PEL), if available.  Green points show concentrations below the TEL, yellow points show concentrations between the TEL and PEL, and red points show concentrations above the PEL. The applicable TEL and PEL values for the parameter are indicated in the legend.  A map can be created only for parameters with TEL and PEL thresholds.  An error will be returned if none are available for the selected parameter.
#'
#' @examples
#' show_sedimentmap(sedimentdata, param = 'Arsenic')
show_sedimentmap <- function(sedimentdata, param, yrrng = c(1993, 2021), weight = 1.5){

  # make yrrng two if only one year provided
  if(length(yrrng) == 1)
    yrrng <- rep(yrrng, 2)

  # yrrng must be in ascending order
  if(yrrng[1] > yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1993, 2017)')

  # yrrng not in sedimentdata
  if(any(!yrrng %in% sedimentdata$yr))
    stop(paste('Check yrrng is within', paste(range(sedimentdata$yr, na.rm = TRUE), collapse = '-')))

  # check if param is in data
  params <- sedimentdata$Parameter %>%
    unique %>%
    sort
  chk <- !param %in% params
  if(chk)
    stop(param, ' not found in Parameter column')

  # check if pel/tel exit
  telpel <- sedimentdata %>%
    dplyr::select(Parameter, TEL, PEL, Units) %>%
    unique %>%
    na.omit()

  telpelparams <- telpel %>%
    pull(Parameter) %>%
    unique() %>%
    sort()

  telpel <- telpel %>%
    filter(Parameter %in% !!param)
  chk <- nrow(telpel) == 0
  if(chk)
    stop('No TEL/PEL data for ', param, ', must be one of ', paste(telpelparams, collapse = ', '))

  # for legend
  tel <- paste(telpel$TEL, telpel$Units)
  pel <- paste(telpel$PEL, telpel$Units)
  levs <- c(paste0('< TEL (', tel, ')'), 'TEL - PEL', paste0('> PEL (', pel, ')'))
  pal_exp <- leaflet::colorFactor(
    palette = c('#2DC938', '#E9C318', '#CC3231'),
    levels = levs
  )

  # subset data
  tomap <- sedimentdata %>%
    dplyr::filter(Parameter %in% !!param) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(FundingProject %in% 'TBEP') %>%
    dplyr::filter(Replicate == 'no') %>%
    sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326) %>%
    dplyr::mutate(
      score = dplyr::case_when(
        BetweenTELPEL == 'No' & ExceedsPEL == 'No' ~ levs[1],
        BetweenTELPEL == 'Yes' ~ levs[2],
        ExceedsPEL == 'Yes' ~ levs[3]
      ),
      score = factor(score, levels = levs)
    ) %>%
    dplyr::select(yr, AreaAbbr, StationNumber, SedResultsType, Parameter, ValueAdjusted, Units, Qualifier, score)

  # bounding box
  bbx <- sf::st_bbox(tomap) %>%
    as.numeric()

  # create map
  out <- mapview::mapView(map.types = mapview::mapviewGetOption("basemaps")) %>%
    .@map %>%
    leaflet::addLegend(data = tomap, "topright", pal = pal_exp, values = ~score,
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
      fillColor = ~pal_exp(score),
      label = ~paste0("StationNumber: ", StationNumber, ", Year: ", yr, ', Value: ', paste(ValueAdjusted, Units))
    ) %>%
    leaflet::fitBounds(lng1 = bbx[1], lng2 = bbx[3], lat1 = bbx[2], lat2 = bbx[4])

  return(out)

}
