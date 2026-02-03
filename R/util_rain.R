#' Get rainfall data at NOAA NCDC sites
#'
#' Get rainfall data at NOAA NCDC sites
#'
#' @param station character for the station id to retrieve
#' @param start character for start of time period as YYYY-MM-DD
#' @param end character for end of time period as YYYY-MM-DD
#' @param token character for the NOAA API key
#' @param ntry numeric for the number of times to try to download the data
#' @param quiet logical to print progress in the console
#'
#' @details This function is used to retrieve a long-term record of rainfall for the requested station.  A NOAA API key is required to use the function.
#'
#' @return a single value data frame with the rainfall sum in inches
#'
#' @export
#'
#' @seealso \code{\link{anlz_hydroload}}
#'
#' @examples
#' \dontrun{
#' noaa_key <- Sys.getenv('NOAA_KEY')
#' util_rain('GHCND:USW00092806', start = '2021-01-01', end = '2021-12-31', noaa_key)
#' }
util_rain <- function(station = NULL, start, end, token, ntry = 5, quiet = FALSE){

  # empty data frame
  empt <- data.frame(
          sum = NA_real_
  )
  
  # Build the API request URL
  base_url <- "https://www.ncei.noaa.gov/cdo-web/api/v2/data"
  query_params <- list(
    datasetid = 'GHCND',
    stationid = station,
    datatypeid = 'PRCP',
    startdate = start,
    enddate = end,
    limit = 1000,  # Increased from 400 to get more data per request
    units = 'metric'
  )
  
  # Make the API request
  dat <- try({
    response <- httr::GET(
      url = base_url,
      query = query_params,
      httr::add_headers(token = token)
    )
    
    # Check if request was successful
    if(httr::status_code(response) != 200) {
      stop("API request failed with status code: ", httr::status_code(response))
    }
    
    # Parse the JSON response
    content <- httr::content(response, as = "text", encoding = "UTF-8")
    parsed_data <- jsonlite::fromJSON(content)
    
    # Return the results data frame
    if(!length(parsed_data$results) == 0) {
      parsed_data$results
    } else {
      empt
    }
    
  }, silent = TRUE)

  tryi <- 0
  while(inherits(dat, 'try-error') & tryi < ntry) {

    if(!quiet)
      cat('Retrying...\n')

    dat <- try({
      response <- httr::GET(
        url = base_url,
        query = query_params,
        httr::add_headers(token = token)
      )
      
      if(httr::status_code(response) != 200) {
        stop("API request failed with status code: ", httr::status_code(response))
      }
      
      content <- httr::content(response, as = "text", encoding = "UTF-8")
      parsed_data <- jsonlite::fromJSON(content)

      if(!length(parsed_data$results) == 0) {
        parsed_data$results
      } else {
        empt
      }
      
    }, silent = TRUE)
    
    tryi <- tryi + 1
  }

  if(tryi == ntry){
    if(!quiet) cat('Failed...\n')
    stop()
  }

  # Return empty data frame with expected structure if no data
  if(nrow(dat) == 0)
    return(empt)

  # convert mm to inches, sum across time period, 
  out <- dat |>
    dplyr::mutate(
      value = value / 25.4
    ) |>
    dplyr::summarise(sum = sum(value, na.rm = TRUE))

  return(out)
}