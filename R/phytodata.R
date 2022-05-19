#' Phytoplankton data current as of 05192022
#'
#' Phytoplankton data current as of 05192022
#'
#' @format A nested \code{\link[tibble]{tibble}} with 23848 rows and 8 variables:
#' \describe{
#'   \item{epchc_station}{chr}
#'   \item{Date}{Date}
#'   \item{name}{chr}
#'   \item{units}{chr}
#'   \item{count}{num}
#'   \item{yrqrt}{Date}
#'   \item{yr}{num}
#'   \item{mo}{Ord.factor}
#'   }
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' # location to download data
#' path <- '~/Desktop/phyto_data.xlsx'
#'
#' # load and assign to object
#' phytodata <- read_importphyto(path, download_latest = TRUE)
#'
#' save(phytodata, file = 'data/phytodata.RData', compress = 'xz')
#'
#' }
"phytodata"
