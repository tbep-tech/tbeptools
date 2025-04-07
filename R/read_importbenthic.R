#' Download and import benthic data for Tampa Bay
#'
#' @param path chr string for local path where the zipped folder will be downloaded, must include .zip extension
#' @param download_latest logical to download latest if a more recent dataset is available
#' @param remove logical if the downloaded folder is removed after unzipping
#'
#' @return A nested \code{tibble} of station, taxa, and field sample data.
#'
#' @details
#' This function downloads and unzips a folder of base tables used to calculate the benthic index from \url{https://epcbocc.sharepoint.com/:f:/s/Share/EtOJfziTTa9FliL1oROb9OsBRZU-nO60fu_0NRC162hHjQ?e=4gUXgJ}.
#'
#' Index the corresponding list element in the \code{value} column to view each dataset. For example, the stations data in the first row can be viewed as \code{benthicdata$value[[1]]}.
#'
#' @export
#'
#' @concept read
#'
#' @examples
#' \dontrun{
#' # location to download data
#' path <- '~/Desktop/benthic.zip'
#'
#' # load and assign to object
#' benthicdata <- read_importbenthic(path, download_latest = TRUE)
#'
#' }
read_importbenthic <- function(path, download_latest = FALSE, remove = FALSE){

  ##
  # sanity checks

  if(!grepl('\\.zip$', path))
    stop('path must include .zip extension')

  if(!file.exists(path) & !download_latest)
    stop('File at path does not exist, use download_latest = TRUE')

  ##
  # download
  urlin <- 'https://epcbocc.sharepoint.com/:u:/s/Share/EQUCWBuwCNdGuMREYAyAD1gBKC98mYtCHMWX0FYLrbT4KA?e=nDfnnQ&download=1'
  read_dlcurrent(path, download_latest, urlin = urlin)

  # unzip
  tmppth <- tempfile()
  utils::unzip(path, exdir = tmppth, overwrite = TRUE)

  if(remove)
    file.remove(path)

  # format benthic data
  out <- read_formbenthic(pathin = tmppth)

  # remove temp files
  unlink(tmppth, recursive = TRUE)

  return(out)

}
