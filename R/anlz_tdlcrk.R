#' Estimate tidal creek report card scores
#'
#' Estimate tidal creek report card scores
#'
#' @param tidalcreeks \code{\link[sf]{sf}} object for population of tidal creeks
#' @param iwrraw FDEP impaired waters data base as \code{\link{data.frame}}
#' @param tidtrgs optional \code{data.frame} for tidal creek nitrogen targets, defaults to \code{\link{tidaltargets}}
#' @param yr numeric for reference year to evaluate, scores are based on the planning period beginning ten years prior to this date
#'
#' @return A \code{\link{data.frame}} with the report card scores for each creek, as prioritize, investigate, caution, monitor, or no data
#' @export
#'
#' @concept analyze
#'
#' @examples
#' anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2021)
anlz_tdlcrk <- function(tidalcreeks, iwrraw, tidtrgs = NULL, yr = 2021) {

  # default targets from data file
  if(is.null(tidtrgs))
    tidtrgs <- tidaltargets

  # get targets
  wcpri <- tidtrgs %>%
    dplyr::filter(region == 'West Central') %>%
    dplyr::pull(prioritize)
  wcinv <- tidtrgs %>%
    dplyr::filter(region == 'West Central') %>%
    dplyr::pull(investigate)
  wccau <- tidtrgs %>%
    dplyr::filter(region == 'West Central') %>%
    dplyr::pull(caution)
  pepri <- tidtrgs %>%
    dplyr::filter(region == 'Peninsula') %>%
    dplyr::pull(prioritize)
  peinv <- tidtrgs %>%
    dplyr::filter(region == 'Peninsula') %>%
    dplyr::pull(investigate)
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

  # left join iwrdata to creek data and add TN thresholds, cautions, and prioritize values
  # grade is the count of the number of times in the past ten year period that TN exceeded one of these values
  alldat <- tidalcreeks %>%
    sf::st_set_geometry(NULL) %>%
    dplyr::left_join(iwrdat, by = c('wbid', 'JEI', 'class')) %>%
    dplyr::mutate(
      tn_pri = ifelse(!is.na(Creek_Length_m) & !grepl('^PC|^LC', JEI), wcpri,
        ifelse(!is.na(Creek_Length_m) & grepl('^PC|^LC', JEI), pepri,
          NA_real_
        )
      ),
      investigate = ifelse(!is.na(Creek_Length_m) & !grepl('^PC|^LC', JEI), wcinv,
        ifelse(!is.na(Creek_Length_m) & grepl('^PC|^LC', JEI), peinv,
          NA_real_
        )
      ),
      caution = ifelse(class %in% c('3M', '2') & tn_pri == wcpri, eval(parse(text = wccau)),
        ifelse(class %in% c('3M', '2') & tn_pri == pepri, eval(parse(text = pecau)),
          NA_real_
        )
      ),
      grade = ifelse(class %in% c('3F', '1') & TN > tn_pri, 4,
        ifelse(class %in% c('3F', '1') & TN <= tn_pri & investigate <= TN, 3,
          ifelse(class %in% c('3F', '1') & TN < investigate, 1,
            ifelse(class %in% c('3M', '2') & TN < caution, 1,
              ifelse(class %in% c('3M', '2') & caution <= TN & TN <= investigate, 2,
                ifelse(class %in% c('3M', '2') & investigate <= TN & TN <= tn_pri, 3,
                  ifelse(class %in% c('3M', '2') & TN > tn_pri, 4,
                    NA_integer_
                  )
                )
              )
            )
          )
        )
      )
    ) %>%
    dplyr::group_by(id, wbid, JEI, name, class, grade) %>%
    dplyr::summarise(cnt = n()) %>%
    tidyr::spread(grade, cnt, fill = 0) %>%
    dplyr::select(-`<NA>`)

  # assign categories based on grades
  scrdat <- alldat %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      score = ifelse(`4` > 0, 'Prioritize',
        ifelse(`3` > 0, 'Investigate',
          ifelse(`2` > 2, 'Caution',
            ifelse(`1` == 0 & `2` == 0 & `3` == 0 & `4` == 0, 'No Data',
              'Monitor'
            )
          )
        )
      ),
      score = ifelse(score == 'Prioritize' & class %in% c('3F', '1') & `4` == 1 & `3` > 1, 'Investigate',
        ifelse(score == 'Prioritize' & class %in% c('3F', '1') & `4` == 1 & `1` > 3, 'Monitor',
          score
        )
      ),
      score = ifelse(score == 'Investigate' & class %in% c('3F', '1') & `3` == 1 & `1` > 3, 'Monitor',
        score
      ),
      score = ifelse((score == 'Prioritize' & class %in% c('3M', '2')) & (`4` == 1 & sum(`1`, `2`, `3`, na.rm = T) > 2), 'Investigate',
        score
      ),
      score = ifelse((score == 'Investigate' & class %in% c('3M', '2') & (`4` < 1 | is.na(`4`))) & (`3` == 1 & sum(`1`, `2`, na.rm = T) > 2), 'Caution',
        score
      )
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      `1` = ifelse(`1` == 0, NA, `1`),
      `2` = ifelse(`2` == 0, NA, `2`),
      `3` = ifelse(`3` == 0, NA, `3`),
      `4` = ifelse(`4` == 0, NA, `4`),
    ) %>%
    tidyr::as_tibble() %>%
    dplyr::select(id, wbid, JEI, name, class, monitor = `1`, caution = `2`, investigate = `3`, prioritize = `4`, score)

  return(scrdat)

}
