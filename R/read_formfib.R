#' Format Fecal Indicator Bacteria (FIB) data
#'
#' @param datin input \code{data.frame} loaded from \code{\link{read_importwq}}
#'
#' @return A lightly formatted \code{data.frame} with FIB data
#' @export
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @details Returns FIB data including E. coli and Enterococcus cell concentrations and waterbody class (freshwater as 1 or 3F, marine as 2 or 3M) for staions and sample dates, function is used internally within \code{\link{read_importfib}}
#'
#'  Values are returned for E. coli (\code{ecoli}), Enterococcus (\code{ecocci}), Fecal Coliform (\code{fcolif}), and Total Coliform (\code{totcol}).  Values shown are # of colonies per 100 mL of water (\code{#/100mL}). Qualifiers columns for each are also returned with the \code{_q} suffix. Qualifier codes can be interpreted from the source spreadsheet.
#'
#'  Concentrations noted with \code{<} or \code{>} in the raw data are reported as is, with only the numeric value shown.  Samples with this notation can be determined from the qualifier columns.
#'
#'  Only stations with AreaName in the source data as Hillsborough River, Hillsborough River Tributary, Alafia River, Alafia River Tributary, Lake Thonotosassa, Lake Thonotosassa Tributary, Lake Roberta are returned.
#'
#' @seealso \code{\link{read_importfib}}
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
read_formfib <- function(datin){

  # relevant bmap areas
  areas <- c('Hillsborough River', 'Hillsborough River Tributary', 'Alafia River',
             'Alafia River Tributary', 'Lake Thonotosassa', 'Lake Thonotosassa Tributary',
             'Lake Roberta')

  # format
  out <- datin %>%
    dplyr::filter(AreaName %in% areas) %>%
    dplyr::mutate(
      epchc_station = as.numeric(StationNumber),
      area = AreaName,
      ecoli = E_Coliform,
      ecocci = Enterococci,
      fcolif = Fecal_Coliform,
      totcol = Total_Coliform,
      yr = lubridate::year(SampleTime),
      mo = lubridate::month(SampleTime)
    ) %>%
    dplyr::mutate_at(dplyr::vars('ecoli', 'ecocci', 'fcolif', 'totcol'),
              function(x) as.numeric(gsub('^NULL$|^>|^<', '', x))
    ) %>%
    dplyr::select(area, epchc_station, class = Class, SampleTime, yr, mo, Latitude, Longitude, SampleTime,
                  Total_Depth_m = TotalDepth, Sample_Depth_m = SampleDepth, ecoli, ecoli_q = E_ColiformQ,
                  ecocci, ecocci_q = EnterococciQ, fcolif, fcolif_q = Fecal_ColiformQ,
                  totcol, tocol_q = Total_ColiformQ
    )

  return(out)

}
