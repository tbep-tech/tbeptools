#' Get annual medians of AMBI scores by bay segment
#'
#' Get annual medians of AMBI scores by bay segment
#'
#' @param ambiscr input data frame as returned by \code{\link{anlz_ambiscr}}; the AMBI variant (conventional or Tampa Bay-specific) is detected automatically from the column names
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB", "All"
#' @param rev logical if factor levels for bay segments are reversed
#' @param yrrng numeric indicating year ranges to evaluate
#' @param window logical indicating whether to use a rolling 5-year window (default TRUE) or single year values (FALSE) for the bay segment categories, see details
#'
#' @return A data frame of annual percent composition by AMBI category and bay segment
#' @export
#'
#' @details
#' An additional summary is provided for the entire bay as an unweighted summary across categories ("All").
#'
#' Only sampling funded by TBEP and as part of the routine EPC benthic monitoring program are included in the final categories.
#'
#' The default behavior is to use a rolling five-year window to calculate the percent of sites in each AMBI category by bay segment.  This applies only to years 2005 and later, where the counts from the current year and the prior four years are summed to calculate the percentages.  This is intended to help smooth out inter-annual variability due to reduced sampling effort from 2005 to present.  If \code{window = FALSE}, then only single year values are used.
#'
#' The AMBI category column (\code{AMBICat} or \code{TBAMBICat}) is based on the adjusted AMBI score (0-10 scale) using the classification thresholds defined in \code{\link{anlz_ambiscr}}.
#'
#' @concept analyze
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' ambiscr <- anlz_ambiscr(benthicdata)
#' anlz_ambimed(ambiscr)
anlz_ambimed <- function(ambiscr,
                         bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB', 'All'),
                         rev = FALSE, yrrng = c(1993, 2024), window = TRUE) {

  if ('AMBICat' %in% names(ambiscr)) {
    cat_col <- 'AMBICat'
  } else if ('TBAMBICat' %in% names(ambiscr)) {
    cat_col <- 'TBAMBICat'
  } else {
    stop("ambiscr must contain an 'AMBICat' or 'TBAMBICat' column; run anlz_ambiscr() first.")
  }

  stopifnot(length(yrrng) == 2)
  stopifnot(yrrng[1] < yrrng[2])

  levs <- c('OTB', 'HB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB', 'All')
  if (rev)
    levs <- rev(levs)

  segs <- c('OTB', 'HB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')

  # category levels for AMBI (best to worst)
  cat_levs <- c('Unpolluted', 'Slightly Polluted', 'Meanly Polluted', 'Heavily Polluted', 'Extremely Polluted')

  perc <- ambiscr %>%
    dplyr::rename(bay_segment = AreaAbbr) %>%
    dplyr::filter(bay_segment %in% segs) %>%
    dplyr::filter(FundingProject %in% 'TBEP') %>%
    dplyr::filter(ProgramID %in% 4) %>%
    dplyr::filter(!is.na(.data[[cat_col]])) %>%
    dplyr::filter(.data[[cat_col]] != 'Azoic') %>%
    dplyr::group_by(bay_segment, yr, .data[[cat_col]]) %>%
    dplyr::summarise(cnt = dplyr::n(), .groups = 'drop') %>%
    dplyr::rename(AMBICat = dplyr::all_of(cat_col))

  if (window) {

    perc <- perc %>%
      tidyr::complete(bay_segment, yr = seq(min(.$yr), max(.$yr)), AMBICat, fill = list(cnt = 0)) %>%
      dplyr::group_nest(bay_segment, AMBICat) %>%
      dplyr::mutate(
        data = purrr::map(data, ~{
          dplyr::arrange(.x, yr) %>%
            dplyr::mutate(
              cntlag1 = dplyr::lag(cnt, 1),
              cntlag2 = dplyr::lag(cnt, 2),
              cntlag3 = dplyr::lag(cnt, 3),
              cntlag4 = dplyr::lag(cnt, 4),
              cntsum = cnt + dplyr::coalesce(cntlag1, 0) + dplyr::coalesce(cntlag2, 0) +
                dplyr::coalesce(cntlag3, 0) + dplyr::coalesce(cntlag4, 0),
              cnt = dplyr::case_when(
                yr >= 2005 ~ cntsum,
                TRUE ~ cnt
              )
            ) %>%
            dplyr::select(-cntlag1, -cntlag2, -cntlag3, -cntlag4, -cntsum) %>%
            dplyr::filter(cnt > 0)
        })
      ) %>%
      tidyr::unnest('data') %>%
      dplyr::arrange(bay_segment, yr, AMBICat)

  }

  perc <- perc %>%
    dplyr::group_by(yr, bay_segment) %>%
    dplyr::mutate(
      n = sum(cnt),
      per = cnt / n
    ) %>%
    dplyr::ungroup()

  baycat <- perc %>%
    dplyr::group_by(yr, AMBICat) %>%
    dplyr::summarise(cnt = sum(cnt), .groups = 'drop') %>%
    dplyr::group_by(yr) %>%
    dplyr::mutate(
      per = cnt / sum(cnt),
      bay_segment = 'All'
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(yr, AMBICat, bay_segment, per)

  out <- perc %>%
    dplyr::select(-cnt, -n) %>%
    dplyr::bind_rows(baycat) %>%
    tidyr::spread(AMBICat, per, fill = 0) %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = levs)
    ) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::filter(yr <= yrrng[2] & yr >= yrrng[1])

  return(out)

}
