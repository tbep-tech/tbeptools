#' Download and import sediment data for Tampa Bay
#'
#' @param path chr string for local path where the zipped folder will be downloaded, must include .zip extension
#' @param download_latest logical to download latest if a more recent dataset is available
#' @param remove logical if the downloaded folder is removed after unzipping
#'
#' @return A \code{data.frame} of sediment data for Tampa Bay
#'
#' @details
#' This function downloads and unzips a folder of results tables from \url{https://epcbocc.sharepoint.com/:u:/s/Share/Ef9utuKCHD9LliarsOPKCJwB5kxgCObf0tY5x5wX20JQUA?e=DuTseb&download=1} (viewable at \url{https://epcbocc.sharepoint.com/:f:/s/Share/EtOJfziTTa9FliL1oROb9OsBRZU-nO60fu_0NRC162hHjQ?e=4gUXgJ}).
#'
#' The row entries for columns \code{"BetweenTELPEL"} and \code{"ExceedsPEL"} for rows where the \code{"Qualifier"} column is \code{"U"} or \code{"T"} (below detection, not detected) are assigned \code{NA}, regardless of the entry in the source data.
#'
#' @export
#'
#' @concept read
#'
#' @examples
#' \dontrun{
#' # location to download data
#' path <- '~/Desktop/sediment.zip'
#'
#' # load and assign to object
#' sedimentdata <- read_importsediment(path, download_latest = TRUE)
#'
#' }
read_importsediment <- function(path, download_latest = FALSE, remove = FALSE){

  ##
  # sanity checks

  if(!grepl('\\.zip$', path))
    stop('path must include .zip extension')

  if(!file.exists(path) & !download_latest)
    stop('File at path does not exist, use download_latest = TRUE')

  ##
  # download
  urlin <- 'https://epcbocc.sharepoint.com/:u:/s/Share/Ef9utuKCHD9LliarsOPKCJwB5kxgCObf0tY5x5wX20JQUA?e=DuTseb&download=1'
  read_dlcurrent(path, download_latest, urlin = urlin)

  # unzip
  tmppth <- tempfile()
  utils::unzip(path, exdir = tmppth, overwrite = TRUE)

  if(remove)
    file.remove(path)

  # format sediment data
  out <- read_formsediment(pathin = tmppth)

  # remove temp files
  unlink(tmppth, recursive = TRUE)

  return(out)

}
