#' Download latest water quality file from epchc.org
#'
#' @param xlsx chr string path for local excel file, to overwrite it not current
#' @param download_latest_epchc logical to download latest file regardless of local copy
#'
#' @return The local copy specified in the path by \code{xlsx} is overwritten by the new file is not current or \code{download_latest_epchc = TRUE}.  The function does nothing if \code{download_latest_epchc = FALSE}.
#'
#' @export
#'
#' @details The local copy is checked against a temporary file downloade from \url{ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx}.  The local file is replaced with the downloaded file if the MD5 hashes are different.
#' @examples
#' \dontrun{
#' test_xlsx <- file.path(dir_gdrive, "data/wq/2018_Results_Updated.xls")
#' get_epch_wq(test_xlsx)
#' }
get_epchc_wq <- function(xlsx, download_latest_epchc = TRUE){

  epchc_url <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx"

  # exit the function if no download
  if(!download_latest_epchc) return()

  # download data from EPCHC's ftp site
  tmp_xlsx <- tempfile(fileext = "xlsx")
  download.file(url = epchc_url, destfile = tmp_xlsx, method = "libcurl", mode = "wb") # 23.2 MB

  # if the file exists, compare with downloaded
  if (file.exists(xlsx)){

    is_latest <- tools::md5sum(xlsx) == tools::md5sum(tmp_xlsx)
    if (!is_latest){
      cat('Replacing local file with current...\n')
      file.copy(tmp_xlsx, xlsx, overwrite=T)
    }

    if(is_latest){
      cat('File is current...\n')
    }

  } else {

    cat('File', xlsx, 'does not exist, replacing with downloaded file...\n')
    file.copy(tmp_xlsx, xlsx)

  }
}
