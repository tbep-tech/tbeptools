#' Get attainment categories
#'
#' Get attainment categories for each year and bay segment using chlorophyll and light attenuation
#'
#' @param avedat result returned from \code{\link{anlz_avedat}}
#' @param magdurout logical indicating if the separate magnitude and duration estimates are returned
#' @param trgs optional \code{data.frame} for annual bay segment water quality targets, defaults to \code{\link{targets}}
#'
#' @return A \code{data.frame} for each year and bay segment showing the attainment category
#' @export
#'
#' @examples
#' avedat <- anlz_avedat(epcdata)
#' anlz_attain(avedat)
anlz_attain <- function(avedat, magdurout = FALSE, trgs = NULL){

  # default targets from data file
  if(is.null(trgs))
    trgs <- targets

  # format targets
  trgs <- trgs %>%
    tidyr::gather('var', 'val', -bay_segment, -name) %>%
    tidyr::separate(var, c('var', 'trgtyp'), sep = '_') %>%
    spread(trgtyp, val) %>%
    dplyr::select(bay_segment, var, target, smallex, thresh)

  # get annual averages, join with targets
  annave <- avedat$ann %>%
    dplyr::filter(!var %in% 'mean_sdm') %>%
    dplyr::mutate(var = gsub('mean\\_', '', var)) %>%
    dplyr::left_join(trgs, by = c('bay_segment', 'var'))

  # get magnitude and durations
  magdur <- annave %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      mags = findInterval(val, c(smallex, thresh))
    ) %>%
    dplyr::ungroup() %>%
    dplyr::group_by(bay_segment) %>%
    tidyr::nest() %>%
    mutate(
      data = purrr::map(data, function(data){

        out <- data %>%
          dplyr::mutate(
            durats = stats::filter(val > target, filter = rep(1, 4), sides = 1),
            durats = as.numeric(durats)
          )

        return(out)

      })
    ) %>%
    unnest %>%
    mutate(
      outcome = dplyr::case_when(
        is.na(durats) ~ mags,
        durats == 4 & mags == 2 ~ 3L,
        T ~ mags
      )
    )

  if(magdurout)
    return(magdur)

  # get final outcomes
  out <- magdur %>%
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
