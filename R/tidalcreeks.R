#' Spatial data object of tidal creeks
#'
#' Spatial data object of tidal creeks
#'
#' @format A simple features \code{\link[sf]{sf}} object (MULTILINESTRING) with 581 feaures and 5 fields, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
#' \describe{
#'   \item{id}{num}
#'   \item{wbid}{chr}
#'   \item{JEI}{chr}
#'   \item{class}{chr}
#'   \item{Creek_Length_m}{num}
#' }
#' @family utilities
#' @examples
#' \dontrun{
#'
#' library(sf)
#' library(tidyverse)
#' library(haven)
#'
#' prj <- 4326
#'
#' # creek lengths
#' crkraw <- read_sas('../../02_DOCUMENTS/tidal_creeks/creek_pop.sas7bdat') %>%
#'   select(wbid = WBID, JEI, class = CLASS, Creek_Length_m) %>%
#'   unique %>%
#'   na.omit()
#'
#' # create sf object of creek population, join with creek length data
#' tidalcreeks <- st_read(dsn = '../../02_DOCUMENTS/tidal_creeks/Creek_ReportCard_revised.shp', drivers = 'ESRI Shapefile') %>%
#'   st_transform(crs = prj) %>%
#'   select(wbid = WBID, JEI = CreekID, class) %>%
#'   mutate_if(is.factor, as.character) %>%
#'   mutate(
#'     id = 1:n()
#'   ) %>%
#'   left_join(crkraw, by = c('wbid', 'JEI', 'class')) %>%
#'   select(id, wbid, JEI, class, Creek_Length_m)
#'
#' # save
#' save(tidalcreeks, file = here::here('data', 'tidalcreeks.RData'), compress = 'xz')
#'
#' }
"tidalcreeks"
