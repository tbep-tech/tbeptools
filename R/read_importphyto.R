#' Load local phytoplankton cell count file
#'
#' @param xlsx chr string path for local excel file, to overwrite if not current
#' @param download_latest logical passed to \code{\link{read_dlcurrent}} to download raw data and compare with existing in \code{xlsx} if available
#' @param na chr vector of strings to interpret as \code{NA}, passed to \code{\link[readxl]{read_xlsx}}
#'
#' @return A \code{data.frame} of formatted water quality data.
#'
#' @details Phytoplankton cell count data downloaded from https://epcbocc.sharepoint.com/:x:/s/Share/ETAfRQ5drmRHntDd1O8s3FQB180Fumed4nQ99w-OIVDxrA?e=eSmtxD&download=1
#'
#' @export
#'
#' @concept read
#'
#' @seealso \code{\link{read_importwq}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- '~/Desktop/phyto_data.xlsx'
#'
#' # load and assign to object
#' phytodata <- read_importphyto(xlsx, download_latest = T)
#' }
read_importphyto <- function(xlsx, download_latest = FALSE, na = c('', 'NULL')){

  # download latest and compare with current if exists
  urlin <- "https://epcbocc.sharepoint.com/:x:/s/Share/ETAfRQ5drmRHntDd1O8s3FQB180Fumed4nQ99w-OIVDxrA?e=eSmtxD&download=1"
  read_dlcurrent(xlsx, download_latest, urlin = urlin)

  # sanity checks
  if(!download_latest)
    stopifnot(file.exists(xlsx))

  # load
  rawdat <- readxl::read_xlsx(xlsx, na = na, col_types = c("text", "text", "text", "text", "text", "text", "date", "text",
                                                           "text", "text", "text", "text", "text", "text", "text", "text",
                                                           "text", "text", "text", "text", "text", "text", "text", "text",
                                                           "text", "text", "text")
  )

  # format
  out <- read_formphyto(rawdat)

  return(out)

}
