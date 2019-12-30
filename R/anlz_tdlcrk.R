#' Estimate tidal creek report card scores
#'
#' Estimate tidal creek report card scores
#'
#' @param tidalcreeks \code{\link[sf]{sf}} object for population of tidal creeks
#' @param iwrraw FDEP impaired waters rule run 56 data base as \code{\link{data.frame}}
#' @param yr numeric for reference year to evaluate, scores are based on the planning period beginning ten years prior to this date
#'
#' @return A \code{\link{data.frame}} with the report card scores for each creek, as red, orange, yellow, green, or no data
#' @export
#'
#' @family analyze
#'
#' @examples
#' anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2018)
anlz_tdlcrk <- function(tidalcreeks, iwrraw, yr = 2018) {

  mcodes <- c("CHLAC","CHLA_ ", "COLOR", "COND", "DO", "DOSAT", "DO_MG", "NO23_", "NO3O2", "ORGN", "SALIN", "TKN", "TKN_M", "TN", "TN_MG", "TP", "TPO4_",
    "TP_MG", "TSS", "TSS_M", "TURB")
  # mcodes <- c("TN", "TN_MG")

  # format iwr data
  # filter out some data, recode masterCode, take averages by year
  # spread by masterCode
  iwrdat <- iwrraw %>%
    dplyr::select(wbid, class, JEI, year, masterCode, result) %>%
    dplyr::filter(wbid %in% unique(tidalcreeks$wbid) & JEI %in% unique(tidalcreeks$JEI)) %>%
    dplyr::filter(year > yr - 11) %>%
    dplyr::filter(masterCode %in% mcodes) %>%
    dplyr::filter(!is.na(result) & result > 0) %>%
    dplyr::mutate(
      masterCode = dplyr::case_when(
        masterCode %in% c('NO23_', 'NO3O2') ~ 'NO23',
        masterCode %in% 'TKN_M' ~ 'TKN',
        masterCode %in% 'TN_MG' ~ 'TN',
        masterCode %in% c('TPO4_', 'TP_MG') ~ 'TP',
        masterCode %in% 'TSS_M' ~ 'TSS',
        T ~ masterCode
      ),
      result = log(result)
    ) %>%
    dplyr::group_by(wbid, class, JEI, year, masterCode) %>%
    dplyr::summarise(
      result = mean(result, na.rm = T)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(result = exp(result)) %>%
    tidyr::spread(masterCode, result)

  # left join iwrdata to creek data and add TN thresholds, cautions, and action values
  # grade is the count of the number of times in the past ten year period that TN exceeded one of these values
  alldat <- tidalcreeks %>%
    sf::st_set_geometry(NULL) %>%
    dplyr::left_join(iwrdat, by = c('wbid', 'class', 'JEI')) %>%
    dplyr::mutate(
      tn_threshold = dplyr::case_when(
        !is.na(Creek_Length_m) & !grepl('^PC|^LC', JEI) ~ 1.65,
        !is.na(Creek_Length_m) & grepl('^PC|^LC', JEI) ~ 1.54
      ),
      action = dplyr::case_when(
        !is.na(Creek_Length_m) & !grepl('^PC|^LC', JEI) ~ 1.46,
        !is.na(Creek_Length_m) & grepl('^PC|^LC', JEI) ~ 1.36
      ),
      caution = dplyr::case_when(
        class %in% c('3M', '2') & tn_threshold == 1.65 ~ 1.46 - 0.0174*(23.78 - (Creek_Length_m/1000)),
        class %in% c('3M', '2') & tn_threshold == 1.54 ~ 1.36 - 0.0174*(23.78 - (Creek_Length_m/1000)),
      ),
      grade = dplyr::case_when(
        class %in% c('3F', '1') & TN > tn_threshold ~ 4,
        class %in% c('3F', '1') & TN <= tn_threshold & action <= TN ~ 3,
        class %in% c('3F', '1') & (TN < action | is.na(TN)) ~ 1,
        class %in% c('3M', '2') & TN < caution ~ 1,
        class %in% c('3M', '2') & caution <= TN & TN <= action ~ 2,
        class %in% c('3M', '2') & action <= TN & TN <= tn_threshold ~ 3,
        class %in% c('3M', '2') & TN > tn_threshold ~ 4
      )
    ) %>%
    dplyr::group_by(id, wbid, class, JEI, grade) %>%
    dplyr::summarise(cnt = n()) %>%
    tidyr::spread(grade, cnt) %>%
    dplyr::select(-`<NA>`)

  # assign categories based on grades
  scrdat <- alldat %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      score = dplyr::case_when(
        !is.na(`4`) & `4` > 0 ~ 'Red',
        !is.na(`3`) & `3` > 0 ~ 'Orange',
        !is.na(`2`) & `2` > 2 ~ 'Yellow',
        is.na(`1`) & is.na(`2`) & is.na(`3`) & is.na(`4`) ~ 'No Data',
        T ~ 'Green'
      ),
      score = dplyr::case_when(
        score == 'Red' & class %in% c('3F', '1') & `4` == 1 & `3` > 1 ~ 'Orange',
        score == 'Red' & class %in% c('3F', '1') & `4` == 1 & `1` > 3 ~ 'Green',
        T ~ score
      ),
      score = dplyr::case_when(
        score == 'Orange' & class %in% c('3F', '1') & `3` == 1 & `1` > 3 ~ 'Green',
        T ~ score
      ),
      score = dplyr::case_when(
        score == 'Red' & class %in% c('3M', '2') & (`4` == 1 & sum(`1`, `2`, `3`, na.rm = T) > 2) ~ 'Orange',
        T ~ score
      ),
      score = dplyr::case_when(
        score == 'Orange' & class %in% c('3M', '2') & (`3` == 1 & sum(`1`, `2`, na.rm = T) > 1) ~ 'Yellow',
        T ~ score
      )
    ) %>%
    tidyr::as_tibble()

  return(scrdat)

}
