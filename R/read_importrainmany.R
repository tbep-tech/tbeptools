#' Run \code{read_importrain} for multiple years
#'
#' Run \code{read_importrain} for multiple years
#'
#' @param yrs numeric vector of years to download (do not need to be in order)
#' @param quiet logical passed to \code{\link{read_importrain}} to suppress messages (default)
#' @param sleep numeric number of seconds to pause between years
#'
#' @returns A data frame identical to that returned by \code{\link{read_importrain}} with the years requested
#'
#' @details This function is a simple wrapper for \code{\link{read_importrain}} to download multiple years of rainfall data from the Southwest Florida Water Management District's (SWFWMD) ftp site: ftp://ftp.swfwmd.state.fl.us/pub/radar_rainfall/Daily_Data/. The function will pause for \code{sleep} seconds between years to avoid overloading the server.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' read_importrainmany(c(2021, 2022), quiet = F)
#' }
read_importrainmany <- function(yrs, quiet = FALSE, sleep = 5){

  yrs <- yrs
  prcp_out <- list()

  for(i in seq_along(yrs)){

    yr = yrs[[i]]
    prcptmp <- read_importrain(curyr = yr,
                               catchpixels = catchpixels,
                               quiet = quiet)

    prcp_out[[i]] <- prcptmp
    rm(prcptmp)

    # pause for sleep seconds between years
    Sys.sleep(sleep)

  }

  out <- dplyr::bind_rows(prcp_out)

  return(out)

}
