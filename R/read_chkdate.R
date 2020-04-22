#' Compare date of local xlsx file with the same file on the server
#'
#' @param urlin chr string of full path to file on the server
#' @param xlsx chr string of full path to local file
#'
#' @return A logical vector indicating if the local file is current
#'
#' @importFrom magrittr %>%
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
read_chkdate <- function(urlin, xlsx) {

  # URL on server to check
  con <- urlin %>%
    dirname %>%
    paste0(., '/')

  # download html from ftp to tmp, otherwise dates might be read incorrectly
  tmp <- tempfile()
  download.file(con, tmp, quiet = TRUE)
  html <- xml2::read_html(readChar(tmp, 1e6))
  file.remove(tmp)

  # date of online file
  srdate <- html %>%
    xml2::xml_text() %>%
    strsplit(., "[\n\r]+") %>%
    .[[1]] %>%
    grep("(\\d{2}/){2}\\d{4}", ., value = TRUE) %>%
    grep(basename(urlin), ., value = TRUE) %>%
    gsub('^(.*AM|.*PM).*$', '\\1', .) %>%
    lubridate::mdy_hm(.)

  # get date of local file
  lcdate <- file.info(xlsx)$mtime

  # check if server date is less than or equal to local file date
  is_latest <- srdate <= lcdate

  return(is_latest)

}
