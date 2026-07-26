#' Utility function to retrieve data from the Water Quality Portal with retry
#'
#' @param url chr string for the Water Quality Portal API endpoint to query
#' @param headers named chr vector of HTTP headers to pass to \code{httr::POST}
#' @param body named list of the JSON request body to pass to \code{httr::POST}
#' @param max_retries integer indicating maximum number of retries on request failure (default = 5)
#' @param trace logical indicating whether to print retry messages, default \code{TRUE}
#'
#' @returns A data frame parsed from the CSV response
#'
#' @export
#'
#' @details Used internally with \code{\link{read_importwqp}}. Retries with exponential backoff on any request or parsing failure (e.g., an empty or malformed response from an intermittent API failure), since such failures are not reliably identifiable by error message alone.
#'
#' @concept util
util_importwqp <- function(url, headers, body, max_retries = 5, trace = TRUE){

  retry_count <- 0
  res <- NULL

  while(retry_count <= max_retries){

    res <- try({
      response <- httr::POST(url, httr::add_headers(headers), body = jsonlite::toJSON(body))
      txt <- httr::content(response, 'text')
      read.csv(text = txt)
    }, silent = TRUE)

    if(!inherits(res, 'try-error'))
      break

    retry_count <- retry_count + 1

    if(retry_count > max_retries)
      break

    if(trace)
      cat(paste0('Request failed, retrying... (attempt ', retry_count, ' of ', max_retries, ')\n'))

    Sys.sleep(2^retry_count)

  }

  if(inherits(res, 'try-error'))
    stop(paste('Failed to retrieve data after', max_retries, 'retries:',
                attr(res, 'condition')$message))

  res

}
