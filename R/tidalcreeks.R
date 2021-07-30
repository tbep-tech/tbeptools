#' Spatial data object of tidal creeks
#'
#' Spatial data object of tidal creeks
#'
#' @format A simple features \code{\link[sf]{sf}} object (MULTILINESTRING) with 609 features and 6 fields, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
#' \describe{
#'   \item{id}{num}
#'   \item{wbid}{chr}
#'   \item{JEI}{chr}
#'   \item{class}{chr}
#'   \item{name}{chr}
#'   \item{Creek_Length_m}{num}
#' }
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' library(sf)
#' library(tidyverse)
#'
#' prj <- 4326
#'
#' # create sf object of creek population, join with creek length data
#' tidalcreeks <- st_read(
#'   dsn = '../../02_DOCUMENTS/tidal_creeks/TidalCreek_ALL_Line_WBID61.shp',
#'   drivers = 'ESRI Shapefile'
#'   ) %>%
#'   st_transform(crs = prj) %>%
#'   mutate(
#'     id = 1:nrow(.)
#'   ) %>%
#'   select(id, name = Name, JEI = CreekID, wbid = WBID, class = CLASS, Creek_Length_m = Total_m)
#'
#' # save
#' save(tidalcreeks, file = 'data/tidalcreeks.RData', compress = 'xz')
#'
#' }
"tidalcreeks"
