#' Retrieve water quality data from the Florida Department of Environmental Protection's Watershed Information Network (WIN)
#'
#' @param start_date character string for the start date in the format "YYYY-MM-DD"
#' @param end_date character string for the end date in the format "YYYY-MM-DD"
#' @param org_id character string for the organization ID
#' @param verbose logical indicating whether to print verbose output
#'
#' @returns A data frame containing the water quality data
#' @export
#'
#' @details This function implements \code{\link{util_importwqwin}} iteratively to retrieve water quality results for the specified organization ID and start date. Data are retrieved using the API at <https://prodapps.dep.state.fl.us/dear-watershed/swagger-ui/index.html>.
#' @examples
#' \dontrun{
#' dat <- read_importwqwin("2025-01-15", "2025-02-15", "21FLMANA", verbose = TRUE)
#' head(dat)
#' }
read_importwqwin <- function(start_date, end_date, org_id, verbose = FALSE){

  # date sequences to pull
  dts <- util_dateseq(start_date, end_date)

  out <- data.frame()

  for(i in 1:nrow(dts)){

    dt1 <- dts[i, 'start']
    dt2 <- dts[i, 'end']

    # Get results for the first page
    if(verbose)
      cat(paste0("Retrieving data from ", as.character(dt1), " to ", as.character(dt2), "\n"))

    pg <- 0
    res <- try(util_importwqwin(dt1, dt2, org_id, pg), silent = TRUE)

    if(inherits(res, 'try-error'))
      break()

    # start output
    outtmp <- data.frame()
    outtmp <- rbind(outtmp, res$content)

    # total pages
    totpg <- res$totalPages

    # Loop through remaining pages
    while (res$last == FALSE) {

      pg <- pg + 1
      res <- util_importwqwin(dt1, dt2, org_id, pg)
      outtmp <- rbind(outtmp, res$content)

    }

    out <- rbind(out, outtmp)

  }

  return(out)

}
