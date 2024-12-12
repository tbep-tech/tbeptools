#' Get average concentrations for a sediment parameter by bay segment
#'
#' Get average concentrations for a sediment parameter by bay segment
#'
#' @param sedimentdata input sediment \code{data.frame} as returned by \code{\link{read_importsediment}}
#' @param param chr string for which parameter to plot
#' @param yrrng numeric vector indicating min, max years to include, use single year for one year of data
#' @param bay_segment chr string for the bay segment, one to many of "HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"
#' @param funding_proj chr string for the funding project, one to many of "TBEP" (default), "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal Streams"
#'
#' @return A \code{data.frame} object with average sediment concentrations for the selected parameter by bay segment
#' @export
#'
#' @concept anlz
#'
#' @details Summaries for all bay segments are returned by default. The averages and confidence intervals are specific to the year ranges in \code{yrrng}.
#'
#' @seealso \code{\link{show_sedimentave}}
#'
#' @examples
#' anlz_sedimentave(sedimentdata, param = 'Arsenic')
anlz_sedimentave <- function(sedimentdata, param, yrrng = c(1993, 2023), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP'){

  # add totals
  sedimentdata <- anlz_sedimentaddtot(sedimentdata, yrrng = yrrng, bay_segment = bay_segment,
                                      funding_proj = funding_proj, param = param, pelave = FALSE)

  levs <- c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')

  # summarize
  out <- sedimentdata %>%
    dplyr::group_by(AreaAbbr, TEL, PEL, Units) %>%
    dplyr::summarize(
      ave = mean(ValueAdjusted, na.rm = T),
      lov = tryCatch(t.test(ValueAdjusted)$conf.int[1], error = function(x) NA),
      hiv = tryCatch(t.test(ValueAdjusted)$conf.int[2], error = function(x) NA),
      .groups = 'drop'
    ) %>%
    mutate(
      AreaAbbr = factor(AreaAbbr, levels = levs),
      grandave = mean(ave, na.rm = T)
      )

  return(out)

}
