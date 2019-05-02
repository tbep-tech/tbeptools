#' Get latest from epchc.org
#'
#' @param xlsx excel output
#'
#' @return
#' @export
#'
#' @examples
get_epchc_wq <- function(xlsx){

  epchc_url <- "ftp://ftp.epchc.org/EPC_ERM_FTP/WQM_Reports/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx"

  if (!file.exists(xlsx) | download_latest_epchc){
    # download data from EPCHC's ftp site
    tmp_xlsx <- tempfile(fileext = "xlsx")
    download.file(url = epchc_url, destfile = tmp_xlsx, method = "libcurl", mode = "wb") # 23.2 MB

    is_latest <- md5sum(xlsx) == md5sum(tmp_xlsx)
    if (!is_latest){
      file.copy(tmp_xlsx, xlsx, overwrite=T)
    }
  }
}
