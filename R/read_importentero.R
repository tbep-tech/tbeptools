#' Download Enterococcus data from the Water Quality Portal
#'
#' @param stas character, a vector of stations.  If \code{NULL}, defaults to all stations in \code{\link{catchprecip}}.
#' @param startDate character, starting date of observations as YYYY-MM-DD
#' @param endDate character, ending date of observations as YYYY-MM-DD
#'
#' @details Retrieves Enterococcus sample data from selected stations and date range from the Water Quality Portal, \url{https://www.waterqualitydata.us}
#'
#' @return a data frame containing one row for each sample. Columns returned are:
#' \describe{
#'  \item{\code{date}}{date, sample date}
#'  \item{\code{station}}{character, sample station}
#'  \item{\code{ecocci}}{numeric, Enterococcus concentration}
#'  \item{\code{ecocci_censored}}{logical, whether \code{ecocci} value was below the laboratory \code{MDL}, minimum detection limit}
#'  \item{\code{ecocci_units}}{character, units of measurement for \code{ecocci}}
#'  \item{\code{qualifier}}{qualifier codes associated with sample}
#'  \item{\code{LabComments}}{lab comments on sample}
#'  \item{\code{Latitude}}{numeric, latitude in decimal degrees}
#'  \item{\code{Longitude}}{numeric, longitude in decimal degrees}
#'  \item{\code{time}}{character, sample time}
#'  \item{\code{time_zone}}{character, sample time zone}
#'  \item{\code{MDL}}{numeric, minimum detection limit for the lab and time the sample was analyzed}
#'  \item{\code{yr}}{numeric, year of sample date}
#'  \item{\code{mo}}{numeric, month of sample date}
#'  }
#'
#' @importFrom dplyr %>%
#' @export
#'
#' @examples
#' \dontrun{
#' # stations to download
#' stations <- c('21FLHILL_WQX-101',
#' '21FLHILL_WQX-102',
#' '21FLHILL_WQX-103')
#'
#' # download and read the data
#' entero_in <- read_importentero(stas = stations, startDate = '2023-01-01', endDate = '2023-02-01')
#'
#' head(entero_in)
#'
#' }
read_importentero <- function(stas = NULL, startDate, endDate){

  # default to all stations if not specified
  if(is.null(stas))
    stations <- unique(catchprecip$station)

  entero_names <- c('Enterococci',
                    'Enterococcus')
  startDate <- as.Date(startDate)
  endDate <- as.Date(endDate)

  args <- list(
    siteid = stations,
    characteristicName = entero_names,
    startDateLo = format(startDate, '%m-%d-%Y'),
    startDateHi = format(endDate, '%m-%d-%Y')
  )


  # generate the parts
  # a weakness here is building the '&' into everything but siteid -
  # this basically means everything is required in the proper order
  url_base <- 'https://www.waterqualitydata.us/data/Result/search?'
  url_siteid <- paste0('siteid=', paste0(args$siteid, collapse = '%3B'))
  url_characteristicName <- paste0('&characteristicName=', paste0(args$characteristicName, collapse = '%3B'))
  url_startDateLo <- paste0('&startDateLo=', args$startDateLo)
  url_startDateHi <- paste0('&startDateHi=', args$startDateHi)
  url_end <- '&mimeType=csv&dataProfile=biological'

  url_full <- paste0(url_base,
                     url_siteid,
                     url_characteristicName,
                     url_startDateLo,
                     url_startDateHi,
                     url_end)

  # replace spaces with %20
  url_full <- gsub('\\s' , '%20', url_full)

  # download and read in the file
  tmp1 <- tempfile()
  download.file(url = url_full, destfile = tmp1, method = 'curl')
  dat <- read.csv(tmp1)
  unlink(tmp1)


  # select columns
  dat2 <- dat %>%
    dplyr::select(station = MonitoringLocationIdentifier,
                  Latitude = ActivityLocation.LatitudeMeasure,
                  Longitude = ActivityLocation.LongitudeMeasure,
                  ecocci = ResultMeasureValue, # - the result (has characters in here too - 'Not Reported')
                  ecocci_units = ResultMeasure.MeasureUnitCode,
                  qualifier = MeasureQualifierCode,
                  date = ActivityStartDate,
                  time = ActivityStartTime.Time, # local time
                  time_zone = ActivityStartTime.TimeZoneCode,
                  MDL = DetectionQuantitationLimitMeasure.MeasureValue,
                  LabComments = ResultLaboratoryCommentText) %>%
    dplyr::filter(ecocci != 'Not Reported') %>%
    dplyr::mutate(ecocci = as.numeric(ecocci),
                  ecocci_censored = dplyr::case_when(ecocci <= MDL ~ TRUE,
                                                     .default = FALSE),
                  date = as.Date(date),
                  yr = lubridate::year(date),
                  mo = lubridate::month(date)) %>%
    dplyr::relocate(date, station, ecocci, ecocci_censored, ecocci_units, qualifier, LabComments) %>%
    dplyr::arrange(station, date)

  return(dat2)
}
