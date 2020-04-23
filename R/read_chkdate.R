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
  brk <- 0

  # attempt first connection
  dlres <- tryCatch({
      download.file(con, tmp, quiet = TRUE)
      res <- TRUE
    },
    error = function(e) return(FALSE),
    warning = function(w) return(FALSE)
  )

  # retry connect no more than twenty times
  while(!dlres & brk < 20) {

    cat('trying connection again...\n')
    brk <- brk + 1

    dlres <- tryCatch({
      download.file(con, tmp, quiet = TRUE)
      res <- TRUE
    },
    error = function(e) return(FALSE),
    warning = function(w) return(FALSE)
    )

  }

  if(brk == 20)
    stop("Couldn't connect to FTP site, sad face...")

  # fim download does not work as below on linux os
  if(Sys.info()['sysname'] == 'Linux' & grep('floridamarine', con)){

    srdate <- dat %>%
      strsplit('\\n') %>%
      .[[1]] %>%
      grep(basename(urlin), ., value = TRUE) %>%
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

  # windows proc
  if(!(Sys.info()['sysname'] == 'Linux' & grep('floridamarine', con))){

    # read file after success
    html <- xml2::read_html(readChar(tmp, 1e6))
    file.remove(tmp)

    # date of online file
    srdate <- html %>%
      xml2::xml_text() %>%
      strsplit(., "[\n\r]+") %>%
      .[[1]] %>%
      grep(basename(urlin), ., value = TRUE) %>%
      gsub('^(.*AM|.*PM).*$', '\\1', .) %>%
      lubridate::mdy_hm(.)

  }

  # get date of local file
  lcdate <- file.info(xlsx)$mtime

  # check if server date is less than or equal to local file date
  is_latest <- srdate <= lcdate

  return(is_latest)

}
