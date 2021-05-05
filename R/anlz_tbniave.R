#' Get annual averages of Tampa Bay Nekton Index scores by bay segment
#'
#' @param tbniscr input data frame as returned by \code{\link{anlz_tbniscr}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB"
#' @param rev logical if factor levels for bay segments are reversed
#' @param perc numeric values indicating break points for score categories
#'
#' @return A data frame of annual averages by bay segment
#' @export
#'
#' @concept analyze
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' tbniscr <- anlz_tbniscr(fimdata)
#' anlz_tbniave(tbniscr)
anlz_tbniave <- function(tbniscr, bay_segment = c('OTB', 'HB', 'MTB', 'LTB'), rev = FALSE,  perc = c(32, 46)) {

  # sanity checks
  stopifnot(length(perc) == 2)
  stopifnot(perc[1] < perc[2])
  stopifnot(perc[1] > 22)
  stopifnot(perc[2] < 58)

  # bay segment factor levels
  levs <- c("OTB", "HB", "MTB", "LTB")
  if(rev)
    levs <- rev(levs)

  # annual averages by segment
  out <- tbniscr %>%
    dplyr::group_by(bay_segment, Year) %>%
    dplyr::summarize(Segment_TBNI = round(mean(TBNI_Score),0)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = levs)
    ) %>%
    dplyr::filter(bay_segment %in% !!bay_segment) %>%
    dplyr::mutate(
      Action = findInterval(Segment_TBNI, perc),
      outcome = factor(Action, levels = c('0', '1', '2'), labels = c('red', 'yellow', 'green')),
      outcome = as.character(outcome),
      Action = factor(Action, levels = c('0', '1', '2'), labels = c('On Alert', 'Caution', 'Stay the Course'))
    )

  return(out)

}
