#' Phytoplankton data current as of 03202024
#'
#' Phytoplankton data current as of 03202024
#'
#' @format A nested \code{\link[tibble]{tibble}} with 21143 rows and 8 variables:
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
#' path <- tempfile(fileext = '.xlsx')
#'
#' # load and assign to object
#' phytodata <- read_importphyto(path, download_latest = TRUE)
#'
#' nrow(phytodata)
#' ncol(phytodata)
#'
#' save(phytodata, file = 'data/phytodata.RData', compress = 'xz')
#'
#' file.remove(path)
#' }
"phytodata"
