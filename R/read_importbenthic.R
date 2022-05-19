#' Download and import benthic data for Tampa Bay
#'
#' @param path chr string for local path where the zipped folder will be downloaded, must include .zip extension
#' @param download_latest logical to download latest if a more recent dataset is available
#' @param remove logical if the downloaded folder is removed after unzipping
#'
#' @return A nested \code{tibble} of station, taxa, and field sample data
#'
#' @details
#' This function downloads and unzips a folder of base tables used to calculate the benthic index from \url{https://epcbocc.sharepoint.com/:u:/s/Share/EdY7IaU75kFPnVhyoe1yITcBESvFZNAreBwabwyL8EfuqQ?e=1i8Rnf&download=1}.
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
  urlin <- 'https://epcbocc.sharepoint.com/:u:/s/Share/EdY7IaU75kFPnVhyoe1yITcBESvFZNAreBwabwyL8EfuqQ?e=1i8Rnf&download=1'
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
