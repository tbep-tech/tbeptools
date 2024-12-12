#' Get average concentrations for a sediment parameter by bay segment
#'
#' Get average concentrations for a sediment parameter by bay segment
#'
#' @inheritParams anlz_sedimentpel
#'
#' @return  A \code{data.frame} of the average of the average PEL ratios for each bay segment
#' @export
#'
#' @concept anlz
#'
#' @details Summaries for all bay segments are returned by default. The averages and confidence intervals are specific to the year ranges in \code{yrrng}.
#'
#' @seealso \code{\link{show_sedimentpelave}}
#'
#' @examples
#' anlz_sedimentpelave(sedimentdata)
anlz_sedimentpelave <- function(sedimentdata, yrrng = c(1993, 2023), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP'){

  levs <- c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')

  out <- anlz_sedimentpel(sedimentdata, yrrng = yrrng, bay_segment = bay_segment, funding_proj = funding_proj) %>%
    dplyr::group_by(AreaAbbr) %>%
    dplyr::summarize(
      ave = mean(PELRatio, na.rm = T),
      lov = tryCatch(t.test(PELRatio)$conf.int[1], error = function(x) NA),
      hiv = tryCatch(t.test(PELRatio)$conf.int[2], error = function(x) NA),
      .groups = 'drop'
    ) %>%
    mutate(
      AreaAbbr = factor(AreaAbbr, levels = levs),
      grandave = mean(ave, na.rm = T)
    )

  return(out)

}
