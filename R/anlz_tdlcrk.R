#' Estimate tidal creek report card scores
#'
#' Estimate tidal creek report card scores
#'
#' @param tidalcreeks \code{\link[sf]{sf}} object for population of tidal creeks
#' @param iwrraw FDEP impaired waters rule run 56 data base as \code{\link{data.frame}}
#' @param tidtrgs optional \code{data.frame} for tidal creek nitroge targets, defaults to \code{\link{tidaltargets}}
#' @param yr numeric for reference year to evaluate, scores are based on the planning period beginning ten years prior to this date
#'
#' @return A \code{\link{data.frame}} with the report card scores for each creek, as act, investigate, caution, target, or no data
#' @export
#'
#' @family analyze
#'
#' @examples
#' anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2018)
anlz_tdlcrk <- function(tidalcreeks, iwrraw, tidtrgs = NULL, yr = 2018) {

  # default targets from data file
  if(is.null(tidtrgs))
    tidtrgs <- tidaltargets

  # get targets
  wcthr <- tidtrgs %>%
    dplyr::filter(region == 'West Central') %>%
    dplyr::pull(threshold)
  wcact <- tidtrgs %>%
    dplyr::filter(region == 'West Central') %>%
    dplyr::pull(action)
  wccau <- tidtrgs %>%
    dplyr::filter(region == 'West Central') %>%
    dplyr::pull(caution)
  pethr <- tidtrgs %>%
    dplyr::filter(region == 'Peninsula') %>%
    dplyr::pull(threshold)
  peact <- tidtrgs %>%
    dplyr::filter(region == 'Peninsula') %>%
    dplyr::pull(action)
  pecau <- tidtrgs %>%
    dplyr::filter(region == 'Peninsula') %>%
    dplyr::pull(caution)

  # format IWR data
  iwrdat <- anlz_iwrraw(iwrraw, tidalcreeks, yr = yr) %>%
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
    dplyr::left_join(iwrdat, by = c('wbid', 'JEI', 'class')) %>%
    dplyr::mutate(
      tn_threshold = dplyr::case_when(
        !is.na(Creek_Length_m) & !grepl('^PC|^LC', JEI) ~ wcthr,
        !is.na(Creek_Length_m) & grepl('^PC|^LC', JEI) ~ pethr
      ),
      action = dplyr::case_when(
        !is.na(Creek_Length_m) & !grepl('^PC|^LC', JEI) ~ wcact,
        !is.na(Creek_Length_m) & grepl('^PC|^LC', JEI) ~ peact
      ),
      caution = dplyr::case_when(
        class %in% c('3M', '2') & tn_threshold == wcthr ~ eval(parse(text = wccau)),
        class %in% c('3M', '2') & tn_threshold == pethr ~ eval(parse(text = pecau))
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
        !is.na(`4`) & `4` > 0 ~ 'Act',
        !is.na(`3`) & `3` > 0 ~ 'Investigate',
        !is.na(`2`) & `2` > 2 ~ 'Caution',
        is.na(`1`) & is.na(`2`) & is.na(`3`) & is.na(`4`) ~ 'No Data',
        T ~ 'Target'
      ),
      score = dplyr::case_when(
        score == 'Act' & class %in% c('3F', '1') & `4` == 1 & `3` > 1 ~ 'Investigate',
        score == 'Act' & class %in% c('3F', '1') & `4` == 1 & `1` > 3 ~ 'Target',
        T ~ score
      ),
      score = dplyr::case_when(
        score == 'Investigate' & class %in% c('3F', '1') & `3` == 1 & `1` > 3 ~ 'Target',
        T ~ score
      ),
      score = dplyr::case_when(
        score == 'Act' & class %in% c('3M', '2') & (`4` == 1 & sum(`1`, `2`, `3`, na.rm = T) > 2) ~ 'Investigate',
        T ~ score
      ),
      score = dplyr::case_when(
        score == 'Investigate' & class %in% c('3M', '2') & (`3` == 1 & sum(`1`, `2`, na.rm = T) > 1) ~ 'Caution',
        T ~ score
      )
    ) %>%
    tidyr::as_tibble() %>%
    dplyr::select(id, wbid, JEI, class, target = `1`, caution = `2`, action = `3`, threshold = `4`, score)

  return(scrdat)

}
