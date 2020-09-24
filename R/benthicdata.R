#' Benthic data for the Tampa Bay Benthic Index current as of 09142020
#'
#' Benthic data for the Tampa Bay Benthic Index current as of 09142020
#'
#' @format A nested \code{\link[tibble]{tibble}} with 3 rows and 2 variables:
#' \describe{
#'   \item{name}{chr}
#'   \item{value}{list}
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