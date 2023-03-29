#' Spatial data object of tidal creeks in Impaired Waters Rule, Run 64
#'
#' Spatial data object of tidal creeks in Impaired Waters Rule, Run 64
#'
#' @format A simple features \code{\link[sf]{sf}} object (MULTILINESTRING) with 615 features and  fields, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
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
#' @details File was created using workflow at <https://tbep-tech.github.io/tidalcreek-stats/Creek_select_tbeptools>, example below is old and for Run 61.
#'
#' @examples
#' \dontrun{
#' library(sf)
#' library(dplyr)
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
