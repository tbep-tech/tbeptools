#' Benthic data for the Tampa Bay Benthic Index current as of 20241212
#'
#' Benthic data for the Tampa Bay Benthic Index current as of 20241212
#'
#' @format A nested \code{\link[tibble]{tibble}} with 3 rows and 2 variables:
#' \describe{
#'   \item{name}{chr identifying the dataset as stations, fieldsamples, or taxacounts}
#'   \item{value}{list of dataframes for each dataset}
#'   }
#'
#' @details Index the corresponding list element in the \code{value} column to view each dataset. For example, the stations data in the first row can be viewed as \code{benthicdata$value[[1]]}.
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
