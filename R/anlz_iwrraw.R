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
#' @concept analyze
#'
#' @examples
#' anlz_iwrraw(iwrraw, tidalcreeks, yr = 2018)
anlz_iwrraw <- function(iwrraw, tidalcreeks, yr = 2018) {

  mcodes <- c("CHLAC","COLOR","COND","DO","DOSAT","NO3O2","ORGN","SALIN","TKN","TN","TP","TSS","TURB")

  # format iwr data
  out <- iwrraw %>%
   # dplyr::filter(wbid %in% unique(tidalcreeks$wbid) & JEI %in% unique(tidalcreeks$JEI)) %>%
    dplyr::filter(year > yr - 11) %>%
    dplyr::filter(year < yr) %>%
    dplyr::filter(masterCode %in% mcodes) %>%
    dplyr::filter(!is.na(result) & result > 0) %>%
    tidyr::unite('date', month, day, year, remove = F, sep = '-') %>%
    dplyr::select(wbid, class, JEI, year, date, masterCode, result,rCode,newComment) %>%
    dplyr::mutate(
      masterCode = dplyr::case_when(
        masterCode %in% c('NO3O2') ~ 'NO23',
        T ~ masterCode
      ),

    # Remove FDEP Qualifiers  mdl left at mdl
      disqual = dplyr::case_when(
        grepl('[VFNOYHJKQ?]', rCode) ~ 1),
      disqual2 = dplyr::case_when(
        grepl('[VFNOYHJKQ?]', newComment) ~ 1))%>%
    dplyr::filter(is.na(disqual) & is.na(disqual2))%>%
    dplyr::filter(result > 0)%>%
    mutate( result = log(result),
            date = as.Date(date, format = '%m-%d-%Y')
    )

  return(out)

}
