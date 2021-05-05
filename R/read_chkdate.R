#' Compare date of local xlsx file with the same file on the server
#'
#' @param urlin chr string of full path to file on the server
#' @param xlsx chr string of full path to local file
#'
#' @return A logical vector indicating if the local file is current
#'
#' @importFrom dplyr %>%
#'
#' @importFrom RCurl getURL curlOptions
#'
#' @concept read
#'
#' @export
#'
#' @examples
#' \dontrun{
#' urlin <- 'ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/'
#' urlin <- paste0(urlin, 'RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx')
#' xlsx <- '~/Desktop/2018_Results_Updated.xls'
#' read_chkdate(urlin, xlsx)
#' }
read_chkdate <- function(urlin, xlsx) {

  # URL on server to check
  con <- urlin %>%
    dirname %>%
    paste0(., '/')

  # use Rcurl if epc
  if(grepl('epchc', con)){

    # set timeout options for getULR
    opts <- curlOptions(connecttimeout = 20, ftp.response.timeout = 20, timeout = 20)

    # attempt first connection
    dat <- try({getURL(con, ssl.verifypeer = FALSE, .opts = opts)})

    # try connection again if failed and tryurl = T
    while(inherits(dat, 'try-error')){
      cat('trying connection again...\n')
      dat <- try({getURL(con, ssl.verifypeer = FALSE, .opts = opts)})
    }

    # parse size of file
    srsize <- dat %>%
      strsplit('\\n') %>%
      .[[1]] %>%
      grep(basename(urlin), ., value = TRUE) %>%
      gsub('\\,', '', .) %>%
      gsub('^.*\\s([0-9]+)\\s.*$', '\\1', .) %>%
      as.numeric

  }

  # use xml2 if fim
  if(grepl('floridamarine', con)){

    # download html from ftp to tmp, otherwise dates might be read incorrectly
    tmp <- tempfile()
    brk <- 0

    # change download method type if linux
    meth <- 'auto'
    if(Sys.info()['sysname'] == 'Linux')
      meth <- 'wget'

    # attempt first connection
    dlres <- tryCatch({
        download.file(con, tmp, quiet = TRUE, method = meth)
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
        download.file(con, tmp, quiet = TRUE, method = 'wget')
        res <- TRUE
      },
      error = function(e) return(FALSE),
      warning = function(w) return(FALSE)
      )

    }

    if(brk == 20)
      stop("Couldn't connect to FTP site, sad face...")

    # read file after success
    html <- xml2::read_html(readChar(tmp, 1e6))
    file.remove(tmp)

    # date of online file
    srsize <- html %>%
      xml2::xml_text() %>%
      strsplit(., "[\n\r]+") %>%
      .[[1]] %>%
      grep(basename(urlin), ., value = TRUE) %>%
      gsub('\\,', '', .) %>%
      gsub('^.*\\s([0-9]+)\\s.*$', '\\1', .) %>%
      as.numeric

  }

  # get size of local file
  lcsize <- file.info(xlsx)$size

  # check if server date is the same as the local file date
  is_latest <- srsize <= lcsize

  return(is_latest)

}
