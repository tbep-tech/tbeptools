#' Compare date of local xlsx file with the same file on the server
#'
#' @param urlin chr string of full path to file on the server
#' @param xlsx chr string of full path to local file
#' @param connecttimeout numeric for maximum number of seconds to wait until connection timeout for \code{\link[RCurl]{getURL}}
#' @param tryurl logical indicating if \code{\link[RCurl]{getURL}} is repeatedly called in a \code{while} loop if first connection is unsuccessful
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
#' urlin <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx"
#' xlsx <- 'C:/Users/Owner/Desktop/2018_Results_Updated.xls'
#' read_chkdate(urlin, xlsx)
#' }
read_chkdate <- function(urlin, xlsx, connecttimeout = 20, tryurl = FALSE) {

  # URL on server to check
  con <- urlin %>%
    dirname %>%
    paste0(., '/')

  # set timeout options for getULR
  opts <- curlOptions(connecttimeout = connecttimeout, ftp.response.timeout = connecttimeout, timeout = connecttimeout)

  # attempt first connection
  dat <- try({getURL(con, ssl.verifypeer = FALSE, .opts = opts)})

  # try connection again if failed and tryurl = T
  while(inherits(dat, 'try-error') & tryurl){
    cat('trying connection again...\n')
    dat <- try({getURL(con, ssl.verifypeer = FALSE, .opts = opts)})
  }

  # parse date of file, do seprately for epc or fwri
  srdate <- dat %>%
    strsplit('\\n') %>%
    .[[1]] %>%
    grep(basename(urlin), ., value = TRUE)

  # fwri date parse
  if(grepl('floridamarine', con)){

    srdate <- srdate %>%
      gsub(paste0(basename(urlin), '\\r'), '', .) %>%
      gsub('^.*ftp\\s+', '', .) %>%
      gsub('^[0-9]+', '', .)

    # this tries to convert to date, year may be missing if uploaded in last six months
    tmp <- suppressWarnings(lubridate::ymd_hm(srdate))

    # if fails, assumes that year was missing because file was recent
    if(is.na(tmp))
      tmp <- srdate %>%
        paste(lubridate::year(Sys.Date()), .) %>%
        lubridate::ymd_hm(.)

    srdate <- tmp

  }

  # epc date parse
  if(grepl('epchc', con)){

    srdate <- srdate %>%
      gsub('^(.*AM|.*PM).*$', '\\1', .) %>%
      lubridate::mdy_hm(.)

  }

  # get date of local file
  lcdate <- file.info(xlsx)$mtime

  # check if server date is less than or equal to local file date
  is_latest <- srdate <= lcdate

  return(is_latest)

}
