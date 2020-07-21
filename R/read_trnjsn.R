#' Import JSON transect data from Water Atlas
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
#' @examples
#' \dontrun{
#' # get training data
#' trnjsn <- read_trnjsn(training = TRUE)
#'
#' # import all transect data
#' trnjsn <- read_trnjsn()
#' }
read_trnjsn <- function(training = FALSE){

  url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/all__use-with-care'
  if(training)
    url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/training'

  dat <- jsonlite::fromJSON(url)

  return(dat)

}
