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
anlz_sedimentave <- function(sedimentdata, param, yrrng = c(1993, 2021), bay_segment = c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB'), funding_proj = 'TBEP'){

  # check bay segments
  chk <- !bay_segment %in% c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')
  if(any(chk)){
    msg <- bay_segment[chk]
    stop('bay_segment input is incorrect: ', paste(msg, collapse = ', '))
  }

  # make yrrng two if only one year provided
  if(length(yrrng) == 1)
    yrrng <- rep(yrrng, 2)

  # yrrng must be in ascending order
  if(yrrng[1] > yrrng[2])
    stop('yrrng argument must be in ascending order, e.g., c(1993, 2017)')

  # yrrng not in sedimentdata
  if(any(!yrrng %in% sedimentdata$yr))
    stop(paste('Check yrrng is within', paste(range(sedimentdata$yr, na.rm = TRUE), collapse = '-')))

  # check if param is in data
  params <- sedimentdata$Parameter %>%
    unique %>%
    sort
  chk <- !param %in% params
  if(chk)
    stop(param, ' not found in Parameter column')

  # check funding project
  chk <- !funding_proj %in% c('TBEP', 'TBEP-Special', 'Apollo Beach', 'Janicki Contract', 'Rivers', 'Tidal Streams')
  if(any(chk)){
    msg <- funding_proj[chk]
    stop('funding_proj input is incorrect: ', paste(msg, collapse = ', '))
  }

  levs <- c('HB', 'OTB', 'MTB', 'LTB', 'TCB', 'MR', 'BCB')

  # summarize
  out <- sedimentdata %>%
    dplyr::filter(Parameter %in% !!param) %>%
    dplyr::filter(yr >= yrrng[1] & yr <= yrrng[2]) %>%
    dplyr::filter(FundingProject %in% funding_proj) %>%
    dplyr::filter(Replicate == 'no') %>%
    dplyr::filter(AreaAbbr %in% bay_segment) %>%
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
