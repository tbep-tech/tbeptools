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
#'    dplyr::filter(!as.character(Site) %in% c('S8T1', 'S8T2', 'S8T3', 'S3T2')) %>%
#'    dplyr::mutate_if(is.factor, as.character) %>%
#'    dplyr::filter(Site %in% trnpts$TRAN_ID)
#'
#' # add bearing, positive counter-clockwise from east
#' bearing <- lapply(trnlns$geometry, function(x) geosphere::bearing(x[, c(1:2)])[[1]]) %>%
#'   unlist()
#'
#' trnlns$bearing <- bearing
#'
#' save(trnlns, file = 'data/trnlns.RData', compress = 'xz')
#' #' }
"trnlns"
