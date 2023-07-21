#' Get county name from organization identifier
#'
#' @param org chr string indicating the organization identifier
#' @param stanm logical indicating if a character string for a column name specific to the county is returned
#'
#' @details
#' Valid entries for \code{arg} include \code{"21FLHILL_WQX"} (Hillsborough County), \code{"21FLMANA_WQX"} (Manatee County), \code{"21FLPASC_WQX"} (Pasco County), \code{"21FLPDEM_WQX"} (Pinellas County), or \code{"21FLPOLK_WQX} (Polk County).  The naming convention follows the Organization ID in the Water Quality Portal.
#'
#' @return A character string of the county name that correspond to the organization identifier or a column name for the station identfier specific to the county if \code{stanm = TRUE}
#'
#' @export
#'
#' @concept util
#'
#' @examples
#' util_orgin('21FLHILL_WQX')
#' util_orgin('21FLPASC_WQX', stanm = TRUE)
util_orgin <- function(org, stanm = FALSE){

  orgids <- c('21FLHILL_WQX', '21FLMANA_WQX', '21FLPASC_WQX', '21FLPDEM_WQX', '21FLPOLK_WQX')
  counties <- c('Hillsborough', 'Manatee', 'Pasco', 'Pinellas', 'Polk')
  stations <- c('epchc', 'manco', 'pasco', 'pinco', 'polco')
  stations <- paste0(stations, '_station')
  names(stations) <- orgids
  names(counties) <- orgids

  # check org argument
  org <- match.arg(org, orgids)

  # get county or station name
  out <- counties[[org]]
  if(stanm)
    out <- stations[[org]]

  return(out)

}
