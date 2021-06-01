#' Analyze tidal creek water quality indicators
#'
#' Estimate tidal creek water quality indicators to support report card scores
#'
#' @param tidalcreeks \code{\link[sf]{sf}} object for population of tidal creeks
#' @param iwrraw FDEP impaired waters rule run 56 data base as \code{\link{data.frame}}
#' @param yr numeric for reference year to evaluate, scores are based on the planning period beginning ten years prior to this date
#'
#' @details Annual geometric means for additional water quality data available at each wbid, JEI combination.  Florida trophic state index values are also estimated where data are available.
#'
#' Nitrogen ratios are estimated for JEIs that cover source (upstream, freshwater) and tidal (downstream) WBIDs, defined as the ratio of concentrations between the two (i.e., ratios > 1 mean source has higher concentrations).  Nitrogen ratios for a given year reflect the ratio of the median nitrogen concentrations when they were measured in both a source and tidal segment during the same day.  Note that a ratio of one can be obtained if both the source and tidal segments are at minimum detection.
#'
#' Indicators for years where more than 10\% of observations exceed DO saturation criteria are also estimated.  The \code{do_bnml} and \code{do_prop} columns show a 1 or 0 for a given year to indicate if more than ten percent of observations were below DO percent saturation of 42.  The first column is based on a binomial probability exceedance that takes into account the number of observations in the year and the second column is based on a simple proportional estimate from the raw data.
#'
#' @return A \code{\link{data.frame}} with the indicator values for each tidal creek
#' @export
#'
#' @concept analyze
#'
#' @examples
#' dat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2018)
#' head(dat)
anlz_tdlcrkindic <- function(tidalcreeks, iwrraw, yr = 2018) {

  # format iwr data
  iwrdat <- anlz_iwrraw(iwrraw, tidalcreeks, yr = yr)

  # geo means
  iwrgeo <- iwrdat %>%
    dplyr::group_by(wbid, class, JEI, year, masterCode) %>%
    dplyr::summarise(
      result = mean(result, na.rm = T),
      n = n()
    ) %>%
    dplyr::ungroup() %>%
    dplyr::filter(n >= 1) %>%
    dplyr::select(-n) %>%
    dplyr::mutate(result = exp(result)) %>%
    spread(masterCode, result)

  # left join iwrdata to creek data
  # estimate annual geometric mean indicators
  alldat <- tidalcreeks %>%
    sf::st_set_geometry(NULL) %>%
    dplyr::left_join(iwrgeo, by = c('wbid', 'JEI', 'class')) %>%
    dplyr::mutate(
      # tn_mark = ifelse(TN > 1.1, 1, 0),
      chla_tn_ratio = CHLAC / TN,
      tn_tp_ratio = TN / TP,
      chla_tsi = 16.8 + 14.4 * log(CHLAC),
      tn_tsi = 56 + (19.8* log(TN)),
      tn2_tsi = 10 * (5.96 + 2.15 * log (TN + 0.0001)),
      tp_tsi = (18.6 * log(TP * 1000)) - 18.4,
      tp2_tsi = 10 * (2.36 * log(TP * 1000) - 2.38),
      nut_tsi = dplyr::case_when(
        tn_tp_ratio < 10 ~ tn2_tsi,
        tn_tp_ratio >= 10 & tn_tp_ratio < 30 ~ (tn_tsi + tp_tsi) / 2,
        tn_tp_ratio >= 30 ~ tp2_tsi,
        T ~ NaN
      ),
      tsi = (chla_tsi + nut_tsi) / 2
    ) %>%
    dplyr::filter(!is.na(year)) %>%
    dplyr::select(-Creek_Length_m)

  # nitrate ratio
  # done separately for each date and combined JEI
  # annual estimates are median of daily values within a year
  nitrat <- iwrdat %>%
    dplyr::filter(masterCode %in% 'NO23') %>%
    dplyr::filter(!is.na(result)) %>%
    dplyr::filter(JEI %in% unique(tidalcreeks$JEI)) %>%
    dplyr::mutate(
      result = exp(result),
      class = dplyr::case_when(
        class %in% c('3F', '1') ~ 'Source',
        class %in% c('3M', '2') ~ 'Tidal'
      )
    ) %>%
    dplyr::group_by(JEI, date, class) %>%
    summarise(result = mean(result, na.rm = T)) %>%
    dplyr::ungroup() %>%
    tidyr::spread(class, result) %>%
    dplyr::mutate(
      year = as.numeric(strftime(date, '%Y'))
    ) %>%
    na.omit %>%
    dplyr::group_by(JEI, year) %>%
    summarise(
      no23_source = median(Source, na.rm = T),
      no23_tidal = median(Tidal, na.rm = T),
      .groups = 'drop'
      ) %>%
    mutate(
      no23_ratio = no23_source / no23_tidal
    )

  # estimate DO exceedance
  # returns a column do_bnml as dep method based on likelihood of obs dosat < 42 in a given year
  # returns a column do_prop as straight calc of proportion of days with dosat < 42 in a given year
  do_exceed <- iwrraw %>%
    dplyr::filter(masterCode %in% c('DO','DOSAT','TEMP','SALIN')) %>%
    dplyr::group_by(class, JEI, wbid, sta, year, month, day, masterCode) %>%
    dplyr::summarise(
      result = mean(result, na.rm = T),
      .groups = 'drop'
      ) %>%
    dplyr::ungroup() %>%
    tidyr::spread(masterCode, result) %>%
    dplyr::filter(!is.na(DOSAT))%>%
    dplyr::mutate(
      do_cnt = dplyr::case_when(
        DOSAT < 42 ~ 1,
        DOSAT >= 42 ~ 0
        )
      ) %>%
    dplyr::group_by(JEI,wbid,year) %>%
    dplyr::summarise(
      cnt = n(),
      DOSAT_prop = mean(do_cnt, na.rm = T),
      .groups = 'drop'
      ) %>%
    dplyr::mutate(
      xcd = DOSAT_prop * cnt,
      bnml = 1 - pbinom(xcd - 1, cnt, 0.1),
      do_bnml = dplyr::case_when(
        bnml < 0.10 ~ 1,
        bnml >= 0.1 ~ 0
        ),
      do_prop = dplyr::case_when(
        DOSAT_prop > 0.1 ~ 1,
        DOSAT_prop <= 0.1 ~ 0)
      ) %>%
    dplyr::select(JEI, wbid, year, do_bnml, do_prop)

  # join nitrogen ratio data to all other data by JEI (same value applies to JEI across wbids)
  out <- alldat %>%
    dplyr::full_join(nitrat, by = c('JEI', 'year')) %>%
    dplyr::left_join(do_exceed, by = c('JEI', 'wbid', 'year'))

  return(out)

}
