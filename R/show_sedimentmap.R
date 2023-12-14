#' Make a map for sediment contaminants at stations in Tampa Bay
#'
#' Make a map for sediment contaminants at stations in Tampa Bay
#'
#' @param sedimentdata input sediment \code{data.frame} as returned by \code{\link{read_importsediment}}
#' @param param chr string for which parameter to plot
#' @param yrrng numeric vector indicating min, max years to include, use single year for one year of data
#' @param funding_proj chr string for the funding project, one to many of "TBEP" (default), "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal Streams"
#' @param weight numeric for outline width of station points on the map
#'
#' @return A \code{\link[leaflet]{leaflet}} object
#' @export
#'
#' @concept show
#'
#' @details The map shows sediment contaminant concentrations for the selected parameter relative to Threshold Effects Levels (TEL) and Potential Effects Levels (PEL), if available.  Green points show concentrations below the TEL, yellow points show concentrations between the TEL and PEL, and red points show concentrations above the PEL. The applicable TEL and PEL values for the parameter are indicated in the legend.  If TEL and PEL thresholds are not available, a map of the sediment concentrations is shown and a warning is returned to the console.
#'
#' @examples
#' show_sedimentmap(sedimentdata, param = 'Arsenic')
show_sedimentmap <- function(sedimentdata, param, yrrng = c(1993, 2022), funding_proj = 'TBEP', weight = 1.5){

  # add totals
  sedimentdata <- anlz_sedimentaddtot(sedimentdata, yrrng = yrrng, funding_proj = funding_proj, param = param, pelave = FALSE)

  # check if pel/tel exists
  telpel <- sedimentdata %>%
    dplyr::select(Parameter, TEL, PEL, Units) %>%
    unique %>%
    na.omit()
  chkpeltel <- nrow(telpel) == 0
  if(chkpeltel)
    warning('No TEL/PEL data for ', param, ', map shows concentrations only')

  # prep data
  tomap <- sedimentdata %>%
    sf::st_as_sf(coords = c('Longitude', 'Latitude'), crs = 4326) %>%
    dplyr::select(yr, AreaAbbr, StationNumber, SedResultsType, Parameter, ValueAdjusted, Units,
                  Qualifier, BetweenTELPEL, ExceedsPEL)

  # base map
  bsmap <- util_map(tomap)

  # peltel map
  if(!chkpeltel){

    # for legend
    tel <- paste(telpel$TEL, telpel$Units)
    pel <- paste(telpel$PEL, telpel$Units)
    levs <- c(paste0('< TEL (', tel, ')'), 'TEL - PEL', paste0('> PEL (', pel, ')'))
    pal_exp <- leaflet::colorFactor(
      palette = c('#2DC938', '#E9C318', '#CC3231'),
      levels = levs
    )

    # subset data
    tomap <- tomap %>%
      dplyr::mutate(
        score = ifelse(BetweenTELPEL == 'No' & ExceedsPEL == 'No', levs[1],
          ifelse(BetweenTELPEL == 'Yes', levs[2],
            ifelse(ExceedsPEL == 'Yes', levs[3],
              NA_character_
            )
          )
        ),
        score = factor(score, levels = levs)
      ) %>%
      dplyr::select(-BetweenTELPEL, -ExceedsPEL)

    # create map
    out <- bsmap %>%
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
      )

  }

  # concentration only map
  if(chkpeltel){

    dmn <- tomap %>%
      pull(ValueAdjusted) %>%
      range(., na.rm = T)

    # for legend
    pal_exp <- leaflet::colorNumeric(
      palette = 'Reds',
      domain = dmn,
      na.color = 'grey'
    )

    uni <- unique(tomap$Units)

    # create map
    out <- bsmap %>%
      leaflet::addLegend(data = tomap, "topright", pal = pal_exp, values = ~ValueAdjusted,
                         title = paste0("Concentration (", uni, ")"),
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
        fillColor = ~pal_exp(ValueAdjusted),
        label = ~paste0("StationNumber: ", StationNumber, ", Year: ", yr, ', Value: ', paste(ValueAdjusted, Units))
      )

  }

  return(out)

}
