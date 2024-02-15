#' Get organization name from organization identifier in USEPA Water Quality Portal
#'
#' @param org chr string indicating the organization identifier, see \code{\link{read_importwqp}} for valid entries
#' @param stanm logical indicating if a character string for a column name specific to the organization is returned
#'
#' @return A character string of the organization name that corresponds to the organization identifier or a column name for the station identifier specific to the organization if \code{stanm = TRUE}
#'
#' @export
#'
#' @concept util
#'
#' @examples
#' util_orgin('21FLHILL_WQX')
#' util_orgin('21FLPASC_WQX', stanm = TRUE)
util_orgin <- function(org, stanm = FALSE){

  orgids <- c('21FLCOSP_WQX', '21FLDOH_WQX', '21FLHILL_WQX', '21FLMANA_WQX', '21FLPASC_WQX', '21FLPDEM_WQX', '21FLPOLK_WQX', '21FLTPA_WQX')
  orgname <- c('City of St. Petersburg', 'Florida DOH', 'Hillsborough', 'Manatee', 'Pasco', 'Pinellas', 'Polk', 'DEP Southwest')
  stations <- c('stpet', 'fldoh', 'epchc', 'manco', 'pasco', 'pinco', 'polco', 'depsd')
  stations <- paste0(stations, '_station')
  names(stations) <- orgids
  names(orgname) <- orgids

  # check org argument
  org <- match.arg(org, orgids)

  # get organization name or station name
  out <- orgname[[org]]
  if(stanm)
    out <- stations[[org]]

  return(out)

}
