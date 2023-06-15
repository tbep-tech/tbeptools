#' Load local water quality file for Fecal Indicator Bacteria (FIB)
#'
#' @inheritParams read_importepc
#' @param all logical indicating if all stations with FIB data are returned, default is \code{FALSE}, see details
#'
#' @return A \code{data.frame} of formatted FIB data.
#'
#' @details Loads the "RWMDataSpreadsheet" worksheet from the file located at \code{xlsx}.  The file is downloaded from \url{https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1}.  The files can be viewed at \url{https://epcbocc.sharepoint.com/:f:/s/Share/EiypSSYdsEFCi84Sv_6-t7kBUYaXiIqN0B1n2w57Z_V3kQ?e=NdZQcU}.
#'
#' Returns FIB data including E. coli, Enterococcus, Fecal Coliform, and Total Coliform concentrations and waterbody class (freshwater as 1 or 3F, marine as 2 or 3M) for stations and sample dates, function is used internally within \code{\link{read_importfib}}
#'
#' Values are returned for E. coli (\code{ecoli}), Enterococcus (\code{ecocci}), Fecal Coliform (\code{fcolif}), and Total Coliform (\code{totcol}).  Values shown are # of colonies per 100 mL of water (\code{#/100mL}). Qualifier columns for each are also returned with the \code{_q} suffix. Qualifier codes can be interpreted from the source spreadsheet.
#'
#' Concentrations noted with \code{<} or \code{>} in the raw data are reported as is, with only the numeric value shown.  Samples with this notation can be determined from the qualifier columns.
#'
#' The default output returns only stations with AreaName in the source data as Hillsborough River, Hillsborough River Tributary, Alafia River, Alafia River Tributary, Lake Thonotosassa, Lake Thonotosassa Tributary, and Lake Roberta.  Use \code{all = TRUE} to return all stations.
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
read_importfib <- function(xlsx, download_latest = FALSE, na = c('', 'NULL'), all = FALSE){

  # download data
  rawdat <- read_importepc(xlsx, download_latest = download_latest, na = na)

  # format
  out <- read_formfib(rawdat, all = all)

  return(out)

}
