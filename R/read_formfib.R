#' Format Fecal Indicator Bacteria (FIB) data
#'
#' @param datin input \code{data.frame} loaded from \code{\link{read_importepc}}
#' @param all logical indicating if all stations with FIB data are returned, default is \code{FALSE}
#'
#' @return A lightly formatted \code{data.frame} with FIB data
#' @export
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @details Formats input data from \code{\link{read_importepc}} appropriate for FIB results, see the details in \code{\link{read_importfib}} for more more information.
#'
#' @seealso \code{\link{read_importfib}}, \code{\link{read_importepc}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
#'
#' # load raw data and assign to object
#' epcall <- read_importepc(xlsx, download_latest = T)
#'
#' # final formatting
#' fibdata <- read_formfib(epcall)
#' }
read_formfib <- function(datin, all = FALSE){

  # relevant bmap areas
  areasfib <- c('Hillsborough River', 'Hillsborough River Tributary', 'Alafia River',
             'Alafia River Tributary', 'Lake Thonotosassa', 'Lake Thonotosassa Tributary',
             'Lake Roberta')

  # format
  out <- datin %>%
    dplyr::mutate(
      epchc_station = as.numeric(StationNumber),
      area = AreaName,
      ecoli = E_Coliform,
      entero = Enterococci,
      fcolif = Fecal_Coliform,
      totcol = Total_Coliform,
      yr = lubridate::year(SampleTime),
      mo = lubridate::month(SampleTime)
    ) %>%
    dplyr::mutate_at(dplyr::vars('ecoli', 'entero', 'fcolif', 'totcol'),
              function(x) as.numeric(gsub('^NULL$|^>|^<', '', x))
    ) %>%
    dplyr::select(area = AreaName, epchc_station, class = Class, SampleTime, yr, mo, Latitude, Longitude, SampleTime,
                  Total_Depth_m = TotalDepth, Sample_Depth_m = SampleDepth, ecoli, ecoli_q = E_ColiformQ,
                  entero, entero_q = EnterococciQ, fcolif, fcolif_q = Fecal_ColiformQ,
                  totcol, totcol_q = Total_ColiformQ
    )

  if(!all)
    out <- out %>%
      dplyr::filter(area %in% areasfib)

  return(out)

}
