#' Daily precip by catchment for selected Enterococcus stations
#'
#' @format A data frame with three columns:
#' \describe{
#'  \item{station}{a character string of the Water Quality Portal station name}
#'  \item{date}{a date}
#'  \item{rain}{a number; inches of rain for that date, averaged across all pixels in the station's catchment}
#' }
#'
#' @details
#' Daily precipitation data for multiple years, provided by the Southwest Florida Water Management District, were downloaded at the pixel level and averaged to the catchment level for key Enterococcus sampling stations. Created using \code{\link{read_importrainmany}}.
#'
#' @source Southwest Florida Management District radar-estimated daily rainfall data, \url{ftp://ftp.swfwmd.state.fl.us/pub/radar_rainfall/Daily_Data/}
#'
#' @examples
#' \dontrun{
#' catchprecip <- read_importrainmany(1995:2025, quiet = F)
#'
#' save(catchprecip, file = 'data/catchprecip.RData')
#' }
"catchprecip"
