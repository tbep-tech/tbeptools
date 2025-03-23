#' Manatee County FIB data as of 20250211
#'
#' Manatee County FIB data as of 20250211
#'
#' @format A data frame with 1616 rows and 13 variables:
#' \describe{
#'   \item{manco_station}{chr, Station name}
#'   \item{SampleTime}{POSIXct, Date/time of sampling}
#'   \item{class}{chr, Waterbody class (\code{Fresh}, \code{Marine})}
#'   \item{yr}{num, Year of sampling}
#'   \item{mo}{num, Month of sampling}
#'   \item{Latitude}{num, Latitude, WGS84}
#'   \item{Longitude}{num, Latitude, WGS84}
#'   \item{Sample_Depth_m}{num, Depth of sample, meters}
#'   \item{var}{chr, Variable name (\code{ecoli}, \code{entero}}
#'   \item{val}{num, Value of variable}
#'   \item{uni}{num, Units of variable}
#'   \item{qual}{num, Qualifier code}
#'   \item{area}{chr, Location name based on USF Water Alas waterbody name}
#'   }
#'
#' @concept data
#'
#' @details
#' This dataset includes FIB data from Manatee County Department of Natural Resources where station class is marine (estuary) and Enterococcus data is present or the station class is freshwater (stream/river, reservoir) and E. coli data is present. The data is formatted from the raw data loaded from \code{\link{read_importwqp}}.
#'
#'
#' @examples
#' \dontrun{
#' mancofibdata <- read_importwqp('21FLMANA_WQX', type = 'fib')
#'
#' nrow(mancofibdata)
#' ncol(mancofibdata)
#'
#' save(mancofibdata, file = 'data/mancofibdata.RData')
#' }
"mancofibdata"
