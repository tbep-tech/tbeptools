#' Download and import benthic data for Tampa Bay
#'
#' @param path chr string for local path where the mdb database is located or where it will be downloaded, must include file extension either \code{.mdb} for former or \code{.zip} for latter
#' @param download_latest logical to download latest if a more recent dataset is available
#' @param remove logical if the downloaded zip file is removed after unzipping
#'
#' @return A nested \code{tibble} of station, taxa, and field sample data
#'
#' @details
#' This function downloads and unzips a Microsoft Access Database from \url{ftp://ftp.epchc.org/EPC_ERM_FTP/Benthic_Monitoring/}.  The database tables are accessed using a connection through the RODBC package.  This requires an installation of the Microsoft 64 bit driver for Access databases, available at \url{https://www.microsoft.com/en-us/download/details.aspx?id=54920}.  The function has not been tested for 32-bit versions of R or outside of Windows.
#'
#' For the \code{path} argument, you must specify the full path and not the home expansion, i.e., \code{'C:/Users/yourname/Desktop/benthic.zip'} and not \code{'~/Desktop/benthic.zip'}.  If the zipped file has previously been downloaded and extracted, the direct path to the .mdb file can be uased for \code{path}.
#'
#' The .mdb database in the unzipped folder is large and a temporary file can be created to preserve file space, e.g., using \code{tempfile(fileext = '.zip')} for the \code{path} argument. See the examples.
#'
#' @export
#'
#' @concept read
#'
#' @examples
#' \dontrun{
#' # location to download data
#' path <- 'C:/Users/mbeck/Desktop/benthic.zip'
#'
#' # load and assign to object
#' benthicdata <- read_importbenthic(path, download_latest = TRUE)
#'
#' # or use existing mdb
#' path <- 'C:/Users/mbeck/Desktop/benthic/EPC DataSubmittals.mdb'
#' benthicdata <- read_importbenthic(path, download_latest = FALSE)
#'
#' # use a temporary zip file
#' path <- tempfile(fileext = '.zip')
#' benthicdata <- read_importbenthic(path, download_latest = TRUE)
#' }
read_importbenthic <- function(path, download_latest = FALSE, remove = FALSE){

  # function globals
  drvr <- 'Microsoft Access Driver (*.mdb, *.accdb)'
  iszip <- grepl('\\.zip$', path)

  ##
  # sanity checks

  if(!file.exists(path) & !download_latest)
    stop('File at path does not exist, use download_latest = TRUE')

  if(download_latest & !iszip)
    stop('Change file extension to zip if download_latest = TRUE')

  # check if driver installed
  if(!drvr %in% RODBC::odbcDataSources())
    stop('Cannot find Microsoft Access driver. If you are using 64-bit R on Windows, download the driver here:\n\n https://www.microsoft.com/en-us/download/details.aspx?id=54920 \n\n')

  ##
  # download
  urlin <- 'ftp://ftp.epchc.org/EPC_ERM_FTP/Benthic_Monitoring/EPC DataSubmittals.zip'
  read_dlcurrent(path, download_latest, urlin = urlin)

  # unzip, find mdb
  if(iszip){

    zipdest <- gsub('\\.zip$', '', path)
    utils::unzip(path, exdir = zipdest)

    if(remove)
      file.remove(path)

    path <- list.files(zipdest, '\\.mdb', full.names = TRUE)

  }

  drvr <- paste0('Driver={', drvr, '};')
  odbccall <- paste0(drvr, 'DBQ=', path)
  channel <- RODBC::odbcDriverConnect(odbccall)

  # format benthic data
  out <- read_formbenthic(channel)

  # close connection
  RODBC::odbcClose(channel)

  return(out)

}
