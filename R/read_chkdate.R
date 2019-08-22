#' Compare date of local xlsx file with the same file on the server
#'
#' @param epchc_url chr string of full path to file on the server
#' @param xlsx chr string of full path to local file
#' @param connecttimeout numeric for maximum number of seconds to wait until connection timeout for \code{\link[RCurl]{getURL}}
#'
#' @return A logical vector indicating if the local file is current
#'
#' @importFrom magrittr %>%
#'
#' @importFrom RCurl getURL curlOptions
#'
#' @family read
#'
#' @export
#'
#' @examples
#' \dontrun{
#' epchc_url <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx"
#' xlsx <- 'C:/Users/Owner/Desktop/2018_Results_Updated.xls'
#' read_chkdate(epchc_url, xlsx)
#' }
read_chkdate <- function(epchc_url, xlsx, connecttimeout = 60) {

  # URL on server to check
  con <- epchc_url %>%
    dirname %>%
    paste0(., '/')

  opts <- curlOptions(connecttimeout = connecttimeout, ftp.response.timeout = connecttimeout, timeout = connecttimeout)
  dat <- getURL(con, ssl.verifypeer = FALSE, .opts = opts)

  # parse date of file
  srdate <- dat %>%
    strsplit('\\n') %>%
    .[[1]] %>%
    grep(basename(epchc_url), ., value = TRUE) %>%
    gsub('^(.*AM|.*PM).*$', '\\1', .) %>%
    lubridate::mdy_hm(.)

  # get date of local file
  lcdate <- file.info(xlsx)$mtime

  # check if serer date is less than or equal to local file date
  is_latest <- srdate <= lcdate

  return(is_latest)

}
