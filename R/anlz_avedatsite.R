#' Estimate annual means by site
#'
#' Estimate annual means by site for chlorophyll and secchi data
#'
#' @param epcdata \code{data.frame} formatted from \code{read_importwq}
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#'
#'
#' @return Mean estimates for chlorophyll and secchi
#'
#' @family analyze
#'
#' @import dplyr tidyr
#'
#' @export
#'
#' @examples
#' # view average estimates
#' anlz_avedatsite(epcdata)
anlz_avedatsite <- function(epcdata, partialyr = FALSE){

  # year month averages
  # long format, separate bay_segment for MTB into sub segs
  # mtb year month averages are weighted
  moout <- epcdata %>%
    dplyr::select(yr, mo, bay_segment, epchc_station, chla, sd_m) %>%
    tidyr::gather('var', 'val', chla, sd_m) %>%
    tidyr::drop_na() %>%
    dplyr::group_by(bay_segment, epchc_station, yr, mo, var) %>%
    dplyr::summarise(val = mean(val)) %>%
    dplyr::ungroup() %>%
    dplyr::filter(!is.na(val)) %>%
    dplyr::filter(!is.infinite(val)) %>%
    dplyr::arrange(var, yr, mo, bay_segment)

  # add partial year
  if(partialyr){

    # years to averge, last five complete
    maxyr <- max(moout$yr)
    yrfl <- c(maxyr - 5, maxyr - 1)

    # months to fill
    mofl <- moout %>%
      dplyr::filter(yr %in% maxyr) %>%
      dplyr::pull(mo) %>%
      unique %>%
      setdiff(1:12, .)

    # month averages
    moave <- moout %>%
      dplyr::filter(yr >= yrfl[1] & yr <= yrfl[2]) %>%
      dplyr::group_by(bay_segment, epchc_station, mo, var) %>%
      summarise(val = mean(val, na.rm = TRUE)) %>%
      dplyr::filter(mo %in% mofl) %>%
      dplyr::mutate(yr = maxyr)

    # join missing months to
    moout <- moout %>%
      dplyr::bind_rows(moave) %>%
      dplyr::arrange(var, yr, mo, bay_segment)

  }

  # annual data
  anout <- moout %>%
    dplyr::group_by(yr, bay_segment, epchc_station, var) %>%
    dplyr::summarise(val = mean(val)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      var = dplyr::case_when(
        var == 'chla' ~ 'mean_chla',
        TRUE ~ var
      )
    ) %>%
    tidyr::spread('var', 'val') %>%
    dplyr::rename(
      mean_sdm = sd_m
    ) %>%
    dplyr::mutate(
      mean_la = dplyr::case_when(
        bay_segment %in% "OTB" ~ 1.49 / mean_sdm,
        bay_segment %in% "HB" ~ 1.61 / mean_sdm,
        bay_segment %in% "MTB" ~ 1.49 / mean_sdm,
        bay_segment %in% "LTB" ~ 1.84 / mean_sdm,
        TRUE ~ mean_sdm
      )
    ) %>%
    tidyr::gather('var', 'val', mean_chla, mean_la, mean_sdm) %>%
    dplyr::filter(!is.na(val)) %>%
    dplyr::filter(!is.infinite(val)) %>%
    dplyr::arrange(var, yr, bay_segment)

  # mo dat to light attenuation
  moout <- moout %>%
    dplyr::mutate(
      var = dplyr::case_when(
        var == 'chla' ~ 'mean_chla',
        var == 'sd_m' ~ 'mean_la'
      ),
      val = dplyr::case_when(
        bay_segment %in% "OTB" & var == 'mean_la' ~ 1.49 / val,
        bay_segment %in% "HB" & var == 'mean_la' ~ 1.61 / val,
        bay_segment %in% "MTB" & var == 'mean_la' ~ 1.49 / val,
        bay_segment %in% "LTB" & var == 'mean_la' ~ 1.84 / val,
        TRUE ~ val
      )
    )

  # combine all
  out <- list(
    ann = anout,
    mos = moout
  )

  return(out)

}
