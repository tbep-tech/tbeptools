#' Format water quality data
#'
#' @param datin input \code{data.frame} loaded from \code{\link{read_importwq}}
#'
#' @return A lightly formatted \code{data.frame} with chloropyll and secchi observations
#' @export
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @details Secchi data VOB depths or secchis < 0.5 ft from bottom are assigned \code{NA}, function is used internally within \code{\link{read_importwq}}
#'
#' @seealso \code{\link{read_importwq}}
#'
#' @examples
#' \dontrun{
#' # file path
#' xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
#'
#' # load and assign to object
#' epcdata <- read_importwq(xlsx, download_latest = T)
#' }
read_formwq <- function(datin){

  stations <- stations %>%
    dplyr::select(epchc_station, bay_segment)

  # format
  out <- datin %>%
    dplyr::mutate(
      epchc_station = as.numeric(StationNumber),
      sd_m = as.numeric(SecchiDepth),
      sd_check = as.numeric((TotalDepth*3.2809)-(SecchiDepth*3.2809)),
      sd_m = dplyr::case_when(
        Secchi_Q == ">" ~ NaN,
        sd_check < 0.5 ~ NaN,
        T ~ sd_m
        ),
      chla = suppressWarnings(as.numeric(`Chlorophyll_a`)),
      tn = suppressWarnings(as.numeric(`Total_Nitrogen`)),
      yr = lubridate::year(SampleTime),
      mo = lubridate::month(SampleTime)
      ) %>%
    dplyr::inner_join(stations, by = 'epchc_station') %>%
    dplyr::select(bay_segment, epchc_station, SampleTime, yr, mo, Latitude, Longitude, SampleTime,
                  Total_Depth_m = TotalDepth, Sample_Depth_m = SampleDepth, tn, tn_q = `Total_NitrogenQ`, sd_m, sd_raw_m = SecchiDepth, sd_q = Secchi_Q, chla, chla_q = `Chlorophyll_aQ`, Sal_Top_ppth = `Sal-T`, Sal_Mid_ppth = `Sal-M`,
                  Sal_Bottom_ppth = `Sal-B`, Temp_Water_Top_degC = `TempWater-T`, Temp_Water_Mid_degC = `TempWater-M`, Temp_Water_Bottom_degC = `TempWater-B`, `Turbidity_JTU-NTU` = Turbidity, Turbidity_Q = TurbidityQ,
                  Color_345_F45_PCU = `Color345_F45`, Color_345_F45_Q = `Color345_F45Q`
    )

  return(out)

}
