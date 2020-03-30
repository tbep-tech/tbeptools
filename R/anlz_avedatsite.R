#' Estimate annual means by site
#'
#' Estimate annual means by site for chlorophyll and secchi data
#'
#' @param epcdata \code{data.frame} formatted from \code{read_importwq}
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
#' anlz_avedatsite(epcdata)
anlz_avedatsite <- function(epcdata){

  # remove MTB for initial calc
  tbdata <- epcdata #%>%
    # dplyr::filter(!bay_segment %in% 'MTB')

  # chlorophyll monthly averages
  tbmonchla <- tbdata %>%
    select(yr, mo, bay_segment, epchc_station, chla) %>%
    drop_na() %>%
    group_by(yr, mo,  epchc_station, bay_segment) %>%
    summarise(mean_chla = mean(chla)) %>%
    ungroup

  # chlorophyll annual values
  tbyrchla <- tbmonchla %>%
    select(bay_segment, epchc_station, yr, mean_chla) %>%
    drop_na() %>%
    group_by(bay_segment, epchc_station,  yr) %>%
    summarise(mean_chla = mean(mean_chla)) %>%
    ungroup

  # monthly secchi averages
  tbmonsdm <- tbdata %>%
    select(yr, mo, bay_segment, epchc_station, sd_m) %>%
    drop_na() %>%
    group_by(yr, mo, bay_segment, epchc_station) %>%
    summarise(mean_sdm = mean(sd_m)) %>%
    ungroup

  # annual secchi averages
  tbyrsdm <- tbmonsdm %>%
    select(bay_segment, epchc_station, yr, mean_sdm) %>%
    drop_na() %>%
    group_by(bay_segment, epchc_station, yr) %>%
    summarise(mean_sdm = mean(mean_sdm)) %>%
    ungroup

  # combine mtb ests with others, monthly
  chlamodata <- tbmonchla %>%
    gather('var', 'val', -yr, -mo, -bay_segment, -epchc_station)
  sdmmodata <- tbmonsdm %>%
    dplyr::mutate(
      mean_la = dplyr::case_when(
        bay_segment %in% "OTB" ~ 1.49 / mean_sdm,
        bay_segment %in% "HB" ~ 1.61 / mean_sdm,
        bay_segment %in% "MTB" ~ 1.49 / mean_sdm,
        bay_segment %in% "LTB" ~ 1.84 / mean_sdm
      )
    ) %>%
    gather('var', 'val', -yr, -mo, -bay_segment, -epchc_station) %>%
    dplyr::filter(!var %in% 'mean_sdm')
  moout <- bind_rows(chlamodata, sdmmodata)

  # combine mtb ests with others, annual
  # geisson factors for secchi depth for % light availability
  sdmdata <- tbyrsdm %>%
    mutate(
      mean_la = case_when(
        bay_segment %in% "OTB" ~ 1.49 / mean_sdm,
        bay_segment %in% "HB" ~ 1.61 / mean_sdm,
        bay_segment %in% "MTB" ~ 1.49 / mean_sdm,
        bay_segment %in% "LTB" ~ 1.84 / mean_sdm
      )
    ) %>%
    gather('var', 'val', -yr, -bay_segment, -epchc_station)
  chladata <- tbyrchla %>%
    gather('var', 'val', -yr, -bay_segment, -epchc_station)
  anout <- bind_rows(chladata, sdmdata)

  # combine all
  out <- list(
    ann = anout,
    mos = moout
  )

  return(out)

}
