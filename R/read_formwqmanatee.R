#' Format water quality and station metadata for Manatee County
#'
#' @param res A data frame containing water quality results obtained from the API
#' @param sta A data frame containing station metadata obtained from the API
#' @param trace Logical indicating whether to display progress messages, default is \code{FALSE}
#'
#' @return A data frame containing formatted water quality and station metadata for Manatee County.
#'
#' @details This function is used by \code{\link{read_importwqmanatee}} to combine, format, and process water quality data (\code{res}) and station metadata (\code{sta}) obtained from the Water Quality Data Exchange API for Manatee County. The resulting data frame includes the date, time, station identifier, latitude, longitude, variable name, value, unit, and quality flag.
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @seealso \code{\link{read_importwqmanatee}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' url <- list(
#'   Result = "https://www.waterqualitydata.us/data/Result/search?mimeType=csv&zip=no",
#'   Station = "https://www.waterqualitydata.us/data/Station/search?mimeType=csv&zip=no"
#' )
#'
#' headers <- c(
#'   "Content-Type" = "application/json",
#'   "Accept" = "application/zip"
#' )
#'
#' body <- list(
#'   organization = c("21FLMANA_WQX"),
#'   sampleMedia = c("Water"),
#'   characteristicType = c("Information", "Nutrient", "Biological, Algae, Phytoplankton,
#'     Photosynthetic Pigments"),
#'   providers = c("STORET"),
#'   siteType = c("Estuary")#,
#'   # ActivityTypeCode = c("Field Msr/Obs", "Sample-Routine")
#' )
#'
#' res <- url[['Result']] %>%
#'   httr::POST(httr::add_headers(headers), body = jsonlite::toJSON(body)) %>%
#'   httr::content('text') %>%
#'   read.csv(text = .)
#'
#' sta <- url[['Station']] %>%
#'   httr::POST(httr::add_headers(headers), body = jsonlite::toJSON(body)) %>%
#'   httr::content('text') %>%
#'   read.csv(text = .)
#'
#' # combine and format
#' read_formwqmanatee(res, sta)
#'}
read_formwqmanatee <- function(res, sta, trace = F){

  if(trace)
    cat('Combining and formatting output...\n')

  # format water quality
  resfrm <- res %>%
    dplyr::select(date = ActivityStartDate, type = ActivityTypeCode, time = ActivityStartTime.Time,
                  ident = MonitoringLocationIdentifier, var = CharacteristicName, val = ResultMeasureValue,
                  uni = ResultMeasure.MeasureUnitCode)

  # format station metadata
  stafrm <- sta %>%
    dplyr::select(ident = MonitoringLocationIdentifier,
                  lat = LatitudeMeasure, lon = LongitudeMeasure,
                  datum = HorizontalCoordinateReferenceSystemDatumName
    ) %>%
    dplyr::mutate(
      epsg = case_when(
        datum == 'WGS84' ~ 4326,
        datum == 'NAD83' ~ 4269,
        datum == 'NAD27' ~ 4267
      )
    )

  # combine and process
  out <- resfrm %>%
    dplyr::left_join(stafrm, by = 'ident') %>%
    dplyr::filter(type %in% c('Field Msr/Obs', 'Sample-Routine')) %>%
    dplyr::filter(!var %in% c('Nitrate', 'Depth')) %>% # only kept no23
    dplyr::filter(!val %in% '*Not Reported') %>%
    dplyr::mutate(
      time = ifelse(time == '', '00:00:00', time)
    ) %>%
    unite('SampleTime', date, time, sep = ' ') %>%
    dplyr::mutate(
      station = gsub('^.*\\-(.*$)', '\\1', ident),
      SampleTime = lubridate::ymd_hms(SampleTime, tz = 'America/Jamaica'),
      yr = lubridate::year(SampleTime),
      mo = lubridate::month(SampleTime),
      var = dplyr::case_when(
        grepl('Nitri|Nitra', var) ~ 'no23',
        grepl('Ammonia', var) ~ 'nh34',
        grepl('^Chlorophyll a, corrected', var) ~ 'chla_corr',
        grepl('^Chlorophyll a, free', var) ~ 'chla_uncorr',
        grepl('Secchi', var) ~ 'secchi',
        grepl('Kjeldahl', var) ~ 'tkn',
        grepl('Phosphorus', var) ~ 'tp',
        grepl('Orthophosphate', var) ~ 'orthop'
      ),
      uni = case_when(
        uni == 'mg/m3' ~ 'ugl',
        uni == 'mg/L' ~ 'mgl',
        T ~ uni
      ),
      qual = ifelse(val == '*Non-detect', 'U', NA_character_),
      val = ifelse(val == '*Non-detect', '', val),
      val = as.numeric(val)
    ) %>%
    tidyr::nest(.by = datum) %>%
    dplyr::mutate(
      data = purrr::map(data, function(x){

        sf::st_as_sf(x, coords = c('lon', 'lat'), crs = unique(x$epsg), remove = F) %>%
          sf::st_transform(crs = 4326)

      })
    ) %>%
    tidyr::unnest('data') %>%
    sf::st_as_sf() %>%
    sf::st_set_geometry(NULL) %>%
    select(manco_station = station, SampleTime, yr, mo, Latitude = lat, Longitude = lon, var, val, uni, qual)

  return(out)

}
