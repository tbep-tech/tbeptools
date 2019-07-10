#' Download latest water quality file from epchc.org
#'
#' @param xlsx chr string path for local excel file, to overwrite it not current
#' @param download_latest_epchc logical to download latest file regardless of local copy
#'
#' @return The local copy specified in the path by \code{xlsx} is overwritten by the new file is not current or \code{download_latest_epchc = TRUE}.  The function does nothing if \code{download_latest_epchc = FALSE}.
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @family read
#'
#' @details The local copy is checked against a temporary file downloade from \url{ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx}.  The local file is replaced with the downloaded file if the MD5 hashes are different.
#' @examples
#' \dontrun{
#' xlsx <- 'C:/Users/Owner/Desktop/2018_Results_Updated.xls'
#' read_dlcurrent(xlsx)
#' }
read_dlcurrent <- function(xlsx, download_latest_epchc = TRUE){

  epchc_url <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx"

  # exit the function if no download
  if(!download_latest_epchc) return()

  # if the file exists, compare with the file on server
  if (file.exists(xlsx)){

    # compare dates
    is_latest <- read_chkdate(epchc_url, xlsx)

    if (!is_latest){
      cat('Replacing local file with current...\n')

      # download data from EPCHC's ftp site
      tmp_xlsx <- tempfile(fileext = "xlsx")
      download.file(url = epchc_url, destfile = tmp_xlsx, method = "libcurl", mode = "wb") # 23.2 MB

      file.copy(tmp_xlsx, xlsx, overwrite=T)

    }

    if(is_latest){
      message('File is current...\n')
    }

  } else {

    message('File', xlsx, 'does not exist, replacing with downloaded file...\n')

    # download data from EPCHC's ftp site
    tmp_xlsx <- tempfile(fileext = "xlsx")
    download.file(url = epchc_url, destfile = tmp_xlsx, method = "libcurl", mode = "wb") # 23.2 MB

    file.copy(tmp_xlsx, xlsx)

  }
}
