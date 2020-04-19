#' Load local phytoplankton cell count file
#'
#' @param xlsx chr string path for local excel file, to overwrite it not current
#' @param na chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}
#' @param download_latest logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{xlsx} if available
#' @param connecttimeout numeric for maximum number of seconds to wait until connection timeout for \code{\link[RCurl]{getURL}}
#' @param tryurl logical indicating if \code{\link[RCurl]{getURL}} is repeatedly called in a \code{while} loop if first connection is unsuccessful
#' @param ... additional arguments passed to \code{\link[readxl]{read_xlsx}}
#'
#' @return A \code{data.frame} of formatted water quality data.
#'
#' @details Pytoplankton cell count data downloaded from ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/, file PlanktonDataList_ThroughCurrentReportMonth.xlsx
#'
#' @export
#'
#' @family read
#'
#' @seealso \code{\link{read_importwq}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- 'C:/Users/Owner/Desktop/phyto_data.xlsx'
#'
#' # load and assign to object
#' phytodata <- read_importphyto(xlsx)
#' }
read_importphyto <- function(xlsx, na = '', download_latest = FALSE, connecttimeout = 10, tryurl = FALSE, ...){

  # download latest and compare with current if exists
  read_dlcurrent(xlsx, download_latest, connecttimeout = connecttimeout, tryurl = tryurl, phyto = TRUE)

  # sanity checks
  if(!download_latest)
    stopifnot(file.exists(xlsx))

  # load
  rawdat <- readxl::read_xlsx(xlsx, na = na, col_types = c("text", "text", "text", "text", "text", "text", "date", "text",
                                                           "text", "text", "text", "text", "text", "text", "text", "text",
                                                           "text", "text", "text", "text", "text", "text", "text", "text",
                                                           "text", "text", "text")
  )

  # format
  out <- read_formphyto(rawdat)

  return(out)

}
