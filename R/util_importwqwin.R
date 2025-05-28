#' Utility function to retrieve water quality data from the Florida Department of Environmental Protection's Watershed Information Network (WIN)
#'
#' @param start_date character string for the start date in the format "YYYY-MM-DD"
#' @param end_date character string for the end date in the format "YYYY-MM-DD"
#' @param org_id character string for the organization ID
#' @param page_num integer for the page number to retrieve
#'
#' @returns A list containing the results from the API request
#'
#' @export
#'
#' @details Used internally with \code{\link{read_importwqwin}}.
#'
#' @concept util
#'
#' @examples
#' \dontrun{
#' onepg <- util_importwqwin("2025-01-01", "2025-02-01", "21FLMANA", 1)
#' head(onepg)
#' }
util_importwqwin <- function(start_date, end_date, org_id, page_num) {

  base_url <- "https://prodapps.dep.state.fl.us/dear-watershed/result-activities"

  url <- sprintf("%s?ActivityStartDateFrom%%20%%28%%3E%%3D%%29=%s&ActivityStartDateTo%%20%%28%%3C%%3D%%29=%s&Organization%%20ID=%s&page=%d&size=100&sort=resultKey%%2CASC",
                 base_url,
                 start_date,
                 end_date,
                 org_id,
                 page_num
  )

  # Make the API request
  response <- httr::GET(url)

  # Parse JSON response
  out <- jsonlite::fromJSON(httr::content(response, "text", encoding = "UTF-8"))

  if(length(out$content) == 0)
    stop("No data found for the specified parameters.")

  return(out)

}
