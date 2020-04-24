#' Get annual averages of Tampa Bay Nekton Index scores by bay segment
#'
#' @param tbniscr input dat frame as returned by \code{\link{anlz_tbniscr}}
#' @param bay_segment chr string for the bay segment, one to many of "OTB", "HB", "MTB", "LTB"
#'
#' @return A data frame of annual averages by bay segment
#' @export
#'
#' @family anlz
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' tbniscr <- anlz_tbniscr(fimdata)
#' anlz_tbniave(tbniscr)
anlz_tbniave <- function(tbniscr, bay_segment = c('OTB', 'HB', 'MTB', 'LTB')) {

  # bay segment factor levels
  levs <- c("OTB", "HB", "MTB", "LTB")

  # annual averages by segment
  out <- tbniscr %>%
    dplyr::group_by(bay_segment, Year) %>%
    dplyr::summarize(Segment_TBNI = round(mean(TBNI_Score),0)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = levs)
    ) %>%
    dplyr::filter(bay_segment %in% !!bay_segment)

  return(out)

}
