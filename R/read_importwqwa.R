#' Import data from the Water Atlas API
#'
#' Import data from the Water Atlas API
#'
#' @param dataSource Character for the data source to retrieve, e.g., WIN_21FLHILL
#' @param parameter Character for the parameter to retrieve
#' @param start_date Numeric for the start date in ISO format, optional
#' @param end_date Numeric for the end date in ISO format, optional
#' @param trace Logical indicating whether to display progress messages, default \code{TRUE}
#' 
#' @details This function retrieves sampling data from the Water Atlas API (\url{https://dev.api.wateratlas.org/redoc/index.html#tag/Sampling-Data/operation/StreamSamplingData}) using the specified data source and parameter. Optional start and end dates can be provided to filter the data by date range. The function processes the NDJSON response stream and returns a data frame of sampling records.
#' 
#' See \code{\link{util_importwqwa}} for retrieving metadata such as available data sources and parameters.
#' 
#' @return A data frame containing the imported sampling data
#' 
#' @export
#' 
#' @examples
#' read_importwqwa('WIN_21FLPDEM', 'Chla_ugl', '2023-01-01', '2023-02-01')
read_importwqwa <- function(dataSource, parameter, start_date = NULL, end_date = NULL, trace = TRUE) {

  params <- list(
    dataSource = dataSource,
    parameter = parameter
  )
  
  if (!is.null(start_date)) {
    params$startDate <- start_date
  }
  if (!is.null(end_date)) {
    params$endDate <- end_date
  }
  
  if (trace)
    cat(sprintf("Requesting: %s\n", toString(params)))
  
  url <- "https://dev.api.wateratlas.org/api/samplingdata/stream"
  response <- httr::GET(url, query = params)
  httr::stop_for_status(response)
  
  # Get response content as text and split by lines
  content_text <- httr::content(response, as = "text", encoding = "UTF-8")
  lines <- strsplit(content_text, "\n")[[1]]
  
  out <- list()
  
  if(trace)
    cat("Processing NDJSON stream...\n")
  
  for (i in lines) {
    if (nchar(trimws(i)) > 0) {
      tryCatch({
        item <- jsonlite::fromJSON(i)
        out <- append(out, list(item), after = length(out))
      }, error = function(e) {
        cat(sprintf("Error parsing JSON line: %s\n", e$message))
      })
    }
  }
  
  out <- dplyr::bind_rows(out) |> 
    dplyr::mutate(
      activityStartDate = as.Date(activityStartDate)
    )
  
  return(out)

}
