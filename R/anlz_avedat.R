#' Estimate annual means
#'
#' Estimate annual means for chlorophyll and secchi data
#'
#' @param datin \code{data.frame} formatted from \code{read_importwq}
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
#' \dontrun{
#' # view average estimates
#' anlz_avedat(epcdata)
anlz_avedat <- function(datin){

  # remove MTB for initial calc
  tbdata <- datin %>%
    dplyr::filter(!bay_segment %in% 'MTB')

  # chlorophyll monthly averages
  tbmonchla <- tbdata %>%
    select(yr, mo, bay_segment, chla) %>%
    drop_na() %>%
    group_by(yr, mo, bay_segment) %>%
    summarise(mean_chla = mean(chla)) %>%
    ungroup

  # chlorophyll annual values
  tbyrchla <- tbmonchla %>%
    select(bay_segment, yr, mean_chla) %>%
    drop_na() %>%
    group_by(bay_segment, yr) %>%
    summarise(mean_chla = mean(mean_chla)) %>%
    ungroup

  # monthly secchi averages
  tbmonsdm <- tbdata %>%
    select(yr, mo, bay_segment, sd_m) %>%
    drop_na() %>%
    group_by(yr, mo, bay_segment) %>%
    summarise(mean_sdm = mean(sd_m)) %>%
    ungroup

  # annual secchi averages
  tbyrsdm <- tbmonsdm %>%
    select(bay_segment, yr, mean_sdm) %>%
    drop_na() %>%
    group_by(bay_segment, yr) %>%
    summarise(mean_sdm = mean(mean_sdm)) %>%
    ungroup

  # process MTB data using weighted averages of 3 subsegments
  mtbdata <- datin %>%
    dplyr::filter(bay_segment %in% "MTB") %>%
    mutate(
      bay_segment = case_when(
        epchc_station %in% c(9, 11, 81, 84) ~ "MT1",
        epchc_station %in% c(13, 14, 32, 33) ~ "MT2",
        epchc_station %in% c(16, 19, 28, 82) ~ "MT3"
        )
      )

  # mtb monthly chlorophyll averages
  mtbmonchla <- mtbdata %>%
    select(yr, mo, bay_segment, chla) %>%
    drop_na() %>%
    group_by(yr, mo, bay_segment) %>%
    summarise(mean_chla = mean(chla)) %>%
    ungroup %>%
    mutate(
      chla = case_when(
        bay_segment %in% "MT1" ~ mean_chla * 2108.7,
        bay_segment %in% "MT2" ~ mean_chla * 1041.9,
        bay_segment %in% "MT3" ~ mean_chla * 974.6
      )
    )

  # mtb monthly secchi averages
  mtbmonsdm <- mtbdata %>%
    select(yr, mo, bay_segment, sd_m) %>%
    drop_na() %>%
    group_by(yr, mo, bay_segment) %>%
    summarise(mean_sd_m = mean(sd_m)) %>%
    ungroup %>%
    mutate(
      sdm = case_when(
        bay_segment %in% "MT1" ~ mean_sd_m * 2108.7,
        bay_segment %in% "MT2" ~ mean_sd_m * 1041.9,
        bay_segment %in% "MT3" ~ mean_sd_m * 974.6
      )
    )

  # mtb weighted average monthly chlorophyll
  mtbmoyrchla <- mtbmonchla %>%
    select(yr, mo, bay_segment, chla) %>%
    drop_na() %>%
    group_by(yr, mo) %>%
    summarise(sum_chla = sum(chla)) %>%
    ungroup %>%
    mutate(
      mean_chla = sum_chla / 4125.2,
      bay_segment = "MTB"
      )

  # mtb average of monthly area weighted chlorophyll
  mtbyrchla <- mtbmoyrchla %>%
    select(yr, mean_chla) %>%
    drop_na() %>%
    group_by(yr) %>%
    summarise(mean_chla = mean(mean_chla)) %>%
    ungroup %>%
    mutate(bay_segment = "MTB")

  # mtb weighted average of secchi
  mtbmoyrsdm <- mtbmonsdm %>%
    select(yr, mo, bay_segment, sdm) %>%
    drop_na() %>%
    group_by(yr, mo) %>%
    summarise(sum_sdm = sum(sdm)) %>%
    ungroup %>%
    mutate(
      mean_sdm = sum_sdm / 4125.2,
      bay_segment = "MTB"
      )

  mtbyrsdm <- mtbmoyrsdm %>%
    select(yr, mean_sdm) %>%
    drop_na() %>%
    group_by(yr) %>%
    summarise(mean_sdm = mean(mean_sdm)) %>%
    ungroup %>%
    mutate(bay_segment = "MTB")

  # combine mtb ests with others, monthly
  chlamodata <- bind_rows(tbmonchla, mtbmoyrchla) %>%
    gather('var', 'val', -yr, -mo, -bay_segment)
  sdmmodata <- bind_rows(tbmonsdm, mtbmoyrsdm) %>%
    gather('var', 'val', -yr, -mo, -bay_segment)
  moout <- bind_rows(chlamodata, sdmmodata)

  # combine mtb ests with others, annual
  # geisson factors for secchi depth for % light availability
  sdmdata <- bind_rows(tbyrsdm, mtbyrsdm) %>%
    mutate(
      mean_la = case_when(
        bay_segment %in% "OTB" ~ 1.49 / mean_sdm,
        bay_segment %in% "HB" ~ 1.61 / mean_sdm,
        bay_segment %in% "MTB" ~ 1.49 / mean_sdm,
        bay_segment %in% "LTB" ~ 1.84 / mean_sdm
        )
      ) %>%
    gather('var', 'val', -yr, -bay_segment)
  chladata <- bind_rows(tbyrchla, mtbyrchla) %>%
    gather('var', 'val', -yr, -bay_segment)
  anout <- bind_rows(chladata, sdmdata)

  # combine all
  out <- list(
    ann = anout,
    mos = moout
  )

  return(out)

}
