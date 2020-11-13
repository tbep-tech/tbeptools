#' Seagrass transect locations
#'
#' Seagrass transect locations
#'
#' @format A \code{sf} LINESTRING object
#' @examples
#' \dontrun{
#' library(sf)
#' libryar(dplyr)
#'
#' trnlns <- st_read('T:/05_GIS/SEAGRASS_TRANSECTS/transect_routes.shp') %>%
#'    st_transform(crs = 4326) %>%
#'    dplyr::filter(!as.character(Site) %in% c('S8T1', 'S8T2', 'S8T3', 'S3T2'))
#'
#' save(trnlns, file = 'data/trnlns.RData', compress = 'xz')
#' }
"trnlns"
