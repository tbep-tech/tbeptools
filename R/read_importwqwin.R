#' Retrieve water quality data from the Florida Department of Environmental Protection's Watershed Information Network (WIN)
#'
#' @param start_date character string for the start date in the format "YYYY-MM-DD"
#' @param org_id character string for the organization ID
#' @param verbose logical indicating whether to print verbose output
#'
#' @returns A data frame containing the water quality data
#' @export
#'
#' @details This function implements \code{\link{util_importwqwin}} iteratively to retrieve one to many pages of water quality results for the specified organization ID and start date. Data are retrieve using the API at <https://prodapps.dep.state.fl.us/dear-watershed/swagger-ui/index.html>.
#' @examples
#' \dontrun{
#' dat <- read_importwqwin("2025-01-01", "21FLMANA", verbose = TRUE)
#' head(dat)
#' }
read_importwqwin <- function(start_date, org_id, verbose = FALSE){

  # Get results for the first page
  if(verbose)
    cat("Retrieving page 1...\n")

  pg <- 0
  res <- util_importwqwin(start_date, org_id, pg)

  # start output
  out <- data.frame()
  out <- rbind(out, res$content)

  # total pages
  totpg <- res$totalPages

  # Loop through remaining pages
  while (res$last == FALSE) {

    pg <- pg + 1
    if(verbose)
      cat(sprintf("Retrieving page %d of %d...\n", pg + 1, totpg))

    res <- util_importwqwin(start_date, org_id, pg)
    out <- rbind(out, res$content)

  }

  return(out)

}
