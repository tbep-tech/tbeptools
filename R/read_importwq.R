#' Load local water quality file
#'
#' @inheritParams read_importepc
#' @param all logical indicating if all water quality parameters are returned, see details
#'
#' @return A \code{data.frame} of formatted water quality data.
#'
#' @details Loads the "RWMDataSpreadsheet" worksheet from the file located at \code{xlsx}.  The file is downloaded from \url{https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1}.  The files can be viewed at \url{https://epcbocc.sharepoint.com/:f:/s/Share/EiypSSYdsEFCi84Sv_6-t7kBUYaXiIqN0B1n2w57Z_V3kQ?e=NdZQcU}.
#'
#' Water quality parameters returned by default are total nitrogen (\code{tn}), Secchi depth (\code{sd}), chlorophyll-a (\code{chla}), salinity (top, mid, and bottom depths, \code{Sal_} prefix), water temperature (top, mid, and bottom depths, \code{Temp_Water_} prefix), turbidity (\code{Turbidity_JTU-NTU}), and water color (\code{Color_345_F45}).  Additional qualifier columns for each that include the \code{_Q} suffix are also returned, excluding salinity and water temperature.  All other water quality parameters and qualifiers can be returned by setting \code{all = T}.
#'
#' @export
#'
#' @concept read
#'
#' @seealso \code{\link{read_formwq}}, \code{\link{read_importphyto}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
#'
#' # load and assign to object
#' epcdata <- read_importwq(xlsx, download_latest = T)
#'
#' # get all water quality parameters
#' epcdataall <- read_importwq(xlsx, download_latest = T, all = T)
#' }
read_importwq <- function(xlsx, download_latest = FALSE, na = c('', 'NULL'), all = FALSE){

  # download data
  rawdat <- read_importepc(xlsx, download_latest = download_latest, na = na)

  # format
  out <- read_formwq(rawdat, all = all)

  return(out)

}
