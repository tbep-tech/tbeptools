#' Spatial data object of FIM stations including Tampa Bay segments
#'
#' Spatial data object of FIM stations including Tampa Bay segments
#'
#' @format A simple features \code{\link[sf]{sf}} object (POINT) with 7771 features and 2 fields, +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs
#' \describe{
#'   \item{Reference}{num}
#'   \item{bay_segment}{chr}
#' }
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' # file path
#' csv <- '~/Desktop/fimraw.csv'
#'
#' # load and assign to object
#' fimstations <- read_importfim(csv, download_latest = FALSE, locs = TRUE)
#' save(fimstations, file = 'data/fimstations.RData', compress = 'xz')
#' }
"fimstations"
