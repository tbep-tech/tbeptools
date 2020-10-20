#' Get annual medians of Tampa Bay Benthic Index scores by bay segment
#'
#' @param tbbiscr input data frame as returned by \code{\link{anlz_tbbiscr}}
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB", "All", "All (wt)"
#' @param rev logical if factor levels for bay segments are reversed
#' @param yrrng numeric indicating year ranges to evaluate
#'
#' @return A data frame of annual medians by bay segment
#' @export
#'
#' @details
#' Additional summaries are provided for the entire bay, as a summary across categories ("All") and a summary weighted across the relative sizes of each bay segment ("All (wt)").
#'
#' @family analyze
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' tbbiscr <- anlz_tbbiscr(benthicdata)
#' anlz_tbbimed(tbbiscr)
anlz_tbbimed <- function(tbbiscr, bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB',  'All', 'All (wt)'), rev = FALSE, yrrng = c(1993, 2018)) {

  # sanity checks
  stopifnot(length(yrrng) == 2)
  stopifnot(yrrng[1] < yrrng[2])

  # bay segment factor levels
  levs <- c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB', 'All', 'All (wt)')
  if(rev)
    levs <- rev(levs)

  # bay segment area percentages, for weighting
  wts <- tibble(
    bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'),
    wts = c(0.1042, 0.1964, 0.3028, 0.2470, 0.0163, 0.0406, 0.0925)
  )

  st_crs(tbsegshed) <- 4326

  # percent sites in category, by bay segment, year
  perc <- tbbiscr %>%
    sf::st_as_sf(
      coords = c("Longitude", "Latitude"),
      crs = 4326
    ) %>%
    sf::st_join(tbsegshed, join = sf::st_within) %>%
    dplyr::filter(!is.na(bay_segment)) %>%
    dplyr::filter(yr <= yrrng[2] & yr >= yrrng[1]) %>%
    st_set_geometry(NULL) %>%
    filter(TBBI >= 0 & TBBI <= 100) %>%
    group_by(bay_segment, yr, TBBICat) %>%
    summarise(cnt = n(), .groups = 'drop') %>%
    # filter(TBBICat != 'Empty Sample') %>%
    group_by(yr, bay_segment) %>%
    mutate(
      n = sum(cnt),
      per = cnt / n
      ) %>%
    ungroup()

  # bay average, non-weighted, weighted
  baycat <- perc %>%
    left_join(wts, by = 'bay_segment') %>%
    group_by(yr) %>%
    mutate(
      grndn = sum(cnt),
      nwts = grndn * wts,
      cntwts = nwts * cnt,
      total = sum(cntwts)
      ) %>%
    group_by(yr, TBBICat, total, grndn) %>%
    summarise(
      tbbicatwt = sum(cntwts, na.rm = T),
      tbbicatid = sum(cnt, na.rm = T),
      .groups = 'drop'
    ) %>%
    mutate(
      All = tbbicatid / grndn,
      `All (wt)` = tbbicatwt / total
    ) %>%
    select(yr, TBBICat, `All (wt)`, All) %>%
    gather('bay_segment', 'per', -yr, -TBBICat)

  # segment categories
  out <- perc %>%
    select(-cnt, -n) %>%
    bind_rows(baycat) %>%
    spread(TBBICat, per, fill = 0) %>%
    rowwise() %>%
    mutate(
      TBBICat = case_when(
        sum(Degraded, `Empty Sample`) >= 0.2 ~ 'Poor',
        (sum(Degraded, `Empty Sample`) < 0.2 & sum(Degraded, `Empty Sample`) > 0.1) | sum(Degraded, Intermediate) > 0.5 ~ 'Fair',
        sum(Degraded, `Empty Sample`) < 0.1 & Healthy > 0.5 ~ 'Good'
      ),
      TBBICat = factor(TBBICat, levels = c('Poor', 'Fair', 'Good'), labels = c('Poor', 'Fair', 'Good')),
      bay_segment = factor(bay_segment, levels = levs)
    ) %>%
    dplyr::filter(bay_segment %in% !!bay_segment)

  return(out)

}
