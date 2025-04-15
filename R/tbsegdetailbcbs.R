#' Spatial data object of detailed Tampa Bay segments, Boca Ciega Bay as southern portion
#'
#' Spatial data object of detailed Tampa Bay segments, Boca Ciega Bay as southern portion
#'
#' @format A simple features \code{\link[sf]{sf}} object (POLYGON) with 7 features and 2 fields, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
#' \describe{
#'   \item{long_name}{chr}
#'   \item{bay_segment}{chr}
#' }
#'
#' @description Note that these boundaries are not used for formal analysis and are only used as visual aids in mapping. The data object differs from \code{\link{tbseg}} by including Boca Ciega Bay South, Terra Ceia Bay, and Manatee River. The boundaries are also more detailed.  This is the same data as \code{\link{tbsegdetail}} but with Boca Ciega Bay shown only as the southern portion.
#'
#' @concept data
#'
#' @examples
#' library(sf)
#' plot(st_geometry(tbsegdetailbcbs))
"tbsegdetailbcbs"
