#' Download latest file from epchc.org
#'
#' @param xlsx chr string path for local excel file, to overwrite it not current
#' @param download_latest logical to download latest file regardless of local copy
#' @param urlin url for file location
#'
#' @return The local copy specified in the path by \code{xlsx} is overwritten by the new file is not current or \code{download_latest = TRUE}.  The function does nothing if \code{download_latest = FALSE}.
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @family read
#'
#' @details The local copy is checked against a temporary file downloaded from the location specified by \code{urlin}.  The local file is replaced with the downloaded file if the MD5 hashes are different.
#' @examples
#' \dontrun{
#' xlsx <- '~/Desktop/2018_Results_Updated.xls'
#' urlin <- 'ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
#' read_dlcurrent(xlsx, urlin = urlin)
#' }
read_dlcurrent <- function(xlsx, download_latest = TRUE, urlin){

  # exit the function if no download
  if(!download_latest) return()

  # if the file exists, compare with the file on server
  if (file.exists(xlsx)){

    # compare dates
    is_latest <- read_chkdate(urlin, xlsx)

    if (!is_latest){
      cat('Replacing local file with current...\n')

      # download data from EPCHC's ftp site
      tmp_xlsx <- tempfile(fileext = "xlsx")
      download.file(url = urlin, destfile = tmp_xlsx, method = "libcurl", mode = "wb") # 23.2 MB

      file.copy(tmp_xlsx, xlsx, overwrite=T)

    }

    if(is_latest){
      message('File is current...\n')
    }

  } else {

    message('File ', xlsx, ' does not exist, replacing with downloaded file...\n')

    # download data from EPCHC's ftp site
    tmp_xlsx <- tempfile(fileext = tools::file_ext(xlsx))
    download.file(url = urlin, destfile = tmp_xlsx, method = "libcurl", mode = "wb") # 23.2 MB

    file.copy(tmp_xlsx, xlsx)

  }
}
