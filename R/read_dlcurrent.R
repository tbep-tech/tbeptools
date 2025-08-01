#' Download latest file from epchc.org
#'
#' @param locin chr string path for local file, to overwrite it not current
#' @param download_latest logical to download latest file regardless of local copy
#' @param urlin url for file location
#'
#' @return The local copy specified in the path by \code{locin} is overwritten by the new file is not current or \code{download_latest = TRUE}.  The function does nothing if \code{download_latest = FALSE}.
#'
#' @importFrom dplyr %>%
#'
#' @export
#'
#' @concept read
#'
#' @details The local copy is checked against a temporary file downloaded from the location specified by \code{urlin}.  The local file is replaced with the downloaded file if the MD5 hashes are different.
#' @examples
#' \dontrun{
#' locin <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
#' urlin1 <- 'https://epcbocc.sharepoint.com/:x:/s/Share/'
#' urlin2 <- 'EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL'
#' urlin <- paste0(urlin1, urlin2, '&download=1')
#' read_dlcurrent(locin = locin, urlin = urlin)
#' }
read_dlcurrent <- function(locin, download_latest = TRUE, urlin){

  # exit the function if no download
  if(!download_latest) return()

  # download data from remote
  tmpfl <- tempfile(fileext = tools::file_ext(locin))
  download.file(url = urlin, destfile = tmpfl, method = "libcurl", mode = "wb", quiet = T)

  # if the file exists, compare with the file on server
  if (file.exists(locin)){

    # compare dates
    is_latest <- tools::md5sum(tmpfl)[[1]] == tools::md5sum(locin)[[1]]

    if (!is_latest){
      message('Replacing local file with current...\n')

      file.copy(tmpfl, locin, overwrite=T)

    }

    if(is_latest){
      message('File is current...\n')
    }

  } else {

    message('File ', locin, ' does not exist, replacing with downloaded file...\n')

    file.copy(tmpfl, locin)

  }
}
