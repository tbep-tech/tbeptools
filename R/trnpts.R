#' Seagrass transect starting locations
#'
#' Seagrass transect starting locations
#'
#' @format A \code{sf} POINT object
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' library(sf)
#' library(dplyr)
#' library(tbeptools)
#'
#' trnpts <- st_read('T:/05_GIS/SEAGRASS_TRANSECTS/TransectBasics2019.shp') %>%
#'    st_transform(crs = 4326) %>%
#'    dplyr::rename(MonAgency = 'MON_AGENCY') %>%
#'    dplyr::filter(!as.character(TRAN_ID) %in% c('S8T1', 'S8T2', 'S8T3', 'S3T2')) %>%
#'    sf::st_intersection(sf::st_make_valid(tbsegshed)) %>%
#'    dplyr::select(-long_name) %>%
#'    dplyr::mutate_if(is.factor, as.character)
#'
#' save(trnpts, file = 'data/trnpts.RData', compress = 'xz')
#' }
"trnpts"
