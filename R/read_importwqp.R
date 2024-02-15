#' Import data from the Water Quality Portal
#'
#' Import data from the Water Quality Portal
#'
#' @param org chr string indicating the organization identifier, see details
#' @param type chr string indicating data type to download, one of \code{"wq"} or \code{"fib"}
#' @param trace logical indicating whether to display progress messages, default \code{FALSE}
#'
#' @return A data frame containing the imported data for the selected county
#'
#' @details This function retrieves data from the Water Quality Portal API (\url{https://www.waterqualitydata.us/}) for selected counties in or around the Tampa Bay watershed. The type of data returned are defined by the \code{type} argument as either \code{"wq"} or \code{"fib"} for water quality of Fecal Indicator Bacteria data, respectively.
#'
#' The \code{org} argument retrieves data for the specific organization. Valid entries for \code{org} include \code{"21FLCOSP_WQX"} (City of St. Petersburg), \code{"21FLDOH_WQX"} (Florida Department of Health), \code{"21FLHILL_WQX"} (Hillsborough County), \code{"21FLMANA_WQX"} (Manatee County), \code{"21FLPASC_WQX"} (Pasco County), \code{"21FLPDEM_WQX"} (Pinellas County), \code{"21FLPOLK_WQX"} (Polk County), or \code{"21FLTPA_WQX"} (Florida Department of Environmental Protection, Southwest District).  The naming convention follows the Organization ID in the Water Quality Portal.
#'
#' The function fetches results and station metadata, combines and formats them using the \code{read_formwqp} function, and returns the processed data as a data frame.  Parameters are specific to the \code{type} argument.
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @seealso \code{\link{read_formwqp}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # get Manatee County water quality data
#' mancodata <- read_importwqp(org = '21FLMANA_WQX', type = 'wq', trace = T)
#'
#' # get Pinellas County FIB data
#' pincodata <- read_importwqp(org = '21FLPDEM_WQX', type = 'fib', trace = T)
#' }
read_importwqp <- function(org, type, trace = F){

  # get type
  type <- match.arg(type, c('fib', 'wq'))

  # get org name based on org id
  orgname <- util_orgin(org)

  url <- list(
    Result = "https://www.waterqualitydata.us/data/Result/search?mimeType=csv&zip=no",
    Station = "https://www.waterqualitydata.us/data/Station/search?mimeType=csv&zip=no"
  )

  headers <- c(
    "Content-Type" = "application/json",
    "Accept" = "application/zip"
  )

  # https://www.epa.gov/waterdata/storage-and-retrieval-and-water-quality-exchange-domain-services-and-downloads
  body <- list(
    organization = org,
    providers = "STORET"
  )

  if(type == 'wq')
    body <- c(
      body,
      sampleMedia = "Water",
      characteristicType = c("Information", "Nutrient", "Biological, Algae, Phytoplankton, Photosynthetic Pigments, Physical"),
      siteType = "Estuary"
    )

  if(type == 'fib')
    body <- c(
      body,
      characteristicType = 'Microbiological'
    )

  if(trace)
    cat('Retrieving data...\n')

  res <- url[['Result']] %>%
    httr::POST(httr::add_headers(headers), body = jsonlite::toJSON(body)) %>%
    httr::content('text') %>%
    read.csv(text = .)

  # stop if no data
  if(nrow(res) == 0)
    stop("No data")

  if(trace)
    cat('Retrieving station metadata...\n')

  sta <- url[['Station']] %>%
    httr::POST(httr::add_headers(headers), body = jsonlite::toJSON(body)) %>%
    httr::content('text') %>%
    read.csv(text = .)

  # combine and format
  out <- read_formwqp(res, sta, org, type, trace)

  return(out)

}
