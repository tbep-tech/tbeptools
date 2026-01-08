#' Enterococcus data from 53 key Enterococcus stations since 1995
#'
#' @format A data frame with 6622 rows and 16 columns:
#' \describe{
#'  \item{\code{date}}{date, sample date}
#'  \item{\code{yr}}{numeric, year of sample date}
#'  \item{\code{mo}}{numeric, month of sample date}
#'  \item{\code{time}}{character, sample time}
#'  \item{\code{time_zone}}{character, sample time zone}
#'  \item{\code{long_name}}{character, long name of bay segment subwatershed}
#'  \item{\code{bay_segment}}{character, short name of bay segment subwatershed}
#'  \item{\code{station}}{character, sample station}
#'  \item{\code{entero}}{numeric, Enterococcus concentration}
#'  \item{\code{entero_censored}}{logical, whether \code{entero} value was below the laboratory \code{MDL}, minimum detection limit}
#'  \item{\code{MDL}}{numeric, minimum detection limit at the time of processing}
#'  \item{\code{entero_units}}{character, units of measurement for \code{entero}}
#'  \item{\code{qualifier}}{qualifier codes associated with sample}
#'  \item{\code{LabComments}}{lab comments on sample}
#'  \item{\code{Latitude}}{numeric, latitude in decimal degrees}
#'  \item{\code{Longitude}}{numeric, longitude in decimal degrees}
#'  }
#' @details
#' A dataset containing Enterococcus from 53 stations in the TBEP watershed since 1995.
#' @source Water Quality Portal, \url{https://waterqualitydata.us}
#'
#' @examples
#' \dontrun{
#' enterodata <- read_importentero(startDate = '1995-01-01', endDate = '2025-12-31')
#'
#' save(enterodata, file = 'data/enterodata.RData')
#' }
"enterodata"
