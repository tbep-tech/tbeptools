#' Estimate annual means
#'
#' Estimate annual means for chlorophyll and secchi data
#'
#' @param epcdata \code{data.frame} formatted from \code{read_importwq}
#' @param yrrng numeric vector indicating min, max years to include
#' @param partialyr logical indicating if incomplete annual data for the most recent year are approximated by five year monthly averages for each parameter
#'
#'
#' @return Mean estimates for chlorophyll and secchi
#'
#' @family analyze
#'
#' @import dplyr tidyr
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' # view average estimates
#' anlz_avedat(epcdata)
anlz_avedat <- function(epcdata, yrrng, partialyr){

  # year month averages
  # long format, separate bay_segment for MTB into sub segs
  # mtb year month averages are weighted
  moout <- epcdata %>%
    dplyr::select(yr, mo, bay_segment, epchc_station, chla, sd_m) %>%
    tidyr::gather('var', 'val', chla, sd_m) %>%
    dplyr::mutate(
      bay_segment = dplyr::case_when(
        epchc_station %in% c(9, 11, 81, 84) ~ "MT1",
        epchc_station %in% c(13, 14, 32, 33) ~ "MT2",
        epchc_station %in% c(16, 19, 28, 82) ~ "MT3",
        TRUE ~ bay_segment
      )
    ) %>%
    dplyr::group_by(bay_segment, yr, mo, var) %>%
    dplyr::summarise(val = mean(val, na.rm = TRUE)) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      val = dplyr::case_when(
        bay_segment %in% "MT1" ~ val * 2108.7,
        bay_segment %in% "MT2" ~ val * 1041.9,
        bay_segment %in% "MT3" ~ val * 974.6,
        TRUE ~ val
        ),
      bay_segment = dplyr::case_when(
        bay_segment %in% c('MT1', 'MT2', 'MT3') ~ 'MTB',
        TRUE ~ bay_segment
      )
    ) %>%
    dplyr::group_by(bay_segment, yr, mo, var) %>%
    dplyr::summarise(
      val = sum(val, na.rm = T)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(
      val = dplyr::case_when(
        bay_segment %in% 'MTB' ~ val / 4125.2,
        TRUE ~ val
      ),
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
    ) %>%
    dplyr::filter(!is.na(val)) %>%
    dplyr::filter(!is.infinite(val)) %>%
    dplyr::arrange(var, yr, mo, bay_segment)

  # annual data
  anout <- moout %>%
    dplyr::group_by(yr, bay_segment, var) %>%
    dplyr::summarise(val = mean(val, na.rm = TRUE)) %>%
    dplyr::ungroup() %>%
    dplyr::filter(!is.na(val)) %>%
    dplyr::filter(!is.infinite(val)) %>%
    dplyr::arrange(var, yr, bay_segment)

  # combine all
  out <- list(
    ann = anout,
    mos = moout
  )

  return(out)

}
