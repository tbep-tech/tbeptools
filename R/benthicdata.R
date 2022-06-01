#' Benthic data for the Tampa Bay Benthic Index current as of 06012022
#'
#' Benthic data for the Tampa Bay Benthic Index current as of 06012022
#'
#' @format A nested \code{\link[tibble]{tibble}} with 3 rows and 2 variables:
#' \describe{
#'   \item{name}{chr}
#'   \item{value}{list}
#'   }
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' # location to download data
#' path <- '~/Desktop/benthic.zip'
#'
#' # load and assign to object
#' benthicdata <- read_importbenthic(path, download_latest = TRUE, remove = TRUE)
#'
#' save(benthicdata, file = 'data/benthicdata.RData', compress = 'xz')
#'
#' }
"benthicdata"
