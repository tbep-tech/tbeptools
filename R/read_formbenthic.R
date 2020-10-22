#' Format benthic data for the Tampa Bay Benthic Index
#'
#' @param channel A \code{\link[RODBC]{RODBC}} class connection object to the .mdb benthic database
#'
#' @return A nested \code{\link[tibble]{tibble}} of station, field sample, and taxa data
#'
#' @details Function is used internally within \code{\link{read_importbenthic}}, see the help file for limitations on using the function outside of Windows.
#'
#' @family read
#'
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(RODBC)
#'
#' # setup driver and path to .mdb
#' drvr <- 'Driver={Microsoft Access Driver (*.mdb, *.accdb)};'
#' path <- 'C:/Users/mbeck/Desktop/benthic/EPC DataSubmittals.mdb'
#' odbccall <- paste0(drvr, 'DBQ=', path)
#'
#' # create channel and pass to read_formbenthic
#' channel <- RODBC::odbcDriverConnect(odbccall)
#' read_formbenthic(channel)
#'
#' # close connection
#' odbcClose(channel)
#' }
read_formbenthic <- function(channel){

  tzone <- 'America/Jamaica'

  # fetch relevant tables ---------------------------------------------------

  # station metadata
  Stations <- RODBC::sqlFetch(channel, 'Stations')
  Header <- RODBC::sqlFetch(channel, 'Header')
  Programs <- RODBC::sqlFetch(channel, 'Programs')
  ProgramsStations <- RODBC::sqlFetch(channel, 'ProgramsStations')
  SegmentName <- RODBC::sqlFetch(channel, 'SegmentName')

  # water chem
  FieldSamples <- RODBC::sqlFetch(channel, 'FieldSamples')

  # bug data
  TaxaCount <- RODBC::sqlFetch(channel, 'TaxaCount')
  TaxaList <- RODBC::sqlFetch(channel, 'TaxaList')
  TaxaGroup <- RODBC::sqlFetch(channel, 'TaxaIdGroup')
  TaxaUnits <- RODBC::sqlFetch(channel, 'TaxaUnits')

  # Station meta ------------------------------------------------------------

  programsstations <- ProgramsStations %>%
    select(StationID, ProgramID)

  programs <- Programs %>%
    dplyr::select(ProgramID, ProgramName) %>%
    dplyr::filter(ProgramID %in% c(4, 8, 13, 18))
  # filter(ProgramID %in% c(4, 8, 13, 14, 16, 18))

  header <- Header %>%
    select(StationID, SampleTime = ArrivalTime, IsComplete)

  # subset columns from relevant tables
  stations <- Stations %>%
    dplyr::select(StationID, AreaID, Latitude, Longitude)

  # for segment id, do not use spatial join
  segments <- SegmentName %>%
    select(AreaID, AreaAbbr)

  stations <- programs %>%
    dplyr::inner_join(programsstations, by = 'ProgramID') %>%
    dplyr::inner_join(header, by = 'StationID') %>%
    dplyr::inner_join(stations, by = 'StationID') %>%
    dplyr::inner_join(segments, by = 'AreaID') %>%
    dplyr::filter(IsComplete == 1) %>%
    dplyr::mutate(
      SampleTime = lubridate::force_tz(SampleTime, tz = tzone),
      date = as.Date(SampleTime),
      yr = lubridate::year(date)
    ) %>%
    dplyr::select(StationID, AreaAbbr, ProgramID, ProgramName, Latitude, Longitude, date, yr)

  # field samples -----------------------------------------------------------

  fieldsamples <- FieldSamples %>%
    dplyr::select(StationID, SampleTime, StratumID, Salinity) %>%
    dplyr::mutate(
      SampleTime = lubridate::force_tz(SampleTime, tz = tzone),
      date = as.Date(SampleTime)
    ) %>%
    filter(StratumID %in% c(1, 3, 4)) %>%
    filter(StationID %in% unique(Stations$StationID)) %>%
    dplyr::mutate(
      Stratum  = dplyr::case_when(
        StratumID == 1 ~ 'T',
        StratumID %in% c(3, 4) ~ 'B',
        T ~ NA_character_
      )
    ) %>%
    dplyr::filter(Stratum %in% 'B') %>%
    dplyr::group_by(StationID, date, Stratum) %>%
    dplyr::summarise(Salinity = mean(Salinity, na.rm = T), .groups = 'drop') %>%
    dplyr::select(-Stratum)

  # taxa counts -------------------------------------------------------------

  taxalist <- TaxaList %>%
    dplyr::select(TaxaListID, FAMILY, NAME, `COLONIAL/PLANKTONIC?`)
  taxagroup <- TaxaGroup %>%
    dplyr::select(TaxaCountID = TAXA_ID, TAXA_GROUP)
  taxaunits <- TaxaUnits %>%
    dplyr::select(Units = ID, StandardizingConstant)

  taxacounts <- TaxaCount %>%
    dplyr::rename(
      TaxaListID = TaxaListId,
      TaxaCountID = TaxaID
    ) %>%
    inner_join(taxalist, by = 'TaxaListID') %>%
    dplyr::left_join(taxagroup, by = 'TaxaCountID') %>%
    dplyr::inner_join(taxaunits, by = 'Units') %>%
    dplyr::filter(Units != 3) %>%
    dplyr::filter(Grab == 1) %>%
    dplyr::mutate(
      AdjCount = dplyr::case_when(
        `COLONIAL/PLANKTONIC?` == 'Colonial' ~ 1,
        T ~ COUNT * StandardizingConstant
      )
    ) %>%
    dplyr::select(StationID, TaxaCountID, TaxaListID, FAMILY, NAME, TaxaCount = COUNT, AdjCount)

  # combine all input needed for tbbi
  out <- list(
    stations = tibble::tibble(stations),
    fieldsamples = fieldsamples,
    taxacounts = tibble::tibble(taxacounts)
    ) %>%
    tibble::enframe()

  return(out)

}

