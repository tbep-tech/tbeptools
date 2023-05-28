#' Import water quality data from the Water Quality Portal
#'
#' Import water quality data from the Water Quality Portal
#'
#' @param org chr string indicating either \code{"Manatee"} or \code{"Pinellas"}
#' @param trace logical indicating whether to display progress messages, default \code{FALSE}
#'
#' @return A data frame containing the imported water quality data for Manatee County.
#'
#' @details This function retrieves water quality data from the Water Quality Data Exchange API for Manatee or Pinellas County. Based on the input to the \code{org} argument, data for the organization defined as \code{"21FLMANA_WQX"} or \code{"21FLPDEM_WQX"} for Manatee or Pinellas County are returned. It fetches results and station metadata, combines and formats them using the \code{read_formwqmanatee} function, and returns the processed data as a data frame.  Parameters included are nutrients, chlorophyll, and Secchi depth.
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
#' # get Manatee County data
#' mancodata <- read_importwqp(org = 'Manatee', trace = T)
#'
#' # get Pinellas County data
#' pincodata <- read_importwqp(org = 'Pinellas', trace = T)
#' }
read_importwqp <- function(org, trace = F){

  # get org identifier based on county input
  org <- match.arg(org, c('Manatee', 'Pinellas'))
  orgin <- list(
      Manatee = '21FLMANA_WQX',
      Pinellas = '21FLPDEM_WQX'
    ) %>%
    .[[org]]

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
    organization = orgin,
    sampleMedia = c("Water"),
    characteristicType = c("Information", "Nutrient", "Biological, Algae, Phytoplankton, Photosynthetic Pigments"),
    providers = c("STORET"),
    siteType = c("Estuary")
  )

  if(trace)
    cat('Retrieving water quality data...\n')

  res <- url[['Result']] %>%
    httr::POST(httr::add_headers(headers), body = jsonlite::toJSON(body)) %>%
    httr::content('text') %>%
    read.csv(text = .)

  if(trace)
    cat('Retrieving station metadata...\n')

  sta <- url[['Station']] %>%
    httr::POST(httr::add_headers(headers), body = jsonlite::toJSON(body)) %>%
    httr::content('text') %>%
    read.csv(text = .)

  # combine and format
  out <- read_formwqp(res, sta, org, orgin, trace)

  return(out)

}
