#' Format water quality data
#'
#' @param epcdata input \code{data.frame} returned from \code{\link{load_epchc_wq}}
#'
#' @return A lightly formatted \code{data.frame} with chloropyll and secchi observations
#' @export
#'
#' @importFrom magrittr %>%
#'
#' @details Secchi data VOB depths or secchis < 0.5 ft from bottom are assigned \code{NA}
#'
#' @examples
#' \dontrun{
#' xlsx <- 'C:/Users/Owner/Desktop/2018_Results_Updated.xls'
#' epcdata <- load_epchc_wq(xlsx) %>%
#'   form_epch_wq
#' }
form_epchc_wq <- function(epcdata){

  # format
  out <- epcdata %>%
    dplyr::mutate(
      epchc_station = as.numeric(Station_Number),
      sd_m = as.numeric(Secchi_Depth_m),
      sd_check = as.numeric((Total_Depth_m*3.2809)-(Secchi_Depth_m*3.2809)),
      sd_m = dplyr::case_when(
        Secchi_Q == ">" ~ NaN,
        sd_check < 0.5 ~ NaN,
        T ~ sd_m
        ),
      chla = as.numeric(`Chlorophyll_a uncorr_ugL`),
      yr = lubridate::year(SampleTime),
      mo = lubridate::month(SampleTime)
      ) %>%
    dplyr::inner_join(stations, by = 'epchc_station') %>%
    dplyr::select(
      bay_segment,
      epchc_station,
      SampleTime,
      yr,
      mo,
      Latitude,
      Longitude,
      SampleTime,
      Total_Depth_m,
      Sample_Depth_m,
      sd_m,
      chla
    )

  return(out)

}
