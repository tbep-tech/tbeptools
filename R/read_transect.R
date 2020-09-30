#' Import JSON seagrass transect data from Water Atlas
#'
#' @param training logical if training data are imported or the complete database
#'
#' @return data frame
#' @export
#'
#' @importFrom magrittr %>%
#'
#' @details The function imports a JSON file from the USF Water Atlas.  If \code{training = TRUE}, a dataset from the TBEP training survey is imported from \url{http://dev.seagrass.wateratlas.usf.edu/api/assessments/training}.  If \code{training = FALSE}, the entire transect survey database is imported from \url{http://dev.seagrass.wateratlas.usf.edu/api/assessments/all__use-with-care}.
#'
#' Abundance is reported as a numeric value from 0 -5 for Braun-Blanquet coverage estimates, blade length is in cm, and short shoot density is number of shoots per square meter.  The short density is corrected for quadrat size included in the raw data.
#'
#' @examples
#' \dontrun{
#' # get training data
#' transect <- read_transect(training = TRUE)
#'
#' # import all transect data
#' transect <- read_transect()
#' }
read_transect <- function(training = FALSE){

  url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/all__use-with-care'
  if(training)
    url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/training'

  dat <- jsonlite::fromJSON(url)

  # format
  out <- read_formtransect(dat, training = training)

  return(out)

}
