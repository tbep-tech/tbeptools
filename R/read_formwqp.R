#' Format data and station metadata from the Water Quality Portal
#'
#' @param res A data frame containing results obtained from the API
#' @param sta A data frame containing station metadata obtained from the API
#' @param org chr string indicating the organization identifier
#' @param type chr string indicating data type to download, one of \code{"wq"} or \code{"fib"}
#' @param trace Logical indicating whether to display progress messages, default is \code{FALSE}
#'
#' @return A data frame containing formatted water quality and station metadata
#'
#' @details This function is used by \code{\link{read_importwqp}} to combine, format, and process data (\code{res}) and station metadata (\code{sta}) obtained from the Water Quality Portal for the selected county and data type. The resulting data frame includes the date, time, station identifier, latitude, longitude, variable name, value, unit, and quality flag.
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @seealso \code{\link{read_importwqp}}
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
#'   siteType = c("Estuary")
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
#' read_formwqp(res, sta, '21FLMANA_WQX', type = 'wq')
#'}
read_formwqp <- function(res, sta, org, type, trace = F){

  # get type
  type <- match.arg(type, c('fib', 'wq'))

  # get station column name based on county input
  stanm <- util_orgin(org, stanm = T)

  # entries for missing horizontal datums
  misdatum <- c('OTHER', 'UNKWN')

  if(trace)
    cat('Combining and formatting output...\n')

  # format station metadata
  stafrm <- sta %>%
    dplyr::select(ident = MonitoringLocationIdentifier,
                  lat = LatitudeMeasure, lon = LongitudeMeasure,
                  datum = HorizontalCoordinateReferenceSystemDatumName,
                  class = MonitoringLocationTypeName
    ) %>%
    dplyr::mutate(
      epsg = case_when(
        datum == 'WGS84' ~ 4326,
        datum == 'NAD83' ~ 4269,
        datum == 'NAD27' ~ 4267,
        datum %in% misdatum ~ 4326
      ),
      class = case_when(
        class != 'Estuary' ~ 'Fresh',
        T ~ 'Estuary'
      )
    )

  # warning for missing datum
  if(any(stafrm$datum %in% misdatum))
    warning('Missing datum information present for some stations, converted to EPSG 4326')

  # get relevant results columns, combine with stafrm
  resfrm <- res %>%
    dplyr::select(date = ActivityStartDate, type = ActivityTypeCode, time = ActivityStartTime.Time,
                  ident = MonitoringLocationIdentifier, var = CharacteristicName, val = ResultMeasureValue,
                  uni = ResultMeasure.MeasureUnitCode,
                  Sample_Depth_m = ActivityDepthHeightMeasure.MeasureValue,
                  depth_uni = ActivityDepthHeightMeasure.MeasureUnitCode
                  ) %>%
    dplyr::left_join(stafrm, by = 'ident') %>%
    dplyr::filter(type %in% c('Field Msr/Obs', 'Sample-Routine')) %>%
    dplyr::filter(!val %in% c('*Not Reported', 'Not Reported')) %>%
    dplyr::mutate(
      time = ifelse(time == '', '00:00:00', time),
      Sample_Depth_m = case_when(
        depth_uni == 'ft' ~ Sample_Depth_m / 3.281,
        T ~ Sample_Depth_m
      )
    ) %>%
    unite('SampleTime', date, time, sep = ' ') %>%
    dplyr::mutate(
      station = gsub(paste0('^', org, '\\-'), '', ident),
      SampleTime = lubridate::ymd_hms(SampleTime, tz = 'America/Jamaica'),
      yr = lubridate::year(SampleTime),
      mo = lubridate::month(SampleTime),
      qual = ifelse(val %in% c('*Non-detect', '*Present <QL'), 'U', NA_character_),
      qual = ifelse(val %in% '*Present >QL', 'I', NA_character_),
      val = ifelse(val %in% c('*Non-detect', '*Present <QL', '*Present >QL'), '', val)
    )

  # format and combine data if wq
  if(type == 'wq'){

    # combine and process
    out <- resfrm %>%
      dplyr::filter(!var %in% c('Nitrate', 'Depth')) %>% # only kept no23
      dplyr::filter(!uni %in% 'ft') %>%
      dplyr::mutate(
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
        )
      )

  }

  # format and combine data if wq
  if(type == 'fib'){

    # combine and process
    out <- resfrm %>%
      dplyr::filter(!is.na(uni)) %>%
      dplyr::mutate(
        var = dplyr::case_when(
          grepl('^Escherichia', var) ~ 'ecoli',
          grepl('^Fecal', var) ~ 'fcolif',
          grepl('^Entero', var) ~ 'ecocci',
          grepl('^Total', var) ~ 'totcol'
        )
      )

  }

  # final formatting
  out <- out %>%
    dplyr::filter(!is.na(var)) %>%
    dplyr::mutate(
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
    select(station, SampleTime, class, yr, mo, Latitude = lat, Longitude = lon,
           Sample_Depth_m, var, val, uni, qual) %>%
    unique()

  # rename station column based on org
  names(out)[names(out) %in% 'station'] <- stanm

  return(out)

}
