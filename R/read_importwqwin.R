#' Retrieve water quality data from the Florida Department of Environmental Protection's Watershed Information Network (WIN)
#'
#' @param start_date character string for the start date in the format "YYYY-MM-DD"
#' @param end_date character string for the end date in the format "YYYY-MM-DD"
#' @param org_id character string for the organization ID
#' @param verbose logical indicating whether to print verbose output
#' @param max_retries integer indicating maximum number of retries for timeout errors (default = 5)
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
read_importwqwin <- function(start_date, end_date, org_id, verbose = FALSE, max_retries = 5){

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

    # etry logic for the first page
    retry_count <- 0
    res <- NULL

    while(retry_count <= max_retries) {

      res <- try(util_importwqwin(dt1, dt2, org_id, pg), silent = TRUE)

      # break loop if success
      if(!inherits(res, 'try-error')) {
        break
      }

      # check if this timeout error
      error_msg <- attr(res, "condition")$message
      is_timeout <- grepl("timeout|timed out|connection timeout", error_msg, ignore.case = TRUE)

      if(!is_timeout) {
        # skip to next date range if no data
        if(verbose)
          cat("No data found for this date range, moving to next...\n")
        break
      }

      # advance retry if timeout
      retry_count <- retry_count + 1

      if(retry_count <= max_retries) {
        if(verbose)
          cat(paste0("Timeout occurred, retrying... (attempt ", retry_count, " of ", max_retries, ")\n"))
        Sys.sleep(2^retry_count)  # Exponential backoff: 2, 4, 8, 16, 32 seconds
      } else {
        if(verbose)
          cat("Max retries reached, skipping to next date range...\n")
      }
    }

    # if still an error after all retries, skip to next date range
    if(inherits(res, 'try-error'))
      next()

    # start output
    outtmp <- data.frame()
    outtmp <- rbind(outtmp, res$content)

    # total pages
    totpg <- res$totalPages

    # Loop through remaining pages
    while (res$last == FALSE) {

      pg <- pg + 1

      # retry logic for subsequent pages
      retry_count <- 0

      while(retry_count <= max_retries) {
        res <- try(util_importwqwin(dt1, dt2, org_id, pg), silent = TRUE)

        if(!inherits(res, 'try-error')) {
          break  # Success, exit retry loop
        }

        # Check if this is a timeout error
        error_msg <- attr(res, "condition")$message
        is_timeout <- grepl("timeout|timed out|connection timeout", error_msg, ignore.case = TRUE)

        if(!is_timeout) {
          # Not a timeout error, break out of both loops
          break
        }

        # advance counter for timeout
        retry_count <- retry_count + 1

        if(retry_count <= max_retries) {
          if(verbose)
            cat(paste0("Timeout on page ", pg, ", retrying... (attempt ", retry_count, " of ", max_retries, ")\n"))
          Sys.sleep(2^retry_count)  # Exponential backoff
        } else {
          if(verbose)
            cat(paste0("Max retries reached for page ", pg, ", stopping pagination...\n"))
          break
        }
      }

      # if error persists after retries, break out of pagination loop
      if(inherits(res, 'try-error'))
        break

      outtmp <- rbind(outtmp, res$content)

    }

    out <- rbind(out, outtmp)

  }

  return(out)

}
