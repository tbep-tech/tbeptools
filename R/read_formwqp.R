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
#' @details This function is used by \code{\link{read_importwqp}} to combine, format, and process data (\code{res}) and station metadata (\code{sta}) obtained from the Water Quality Portal for the selected county and data type. The resulting data frame includes the date, time, station identifier, latitude, longitude, variable name, value, unit, and quality flag.  Manatee County FIB data (21FLMANA_WQX) will also include an \code{area} column indicating the waterbody name as used by the USF Water Atlas, with some area aggregations.  Other county-level FIB  data will have a similar column.
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
        T ~ 'Marine'
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
          grepl('Orthophosphate', var) ~ 'orthop',
          grepl('Salinity', var) ~ 'sal',
          grepl('Temperature, water', var) ~ 'temp',
          grepl('Turbidity', var) ~ 'turb'
        ),
        uni = case_when(
          uni == 'mg/m3' ~ 'ugl',
          uni == 'mg/L' ~ 'mgl',
          uni == 'ppt' ~ 'ppth',
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
          grepl('^Entero', var) ~ 'entero',
          grepl('^Total', var) ~ 'totcol'
        )
      ) %>%
      dplyr::filter(
        (class == 'Fresh' & var == 'ecoli' & !is.na(val)) |
        (class == 'Marine' & var == 'entero' & !is.na(val))
      )

  }

  # final formatting
  out <- out %>%
    dplyr::filter(!is.na(var)) %>%
    dplyr::filter(!is.na(val)) %>%
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

  # add station areas if fib and manatee county
  if(type == 'fib'){

    if(org == '21FLMANA_WQX')
      tomtch <- data.frame(
        station = c("396", "BC1", "BC2", "BC41", "BL01",
          "BL201", "BR1", "BR2", "BR3", "BU01A", "CC1", "CH1", "D1", "D3",
          "ER1", "ER2", "FC1", "GA1", "GC1", "GC2", "GP", "LL1", "LM3",
          "LM4", "LM5", "LM6", "MC1", "MC2", "MM", "MR1", "MR2", "MS01",
          "MS02", "MY01", "MY02A", "MY04", "PP1", "SC1", "TS1", "TS2",
          "TS3", "TS4", "TS5", "TS6", "TS7", "UM1", "UM2", "UM3", "UM4",
          "WC1"),
        area = c("Lower Tampa Bay", "Bowlees Creek", "Bowlees Creek",
          "Bowlees Creek", "Big Slough", "Big Slough", "Braden River",
          "Braden River", "Braden River", "Bud Slough", "Curiosity Creek",
          "Palma Sola Bay", "Little Manatee River", "Little Manatee River",
          "Ward Lake", "Ward Lake", "Frog Creek", "Gates Creek", "Gamble Creek",
          "Gamble Creek", "Gap Creek", "Braden River", "Braden River",
          "Manatee River Estuary", "Lower Manatee River", "Mill Creek",
          "Mill Creek", "Mill Creek", "Mcmullen Creek", "Clay Gully", "Myakka River",
          "Mud Lake Slough", "Mud Lake Slough", "Myakka River", "Myakka River",
          "Myakka River", "Piney Point Creek", "Sugarhouse Creek", "Rattlesnake Slough",
          "Cedar Creek", "Cooper Creek", "Cooper Creek", "Hickory Hammock Creek",
          "Braden River", "Nonsense Creek", "Lower Manatee River", "Lake Manatee",
          "Gilley Creek", "Upper Manatee River", "Williams Creek"),
        areacmb = c("Lower Tampa Bay",
          "Bowlees Creek", "Bowlees Creek", "Bowlees Creek", "Big Slough",
          "Big Slough", "Braden River", "Braden River", "Braden River",
          "Bud Slough", "Little Manatee River", "Palma Sola Bay", "Little Manatee River",
          "Little Manatee River", "Braden River", "Braden River", "Frog Creek",
          "Manatee River", "Manatee River", "Manatee River", "Gap Creek",
          "Braden River", "Braden River", "Manatee River", "Manatee River",
          "Manatee River", "Manatee River", "Manatee River", "Mcmullen Creek",
          "Clay Gully", "Myakka River", "Mud Lake Slough", "Mud Lake Slough",
          "Myakka River", "Myakka River", "Myakka River", "Piney Point Creek",
          "Braden River", "Braden River", "Braden River", "Braden River",
          "Braden River", "Braden River", "Braden River", "Braden River",
          "Manatee River", "Manatee River", "Manatee River", "Manatee River",
          "Braden River")
        )

    # areas from sta object, nothing to combine
    if(org == '21FLPASC_WQX')
      tomtch <- data.frame(
        station = c("AR-3.28", "BC-0.00", "CC-1.39", "NR-0.57", "PR-0.18", "PR-3.73",
                    "TC-0.00", "UH-1.16"),
        area = c("Anclote River", "Bear Creek", "Cypress Creek", "New River", "Pithlachascotee River",
                 "Pithlachascotee River", "Trout Creek", "Hillsborough River")
        ) %>%
        mutate(areacmb = area)

    if(org == '21FLPOLK_WQX')
      tomtch <- data.frame(
        station = c("ALAFIA RVR1N", "ALAFIA RVR2N", "ALAFIA RVR2S", "BEAR CRK1",
          "BLACKWATER CRK2", "BLACKWATER CRK3", "BOGGY BR1", "BOWLEGS CRK-AVP", 
          "BOWLEGS CRK-US98", "CHARLIE CRK1", "ENGLISH CRK1", "FOX BR1", "GATOR CRK2", 
          "HAMWET", "HORSE CRK2", "ITCHEPACK CRK1", "ITCHEPACK CRK2", "LENA RUN1", 
          "LENA RUN2", "LENA RUN3", "LIVINGSTON CRK1", "MARION CRK1", "OLD TOWN CRK1",
          "P.C. CANAL1", "PC CANAL11 - CREWS", "PC CANAL12 - BAR/LW", "PC CANAL13 - W HAM RD",
          "PC CANAL1 - SR542", "P.C. CANAL2", "PC CANAL2 - THOMPSON", "P.C. CANAL8",
          "PC CANAL8 - 91 MINE", "PEACE RVR10", "PEACE RVR10 - SR60", "PEACE RVR2",
          "PEACE RVR2 - HERITAGE", "PEACE RVR3 - WABASH", "PEACE RVR4 - WHIDDEN",
          "PEACE RVR5 - PISGAH", "PEACE RVR6 - SINK", "PEACE RVR78", "PEACE RVR78 - CO LINE",
          "PEACE RVR7 - GILSHEY", "PEACE RVR8 - LTL PAYNE", "PEACE RVR9 - 6 MILE",
          "PEACE RVR11 - BARBER", "POLEY CRK1N", "POLEY CRK2S", "POLEY CRK3", "PONY CRK1", 
          "REEDY INFLOW", "SADDLE CRK1", "SADDLE CRK10", "SADDLE CRK9", "SCENIC", 
          "SIMMERS-YOUNG CNL1", "SIMMERS-YOUNG CNL INFLOW", "THIRTYMILE CRK1", "TIGER CRK3",
          "TIGER INFLOW SOUTH", "WAHNETA CANAL6", "WAHNETA CNL6", "W BOWLEGS CRK1",
          "WEOHYAKAPKA CRK1", "WEOHYAKAPK CRK1", "WITHLACOO RVR1", "WITHLACOO RVR2"
        ),
        area = c(
          "Alafia River", "Alafia River", "Alafia River",
          "Bear Creek", "Blackwater Creek", "Blackwater Creek",
          "Boggy Branch", "Bowlegs Creek", "Bowlegs Creek", "Charlie Creek", 
          "English Creek", "Fox Branch", "Gator Creek", "Hamwet",
          "Horse Creek", "Itchepack Creek", "Itchepack Creek",
          "Lena Run", "Lena Run", "Lena Run",
          "Livingston Creek", "Marion Creek", "Old Town Creek",
          "PC Canal", "PC Canal", "PC Canal",
          "PC Canal", "PC Canal", "PC Canal",
          "PC Canal", "PC Canal", "PC Canal",
          "Peace River", "Peace River", "Peace River",
          "Peace River", "Peace River", "Peace River",
          "Peace River", "Peace River", "Peace River",
          "Peace River", "Peace River", "Peace River",
          "Peace River", "Peace River", "Poley Creek", "Poley Creek",
          "Poley Creek", "Pony Creek", "Reedy Inflow",
          "Saddle Creek", "Saddle Creek", "Saddle Creek",
          "Scenic", "Simmers-Young Canal", "Simmers-Young Canal",
          "Thirtymile Creek", "Tiger Creek", "Tiger Inflow",
          "Wahneta Canal", "Wahneta Canal", "Bowlegs Creek",
          "Weohyakapka Creek", "Weohyakapka Creek", "Withlacoochee River",
          "Withlacoochee River"
        )
      ) %>%
      mutate(
        areacmb = area
      )

    if(org == '21FLHESD_WQX')
      tomtch <- data.frame(
        station = c(
          "BEAUDETTE POND INLET", "BEAUDETTE POND MIDDLE", "BEAUDETTE POND OUTLET", "BEAUDETTE POND WEST",
          "BLO CHELSEA", "BLO DANNY", "BLO MLK", "BLO ORIENT 1",
          "BLO ORIENT 2", "BLO VETS", "CHANNEL G BRIDGE", "CHANNEL G WEIR",
          "CYPRESS CREEK SCI", "DELANEY CREEK 1", "DELANEY CREEK 10", "DELANEY CREEK 12",
          "DELANEY CREEK 13", "DELANEY CREEK 14", "DELANEY CREEK 15", "DELANEY CREEK 16",
          "DELANEY CREEK 17", "DELANEY CREEK 3", "DELANEY CREEK 4", "DELANEY CREEK 5",
          "DELANEY CREEK 6", "DELANEY CREEK 7", "DELANEY CREEK 8", "DELANEY CREEK 9",
          "EAST LAKE MIDDLE", "EAST LAKE NORTH", "EAST LAKE NORTH CANAL", "EAST LAKE SOUTH",
          "EAST LAKE SOUTH CANAL", "EAST LAKE WEST CANAL", "EGYPT LAKE EAST", "EGYPT LAKE MIDDLE",
          "EGYPT LAKE WEST", "EGYPT LAKE WETLAND", "HENRY STREET CANAL", "LAKE CARROLL MIDDLE",
          "LAKE DARBY MIDDLE", "LAKE GRADY MIDDLE", "LAKE MAGDALENE MIDDLE", "LAKE MANGO MIDDLE",
          "LAKE VALRICO MIDDLE", "LAKE WEEKS MIDDLE", "MANGO DRAIN SCI", "TALIAFERRO EAST POND",
          "TALIAFERRO WEST POND", "VALRICO CANAL"
        ),
        area = c(
          "Beaudette Pond", "Beaudette Pond", "Beaudette Pond", "Beaudette Pond",
          "BLO", "BLO", "BLO", "BLO",
          "BLO", "BLO", "Channel G", "Channel G",
          "Cypress Creek", "Delaney Creek", "Delaney Creek", "Delaney Creek",
          "Delaney Creek", "Delaney Creek", "Delaney Creek", "Delaney Creek",
          "Delaney Creek", "Delaney Creek", "Delaney Creek", "Delaney Creek",
          "Delaney Creek", "Delaney Creek", "Delaney Creek", "Delaney Creek",
          "East Lake", "East Lake", "East Lake", "East Lake",
          "East Lake", "East Lake", "Egypt Lake", "Egypt Lake",
          "Egypt Lake", "Egypt Lake", "Henry Street Canal", "Lake Carroll",
          "Lake Darby", "Lake Grady", "Lake Magdalene", "Lake Mango",
          "Lake Valrico", "Lake Weeks", "Mango Drain", "Taliaferro Pond",
          "Taliaferro Pond", "Valrico Canal"
        )
      ) %>%
      mutate(areacmb = area)

    out <- dplyr::left_join(out, tomtch, by = 'station', relationship = 'many-to-one') %>%
      dplyr::select(-area) %>%
      dplyr::rename(area = areacmb)

    if(any(is.na(out$area)))
      stop('Missing area information for FIB stations')

  }

  # rename station column based on org
  names(out)[names(out) %in% 'station'] <- stanm

  return(out)

}
