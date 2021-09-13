#' Seagrass management areas for Tampa Bay
#'
#' Seagrass management areas for Tampa Bay
#'
#' @format A simple features \code{\link[sf]{sf}} object (MULTIPOLYGON) with 30 features and 1 field, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
#' \describe{
#'   \item{areas}{int}
#' }
#'
#' @details These polygons are seagrass management areas for Tampa Bay that provide a finer division of areas within major segments (\code{\link{tbseg}}) having relevance for locations of seagrass beds.
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' library(sf)
#' library(tidyverse)
#' library(tools)
#'
#' # NAD83(HARN) / Florida West (ftUS)
#' # same as sgseg
#' prj <- 2882
#'
#' # create sf object of boundaries
#' sgmanagement <- st_read(
#'   dsn = '~/Desktop/TBEP/GISboundaries/Seagrass_Management_Areas/TBEP_SG_MA_FINAL_Projectfix.shp',
#'   drivers = 'ESRI Shapefile'
#'   ) %>%
#'   select(areas = TBEP_SG_MA) %>%
#'   st_zm() %>%
#'   st_transform(prj)
#'
#' # save
#' save(sgmanagement, file = 'data/sgmanagement.RData', compress = 'xz')
#'
#' }
"sgmanagement"
