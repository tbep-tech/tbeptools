#' All Fecal Indicator Bacteria (FIB) data as of 20250321
#'
#' All Fecal Indicator Bacteria (FIB) data as of 20250321
#'
#' @format A data frame with 29323 rows and 18 variables:
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
#' @details
#' This dataset includes FIB data from the Environmental Protection Commission where station class is marine (3M, 2) and Enterococcus data is present or the station class is freshwater (3F, 1) and E. coli data is present. The data is formatted from the raw data loaded from \code{\link{read_importfib}}.
#'
#' @examples
#' \dontrun{
#' xlsx <- tempfile(fileext = '.xlsx')
#' fibdata <- read_importfib(xlsx, download_latest = TRUE)
#'
#' nrow(fibdata)
#' ncol(fibdata)
#'
#' save(fibdata, file = 'data/fibdata.RData')
#'
#' file.remove(xlsx)
#' }
"fibdata"
