#' Seagrass segment reporting boundaries for southwest Florida
#'
#' Seagrass segment reporting boundaries for southwest Florida
#'
#' @format A simple features \code{\link[sf]{sf}} object (POLYGON) with 22 features and 1 field, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
#' \describe{
#'   \item{segment}{chr}
#' }
#'
#' @details These polygons are used by Southwest Florida Water Management District for summarizing seagrass coverage estimates by major coastal and estuarine boundaries.
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' library(sf)
#' library(tidyverse)
#' library(tools)
#'
#' # create sf object of boundaries
#' # make sure projection does not change
#' sgseg <- st_read(
#'   dsn = '~/Desktop/Seagrass_Segment_Boundaries/Seagrass_Segment_Boundaries.shp',
#'   drivers = 'ESRI Shapefile'
#'   ) %>%
#'   select(segment = SEAGRASSSE) %>%
#'   mutate(
#'      segment = tolower(segment),
#'      segment = case_when(
#'         segment == 'terra ciea bay' ~ 'Terra Ceia Bay',
#'         T ~ segment
#'      ),
#'      segment = toTitleCase(segment)
#'   )
#'
#' # save
#' save(sgseg, file = 'data/sgseg.RData', compress = 'xz')
#'
#' }
"sgseg"
