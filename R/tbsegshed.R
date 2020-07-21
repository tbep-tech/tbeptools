#' Spatial data object of Tampa Bay segments plus watersheds
#'
#' Spatial data object of Tampa Bay segments plus waterhseds
#'
#' @format A simple features \code{\link[sf]{sf}} object (POLYGON) with 7 features and 2 fields, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
#' \describe{
#'   \item{long_name}{chr}
#'   \item{bay_segment}{chr}
#' }
#' @family utilities
#'
#' @examples
#' library(sf)
#' plot(st_geometry(tbsegshed))
"tbsegshed"
