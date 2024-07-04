#' Download Enterococcus data from the Water Quality Portal
#'
#' @param args a list with the following fields:
#'
#' @return a data frame
#' @importFrom dplyr %>%
#' @export
#'
#' @examples
#' \dontrun{
#' # set up list of args
#' stations <- c('21FLHILL_WQX-101',
#' '21FLHILL_WQX-102',
#' '21FLHILL_WQX-103')
#' entero_names <- c('Enterococci',
#'                   'Enterococcus')
#' startDate <- as.Date('2023-01-01')
#' endDate <- as.Date('2023-12-31')
#'
#' args <- list(
#'   siteid = stations,
#'   characteristicName = entero_names,
#'   startDateLo = format(startDate, '%m-%d-%Y'),
#'   startDateHi = format(endDate, '%m-%d-%Y')
#' )
#'
#' # download and read the data
#' entero_in <- read_importentero(args = args)
#' head(entero_in)
#'
#' }

read_importentero <- function(args){
  # args should be a list of sites, characteristic names, and start/end dates
  # should probably figure out how to make that flexible, e.g. no end date

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
    dplyr::select(station = .data$MonitoringLocationIdentifier,
                  Latitude = .data$ActivityLocation.LatitudeMeasure,
                  Longitude = .data$ActivityLocation.LongitudeMeasure,
                  ecocci = .data$ResultMeasureValue, # - the result (has characters in here too - 'Not Reported')
                  ecocci_units = .data$ResultMeasure.MeasureUnitCode,
                  qualifier = .data$MeasureQualifierCode,
                  date = .data$ActivityStartDate,
                  time = .data$ActivityStartTime.Time, # local time
                  time_zone = .data$ActivityStartTime.TimeZoneCode,
                  MDL = .data$DetectionQuantitationLimitMeasure.MeasureValue,
                  LabComments = .data$ResultLaboratoryCommentText) %>%
    dplyr::filter(ecocci != 'Not Reported') %>%
    dplyr::mutate(ecocci = as.numeric(.data$ecocci),
                  ecocci_censored = dplyr::case_when(.data$ecocci <= .data$MDL ~ TRUE,
                                                     .default = FALSE),
                  date = as.Date(.data$date),
                  yr = lubridate::year(.data$date),
                  mo = lubridate::month(.data$date)) %>%
    dplyr::relocate(.data$date, .data$station, .data$ecocci) %>%
    dplyr::relocate(.data$ecocci_censored, .after = ecocci) %>%
    dplyr::arrange(.data$station, .data$date)

  return(dat2)
}
