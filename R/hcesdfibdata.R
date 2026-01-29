#' Hillsborough County Environmental Services Division (ESD) FIB data as of 20260108
#'
#' Hillsborough County Environmental Services Division (ESD) FIB data as of 20260108
#'
#' @format A data frame with 1264 rows and 13 variables:
#' \describe{
#'   \item{hcesd_station}{chr, Station name}
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
#'   \item{area}{chr, Location name}
#'   }
#'
#' @concept data
#'
#' @details
#' This dataset includes FIB data from Hillsborough County Environmental Services Division (21FLHESD_WQX) where station class is marine (estuary) and Enterococcus data is present or the station class is freshwater (stream/river, reservoir) and E. coli data is present. The data is formatted from the raw data loaded from \code{\link{read_importwqp}}.
#'
#' @examples
#' \dontrun{
#' hcesdfibdata <- read_importwqp('21FLHESD_WQX', type = 'fib')
#'
#' nrow(hcesdfibdata)
#' ncol(hcesdfibdata)
#'
#' save(hcesdfibdata, file = 'data/hcesdfibdata.RData')
#' }
"hcesdfibdata"
