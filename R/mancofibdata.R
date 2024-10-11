#' Manatee County FIB data as of 20241011
#'
#' Manatee County FIB data as of 20241011
#'
#' @format A data frame with 12765 rows and 13 variables:
#' \describe{
#'   \item{manco_station}{chr, Station name}
#'   \item{SampleTime}{POSIXct, Date/time of sampling}
#'   \item{class}{chr, Waterbody class (\code{Fresh}, \code{Estuary})}
#'   \item{yr}{num, Year of sampling}
#'   \item{mo}{num, Month of sampling}
#'   \item{Latitude}{num, Latitude, WGS84}
#'   \item{Longitude}{num, Latitude, WGS84}
#'   \item{Sample_Depth_m}{num, Depth of sample, meters}
#'   \item{var}{chr, Variable name (\code{ecoli}, \code{entero}, \code{fcolif}, \code{totcol})}
#'   \item{val}{num, Value of variable}
#'   \item{uni}{num, Units of variable}
#'   \item{qual}{num, Qualifier code}
#'   \item{area}{chr, Location name based on USF Water Alas waterbody name}
#'   }
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' mancofibdata <- read_importwqp('21FLMANA_WQX', type = 'fib')
#'
#' nrow(mancofibdata)
#' ncol(mancofibdata)
#'
#' save(mancofibdata, file = 'data/mancofibdata.RData', compress = 'xz')
#' }
"mancofibdata"
