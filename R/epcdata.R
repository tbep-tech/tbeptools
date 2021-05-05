#' All bay data as of 02092021
#'
#' All bay data as of 02092021
#'
#' @format A data frame with 26209 rows and 22 variables:
#' \describe{
#'   \item{bay_segment}{chr}
#'   \item{epchc_station}{num}
#'   \item{SampleTime}{POSIXct}
#'   \item{yr}{num}
#'   \item{mo}{num}
#'   \item{Latitude}{num}
#'   \item{Longitude}{num}
#'   \item{Total_Depth_m}{num}
#'   \item{Sample_Depth_m}{num}
#'   \item{tn}{num}
#'   \item{tn_q}{chr}
#'   \item{sd_m}{num}
#'   \item{sd_raw_m}{num}
#'   \item{sd_q}{chr}
#'   \item{chla}{num}
#'   \item{chla_q}{chr}
#'   \item{Sal_Top_ppth}{num}
#'   \item{Sal_Mid_ppth}{num}
#'   \item{Sal_Bottom_ppth}{num}
#'   \item{Temp_Water_Top_degC}{num}
#'   \item{Temp_Water_Mid_degC}{num}
#'   \item{Temp_Water_Bottom_degC}{num}
#'   }
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' xlsx <- '~/Desktop/epcdata.xls'
#' epcdata <- read_importwq(xlsx, download_latest = TRUE)
#'
#' nrow(epcdata)
#' ncol(epcdata)
#'
#' save(epcdata, file = 'data/epcdata.RData', compress = 'xz')
#' }
"epcdata"
