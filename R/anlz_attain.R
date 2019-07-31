#' Get attainment categories
#'
#' Get attainment categories for each year and bay segment using chlorophyll and light attenuation
#'
#' @param avedat result returned from \code{\link{anlz_avedat}}
#'
#' @return a \code{data.frame} for each year and bay segment showing the attainment category
#' @export
#'
#' @examples
#' \dontrun{
#' avedat <- anlz_avedat(epcdata)
#' anlz_attain(avedat)
#' }
anlz_attain <- function(avedat){

  # format targets
  trgs <- targets %>%
    tidyr::gather('var', 'val', -bay_segment, -name) %>%
    tidyr::separate(var, c('var', 'trgtyp'), sep = '_') %>%
    spread(trgtyp, val) %>%
    dplyr::select(bay_segment, var, target, smallex, thresh)

  # get annual averages, join with targets
  annave <- avedat$ann %>%
    dplyr::filter(!var %in% 'mean_sdm') %>%
    dplyr::mutate(var = gsub('mean\\_', '', var)) %>%
    dplyr::left_join(trgs, by = c('bay_segment', 'var'))

  # get outcomes
  out <- annave %>%
    rowwise() %>%
    mutate(
      outcome = findInterval(val, c(target, smallex, thresh))
    ) %>%
    dplyr::select(bay_segment, yr, var, outcome) %>%
    tidyr::spread(var, outcome) %>%
    na.omit %>%
    tidyr::unite('chl_la', chla, la) %>%
    dplyr::mutate(
      outcome = dplyr::case_when(
        chl_la %in% '0_0' ~ 'green',
        chl_la %in% c('1_0', '2_0', '3_0', '0_1', '1_1', '2_1', '0_2', '1_2', '0_3') ~ 'yellow',
        chl_la %in% c('3_1', '2_2', '3_2', '1_3', '2_3', '3_3') ~ 'red'
      )
    )

  return(out)

}
