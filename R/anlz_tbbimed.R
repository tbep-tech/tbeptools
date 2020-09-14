#' Get annual medians of Tampa Bay Benthic Index scores by bay segment
#'
#' @param tbbiscr input data frame as returned by \code{\link{anlz_tbbiscr}}
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"
#' @param rev logical if factor levels for bay segments are reversed
#' @param yrrng numeric indicating year ranges to evaluate
#'
#' @return A data frame of annual medians by bay segment
#' @export
#'
#' @family anlz
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' tbbiscr <- anlz_tbbiscr(benthicdata)
#' anlz_tbbimed(tbbiscr)
anlz_tbbimed <- function(tbbiscr, bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), rev = FALSE, yrrng = c(1993, 2018)) {

  # sanity checks
  stopifnot(length(yrrng) == 2)
  stopifnot(yrrng[1] < yrrng[2])

  # bay segment factor levels
  levs <- c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')
  if(rev)
    levs <- rev(levs)

  st_crs(tbsegshed) <- 4326

  out <- tbbiscr %>%
    sf::st_as_sf(
      coords = c("Longitude", "Latitude"),
      crs = 4326
    ) %>%
    sf::st_join(tbsegshed, join = sf::st_within) %>%
    dplyr::filter(!is.na(bay_segment)) %>%
    dplyr::filter(yr <= yrrng[2] & yr >= yrrng[1]) %>%
    sf::st_set_geometry(NULL) %>%
    dplyr::filter(TBBI >= 0 & TBBI <= 100) %>%
    dplyr::group_by(bay_segment, yr) %>%
    dplyr::summarise(TBBI = median(TBBI, na.rm = T), .groups = 'drop') %>%
    dplyr::mutate(
      TBBICat = dplyr::case_when(
        TBBI < 73 ~ 'Degraded',
        TBBI >= 73 & TBBI < 87 ~ 'Intermediate',
        TBBI >= 87 ~ 'Healthy',
        T ~ NA_character_
      ),
      TBBICat = factor(TBBICat, levels = c('Degraded', 'Intermediate', 'Healthy'), labels = c('Poor', 'Fair', 'Good')),
      bay_segment = factor(bay_segment, levels = levs)
    ) %>%
    dplyr::filter(bay_segment %in% !!bay_segment)

  # toest <- tomap %>%
  #   st_set_geometry(NULL) %>%
  #   filter(TBBI >= 0 & TBBI <= 100) %>%
  #   group_by(bay_segment, yr, TBBICat) %>%
  #   summarise(cnt = n(), .groups = 'drop') %>%
  #   filter(TBBICat != 'Empty Sample') %>%
  #   group_by(yr, bay_segment) %>%
  #   mutate(per = cnt / sum(cnt)) %>%
  #   ungroup() %>%
  #   select(-cnt) %>%
  #   spread(TBBICat, per, fill = 0) %>%
  #   rowwise() %>%
  #   mutate(
  #     TBBICat = case_when(
  #       Degraded < 0.1 & Healthy >= 0.5 ~ 'Good',
  #       Degraded >= 0.2 ~ 'Poor',
  #       (Degraded >= 0.1 & Degraded < 0.25) ~ 'Fair',
  #       sum(Degraded, Intermediate) > 0.5 ~ 'Fair'
  #
  #     ),
  #     TBBICat = factor(TBBICat, levels = c('Poor', 'Fair', 'Good'), labels = c('Poor', 'Fair', 'Good')),
  #     bay_segment = factor(bay_segment, levels = levs)
  #   ) %>%
  #   dplyr::filter(bay_segment %in% !!bay_segment)

  return(out)

}
