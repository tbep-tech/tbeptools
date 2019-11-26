#' @title Get attainment categories for a chosen year
#'
#' @description Get attainment categories for a chosen year
#'
#' @param epcdata data frame of epc data returned by \code{\link{read_importwq}}
#' @param yrsel numeric indicating chosen year
#'
#' @return A \code{data.frame} for the chosen year and all bay segments showing the bay segment averages for chloropyll concentration, light attenuations, segment targets, and attainment categories.
#'
#' @export
#'
#' @family analyze
#'
#' @examples
#'
#' # defaults to current year
#' anlz_yrattain(epcdata, yrsel = 2018)
anlz_yrattain <- function(epcdata, yrsel){

  # segment averages
  segave <- epcdata %>%
    anlz_avedat

  # sanity check
  if(!yrsel %in% epcdata$yr)
    stop(paste('Check yrsel is within', paste(range(segave$ann$yr, na.rm = TRUE), collapse = '-')))

  # get segment averages, targets for yrsel, wide format
  vals <- segave %>%
    anlz_attain(magdurout = T) %>%
    dplyr::filter(yr %in% yrsel) %>%
    dplyr::select(bay_segment, var, val, target) %>%
    tidyr::gather('nums', 'est', val, target) %>%
    tidyr::unite('var', var, nums) %>%
    dplyr::mutate(
      var = factor(var, levels = c('chla_val', 'chla_target', 'la_val', 'la_target'))
    ) %>%
    tidyr::spread(var, est)

  # get attainment categories
  cats <- segave %>%
    anlz_attain %>%
    dplyr::filter(yr %in% yrsel) %>%
    dplyr::select(bay_segment, outcome)

  # join, minor formatting for output
  out <- vals %>%
    dplyr::left_join(cats, by = 'bay_segment') %>%
    dplyr::mutate(
      bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB'))
    ) %>%
    dplyr::arrange(bay_segment)

  return(out)

}
