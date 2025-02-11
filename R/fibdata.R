#' All Fecal Indicator Bacteria (FIB) data as of 20250211
#'
#' All Fecal Indicator Bacteria (FIB) data as of 20250211
#'
#' @format A data frame with 77664 rows and 18 variables:
#' \describe{
#'   \item{area}{chr}
#'   \item{epchc_station}{num}
#'   \item{class}{chr}
#'   \item{SampleTime}{POSIXct}
#'   \item{yr}{num}
#'   \item{mo}{num}
#'   \item{Latitude}{num}
#'   \item{Longitude}{num}
#'   \item{Total_Depth_m}{num}
#'   \item{Sample_Depth_m}{num}
#'   \item{ecoli}{num}
#'   \item{ecoli_q}{chr}
#'   \item{entero}{num}
#'   \item{entero_q}{chr}
#'   \item{fcolif}{num}
#'   \item{fcolif_q}{chr}
#'   \item{totcol}{num}
#'   \item{totcol_q}{chr}
#'   }
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' xlsx <- tempfile(fileext = '.xlsx')
#' fibdata <- read_importfib(xlsx, download_latest = TRUE)
#'
#' nrow(fibdata)
#' ncol(fibdata)
#'
#' save(fibdata, file = 'data/fibdata.RData', compress = 'xz')
#'
#' file.remove(xlsx)
#' }
"fibdata"
