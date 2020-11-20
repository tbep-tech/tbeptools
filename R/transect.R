#' Seagrass transect data for Tampa Bay current as of 11202020
#'
#' Seagrass transect data for Tampa Bay current as of 11202020
#'
#' @format A data frame with 132354 rows and 11 variables:
#' \describe{
#'   \item{Crew}{chr}
#'   \item{MonitoringAgency}{chr}
#'   \item{Date}{Date}
#'   \item{Transect}{chr}
#'   \item{Site}{chr}
#'   \item{Depth}{int}
#'   \item{Savspecies}{chr}
#'   \item{SeagrassEdge}{num}
#'   \item{var}{chr}
#'   \item{aveval}{num}
#'   \item{sdval}{num}
#'   }
#'
#' @family utilities
#'
#' @examples
#' \dontrun{
#'
#' transect <- read_transect()
#'
#' save(transect, file = 'data/transect.RData', compress = 'xz')
#'
#' }
"transect"
