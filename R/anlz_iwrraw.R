#' Format raw IWR data
#'
#' Format raw IWR data
#'
#' @param iwrraw FDEP impaired waters rule run 56 data base as \code{\link{data.frame}}
#' @param tidalcreeks \code{\link[sf]{sf}} object for population of tidal creeks
#' @param yr numeric for reference year to evaluate, scores are based on the planning period beginning ten years prior to this date
#'
#' @details The function subsets the raw IWR data for the selected value in \code{yr} and the ten years prior to \code{yr} and subsets by the creek population in \code{\link{tidalcreeks}}. Select water quality parameters in \code{masterCode} are filtered and some of the names are combined for continuity.
#'
#' @return A \code{\link{data.frame}} with the formatted data
#' @export
#'
#' @family analyze
#'
#' @examples
#' anlz_iwrraw(iwrraw, tidalcreeks, yr = 2018)
anlz_iwrraw <- function(iwrraw, tidalcreeks, yr = 2018) {

  mcodes <- c("CHLAC","CHLA_ ", "COLOR", "COND", "DO", "DOSAT", "DO_MG", "NO23_", "NO3O2", "ORGN", "SALIN", "TKN", "TKN_M", "TN", "TN_MG", "TP", "TPO4_",
              "TP_MG", "TSS", "TSS_M", "TURB")

  # format iwr data
  out <- iwrraw %>%
    dplyr::filter(wbid %in% unique(tidalcreeks$wbid) & JEI %in% unique(tidalcreeks$JEI)) %>%
    dplyr::filter(year > yr - 11) %>%
    dplyr::filter(masterCode %in% mcodes) %>%
    dplyr::filter(!is.na(result) & result > 0) %>%
    tidyr::unite('date', month, day, year, remove = F, sep = '-') %>%
    dplyr::select(wbid, class, JEI, year, date, masterCode, result) %>%
    dplyr::mutate(
      masterCode = dplyr::case_when(
        masterCode %in% 'CHLA_' ~ 'CHLAC',
        masterCode %in% c('NO23_', 'NO3O2') ~ 'NO23',
        masterCode %in% 'TKN_M' ~ 'TKN',
        masterCode %in% 'TN_MG' ~ 'TN',
        masterCode %in% c('TPO4_', 'TP_MG') ~ 'TP',
        masterCode %in% 'TSS_M' ~ 'TSS',
        T ~ masterCode
      ),
      result = log(result),
      date = as.Date(date, format = '%m-%d-%Y')
    )

  return(out)

}
