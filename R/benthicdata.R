#' Benthic data for the Tampa Bay Benthic Index current as of 09132020
#'
#' Benthic data for the Tampa Bay Benthic Index current as of 09132020
#'
#' @format A data frame with 4516 rows and 12 variables:
#' \describe{
#'   \item{StationID}{int}
#'   \item{ProgramID}{int}
#'   \item{ProgramName}{chr}
#'   \item{Latitude}{num}
#'   \item{Longitude}{num}
#'   \item{date}{Date}
#'   \item{yr}{num}
#'   \item{TotalAbundance}{num}
#'   \item{SpecesRichness}{num}
#'   \item{TBBI}{num}
#'   \item{TBBICat}{chr}
#'   \item{Salinity}{num}
#'   }
#'
#' @family utilities
#'
#' @examples
#' \dontrun{
#' # location to download data
#' path <- 'C:/Users/mbeck/Desktop/benthic.zip'
#'
#' # load and assign to object
#' benthicdata <- read_importbenthic(path, download_latest = TRUE, remove = TRUE)
#'
#' save(benthicdata, file = 'data/benthicdata.RData', compress = 'xz')
#'
#' }
"benthicdata"
