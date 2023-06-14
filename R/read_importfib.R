#' Load local water quality file for Fecal Indicator Bacteria (FIB)
#'
#' @inheritParams read_importepc
#' @param all logical indicating if all water quality parameters are returned, see details
#'
#' @return A \code{data.frame} of formatted water quality data.
#'
#' @details Loads the "RWMDataSpreadsheet" worksheet from the file located at \code{xlsx}.  The file is downloaded from \url{https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1}.  The files can be viewed at \url{https://epcbocc.sharepoint.com/:f:/s/Share/EiypSSYdsEFCi84Sv_6-t7kBUYaXiIqN0B1n2w57Z_V3kQ?e=NdZQcU}.
#'
#' Returns only FIB parameters from select locations, see \code{\link{read_formfib}} for details.
#'
#' @export
#'
#' @concept read
#'
#' @seealso \code{\link{read_formfib}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
#'
#' # load and assign to object
#' fibdata <- read_importfib(xlsx, download_latest = T)
#'
#' }
read_importfib <- function(xlsx, download_latest = FALSE, na = '', all = FALSE){

  # download data
  rawdat <- read_importepc(xlsx, download_latest = download_latest, na = na)

  # format
  out <- read_formfib(rawdat, all = all)

  return(out)

}
