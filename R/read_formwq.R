#' Format water quality data
#'
#' @param datin input \code{data.frame} loaded from \code{\link{read_importwq}}
#'
#' @return A lightly formatted \code{data.frame} with chloropyll and secchi observations
#' @export
#'
#' @family read
#'
#' @importFrom magrittr %>%
#'
#' @details Secchi data VOB depths or secchis < 0.5 ft from bottom are assigned \code{NA}, function is used internally within \code{\link{read_importwq}}
#'
#' @seealso \code{\link{read_importwq}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- 'C:/Users/Owner/Desktop/2018_Results_Updated.xls'
#'
#' # load and assign to object
#' epcdata <- read_importwq(xlsx)
#' }
read_formwq <- function(datin){

  stations <- stations %>%
    dplyr::select(epchc_station, bay_segment)

  # format
  out <- datin %>%
    dplyr::mutate(
      epchc_station = as.numeric(Station_Number),
      sd_m = as.numeric(Secchi_Depth_m),
      sd_check = as.numeric((Total_Depth_m*3.2809)-(Secchi_Depth_m*3.2809)),
      sd_m = dplyr::case_when(
        Secchi_Q == ">" ~ NaN,
        sd_check < 0.5 ~ NaN,
        T ~ sd_m
        ),
      chla = suppressWarnings(as.numeric(`Chlorophyll_a uncorr_ugL`)),
      yr = lubridate::year(SampleTime),
      mo = lubridate::month(SampleTime)
      ) %>%
    dplyr::inner_join(stations, by = 'epchc_station') %>%
    dplyr::select(bay_segment, epchc_station, SampleTime, yr, mo, Latitude, Longitude, SampleTime,
                  Total_Depth_m, Sample_Depth_m, sd_m, sd_raw_m = Secchi_Depth_m, sd_q = Secchi_Q, chla, chla_q = `Chlorophyll_a uncorr_Q`, Sal_Top_ppth, Sal_Mid_ppth,
                  Sal_Bottom_ppth
    )

  return(out)

}
