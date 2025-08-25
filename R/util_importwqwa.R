#' Retrieve metadata from the Water Atlas API
#'
#' @param endpoint Character indicating which API endpoint to retrieve, see details
#' @param pageSize Numeric indicating the number of records to retrieve
#' @param waterbodyId Optional numeric indicating a specific waterbody ID if requesting sampling locations
#' 
#' @details Endpoints include \code{"dataSources"}, \code{"parameters"}, \code{"sampling-locations"}, or \code{"waterbodies"}.
#' 
#' Data are retrieved in pages if the total number of records exceeds the page size.
#' 
#' @returns A data frame of results for the given endpoint
#'
#' @export
#' 
#' @examples
#' # get available parameters
#' util_importwqwa('parameters')
#' 
#' # get sampling locations for a specific waterbody
#' waterbodies <- util_importwqwa('waterbodies')
#' waterbodyid <- waterbodies |> 
#'   dplyr::filter(grepl('Hillsborough Bay', name)) |>
#'   dplyr::pull(id)
#' util_importwqwa('sampling-locations', waterbodyId = waterbodyid)
util_importwqwa <- function(endpoint, pageSize = 10000, waterbodyId = NULL){

  endpoint <- match.arg(endpoint, c('dataSources', 'parameters', 'sampling-locations', 'waterbodies'))
  
  base_url <- "https://dev.api.wateratlas.org"

  params <- list(
    pageSize = pageSize,
    pageNumber = 1
  )
  
  if(!is.null(waterbodyId) & endpoint == 'sampling-locations'){
    params$waterbodyId <- waterbodyId
  }

  url <- paste0(base_url, '/api/', endpoint)

  response <- httr::GET(url, query = params)
  httr::stop_for_status(response)
  
  data <- httr::content(response, as = "parsed")
  
  out <- dplyr::bind_rows(data$items)
  
  totpages <- data$totalPages
  
  if(totpages > 1){

    for(i in 2:totpages){

      params$pageNumber <- i
  
      response <- httr::GET(url, query = params)
      
      tryCatch({
        httr::stop_for_status(response)
        data <- httr::content(response, as = "parsed")
        outi <- dplyr::bind_rows(data$items)
        out <- dplyr::bind_rows(out, outi)
        
      }, error = function(e) {
        cat("Page", i, "of", totpages, "failed\n")
      })
    }
  }

  return(out)

}