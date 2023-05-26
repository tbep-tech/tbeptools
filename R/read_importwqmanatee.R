#' Import water quality data for Manatee County
#'
#' Import water quality data for Manatee County
#'
#' @param trace logical indicating whether to display progress messages, default \code{FALSE}
#'
#' @return A data frame containing the imported water quality data for Manatee County.
#'
#' @details This function retrieves water quality data from the Water Quality Data Exchange API for Manatee County. It fetches results and station metadata, combines and formats them using the \code{read_formwqmanatee} function, and returns the processed data as a data frame.  Parameters included are nutrients, chlorophyll, and Secchi depth
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @seealso \code{\link{read_formwqmanatee}}, \code{\link{read_importwq}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' mancodata <- read_importwqmanatee()
#' }
read_importwqmanatee <- function(trace = F){

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
    organization = c("21FLMANA_WQX"),
    sampleMedia = c("Water"),
    characteristicType = c("Information", "Nutrient", "Biological, Algae, Phytoplankton, Photosynthetic Pigments"),
    providers = c("STORET"),
    siteType = c("Estuary")#,
    # ActivityTypeCode = c("Field Msr/Obs", "Sample-Routine")
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
  out <- read_formwqmanatee(res, sta, trace)

  return(out)

}
