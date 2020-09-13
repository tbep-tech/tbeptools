#' Format benthic data for the Tampa Bay Benthic Index
#'
#' @param channel A \code{\link[RODBC]{RODBC}} class connection object to the .mdb benthic database
#'
#' @return A formatted \code{data.frame} of benthic and supporting data for the TBBI
#'
#' @details Function is used internally within \code{\link{read_importbenthic}}, see the help file for limitations on using the function outside of Windows.
#'
#' @family read
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
#' }
read_formbenthic <- function(channel){

  tzone <- 'America/Jamaica'

  # fetch relevant tables ---------------------------------------------------

  # station metadata
  Stations <- sqlFetch(channel, 'Stations')
  Header <- sqlFetch(channel, 'Header')
  Programs <- sqlFetch(channel, 'Programs')
  ProgramsStations <- sqlFetch(channel, 'ProgramsStations')

  # water chem
  FieldSamples <- sqlFetch(channel, 'FieldSamples')

  # bug data
  TaxaCount <- sqlFetch(channel, 'TaxaCount')
  TaxaList <- sqlFetch(channel, 'TaxaList')
  TaxaGroup <- sqlFetch(channel, 'TaxaIdGroup')
  TaxaUnits <- sqlFetch(channel, 'TaxaUnits')

  # Station meta ------------------------------------------------------------

  programsstations <- ProgramsStations %>%
    select(StationID, ProgramID)

  programs <- Programs %>%
    select(ProgramID, ProgramName) %>%
    filter(ProgramID %in% c(4, 8, 13, 18))
  # filter(ProgramID %in% c(4, 8, 13, 14, 16, 18))

  header <- Header %>%
    select(StationID, SampleTime = ArrivalTime, IsComplete)

  # subset columns from relevant tables
  stations <- Stations %>%
    select(StationID, Latitude, Longitude)

  stations <- programs %>%
    inner_join(programsstations, by = 'ProgramID') %>%
    inner_join(header, by = 'StationID') %>%
    inner_join(stations, by = 'StationID') %>%
    filter(IsComplete == 1) %>%
    mutate(
      SampleTime = force_tz(SampleTime, tz = tzone),
      date = as.Date(SampleTime)
    ) %>%
    select(StationID, ProgramID, ProgramName, Latitude, Longitude, date)

  # field samples -----------------------------------------------------------

  fieldsamples <- FieldSamples %>%
    select(StationID, SampleTime, StratumID, Salinity) %>%
    mutate(
      SampleTime = force_tz(SampleTime, tz = tzone),
      date = as.Date(SampleTime)
    ) %>%
    filter(StratumID %in% c(1, 3, 4)) %>%
    filter(StationID %in% unique(Stations$StationID)) %>%
    mutate(
      Stratum  = case_when(
        StratumID == 1 ~ 'T',
        StratumID %in% c(3, 4) ~ 'B',
        T ~ NA_character_
      )
    ) %>%
    filter(Stratum %in% 'B') %>%
    group_by(StationID, date, Stratum) %>%
    summarise(Salinity = mean(Salinity, na.rm = T), .groups = 'drop')

  # taxa counts -------------------------------------------------------------

  taxalist <- TaxaList %>%
    select(TaxaListID, FAMILY, NAME, `COLONIAL/PLANKTONIC?`)
  taxagroup <- TaxaGroup %>%
    select(TaxaCountID = TAXA_ID, TAXA_GROUP)
  taxaunits <- TaxaUnits %>%
    select(Units = ID, StandardizingConstant)

  taxacounts <- TaxaCount %>%
    rename(
      TaxaListID = TaxaListId,
      TaxaCountID = TaxaID
    ) %>%
    inner_join(taxalist, by = 'TaxaListID') %>%
    left_join(taxagroup, by = 'TaxaCountID') %>%
    inner_join(taxaunits, by = 'Units') %>%
    filter(Units != 3) %>%
    filter(Grab == 1) %>%
    filter(!TaxaListID %in% c(209, 2175, 2176, 2177, 2178, 2179, 2087, 1995, 1942)) %>%
    # filter(!(COUNT == 0 & TaxaListID != 5)) %>%
    filter(StationID %in% unique(stations$StationID)) %>%
    mutate(
      AdjCount = case_when(
        `COLONIAL/PLANKTONIC?` == 'COLONIAL' ~ 1,
        T ~ COUNT * StandardizingConstant
      )
    ) %>%
    select(StationID, TaxaCountID, TaxaListID, FAMILY, NAME, TaxaCount = COUNT, AdjCount
    )

  # TaxaSums ----------------------------------------------------------------

  # taxa counts aggregated by station & taxa list id
  taxasums <- taxacounts %>%
    group_by(StationID, FAMILY, NAME, TaxaListID) %>%
    summarise(
      SumofCount = sum(TaxaCount, na.rm = T),
      SumofAdjCount = sum(AdjCount, na.rm = T),
      .groups = 'drop'
    )

  # BioStats ----------------------------------------------------------------

  # biology stats aggregated by station
  biostats <- taxasums %>%
    group_by(StationID) %>%
    summarise(
      SpeciesRichness = length(na.omit(NAME)),
      RawCountAbundance = sum(SumofCount, na.rm = T),
      AdjCountAbundance = sum(SumofAdjCount, na.rm = T),
      .groups = 'drop'
    )

  # BioStatsPopulation ------------------------------------------------------

  spionid <- taxasums %>%
    filter(FAMILY %in% 'Spionidae') %>%
    group_by(StationID) %>%
    summarise(SpionidAbundance = sum(SumofAdjCount, na.rm = T), .groups = 'drop')
  capitellid <-  taxasums %>%
    filter(FAMILY %in% 'Capitellidae') %>%
    group_by(StationID) %>%
    summarise(CapitellidAbundance = sum(SumofAdjCount, na.rm = T), .groups = 'drop')

  # calculate biology populations/abundance by station
  biostatspopulation <- biostats %>%
    left_join(spionid, by = 'StationID') %>%
    left_join(capitellid, by = 'StationID') %>%
    left_join(fieldsamples, by = 'StationID') %>%
    mutate(
      StandPropLnSpecies = case_when(
        is.na(SpeciesRichness) | is.na(Salinity) ~ 0,
        T ~ ((log(SpeciesRichness + 1) / log(10))
             / ((( 3.2983 - 0.23576 * Salinity ) +  0.01081 * Salinity^2) - 0.00015327 * Salinity^3)
             - 0.84227
        ) / 0.18952
      ),
      SpeciesRichness = ifelse(is.na(SpeciesRichness), 0, SpeciesRichness),
      RawCountAbundance = ifelse(is.na(RawCountAbundance), 0, RawCountAbundance),
      TotalAbundance = ifelse(is.na(AdjCountAbundance), 0, AdjCountAbundance),
      SpionidAbundance = ifelse(is.na(SpionidAbundance), 0, SpionidAbundance),
      CapitellidAbundance = ifelse(is.na(CapitellidAbundance), 0, CapitellidAbundance)
    ) %>%
    select(StationID, SpeciesRichness, RawCountAbundance, TotalAbundance, SpionidAbundance, CapitellidAbundance,
           `Sal-B` = Salinity, StandPropLnSpecies)

  # BioStatsTBBI ------------------------------------------------------------

  biostatstbbi <- biostatspopulation %>%
    mutate(
      TBBI = case_when(
        CapitellidAbundance == 0 & SpionidAbundance != 0 ~
          (((-0.11407) + (StandPropLnSpecies * 0.32583 ) +
              (((asin(SpionidAbundance / TotalAbundance) - 0.11646 ) / (0.18554)) *
                 (-0.1502)) + ((-0.51401) * (-0.60943))) - (-3.3252118)) / (0.7578544 + 3.3252118),


        CapitellidAbundance != 0 & SpionidAbundance == 0 ~
          (((-0.11407) + (StandPropLnSpecies * 0.32583) + ((-0.62768) * (-0.1502)) +
              ((( asin( CapitellidAbundance / TotalAbundance) - 0.041249) / 0.08025) *
                 (-0.60943))) - (-3.3252118)) / (0.7578544 + 3.3252118),

        CapitellidAbundance == 0 & SpionidAbundance == 0 & TotalAbundance != 0 ~
          (((-0.11407) + (StandPropLnSpecies * 0.32583) + ((-0.62768) * (-0.1502)) +
              ((-0.51401) * (-0.60943))) - (-3.3252118)) / ( 0.7578544 + 3.3252118),

        TotalAbundance == 0 ~ 0,
        T ~ ((( -0.11407) + (StandPropLnSpecies * 0.32583) +
                (((asin(SpionidAbundance / TotalAbundance) - 0.11646) / 0.18554) * (-0.1502)) +
                (((asin( CapitellidAbundance / TotalAbundance) - 0.041249) / 0.08025) *
                   (-0.60943))) - (-3.3252118)) / (0.7578544 + 3.3252118)
      ),
      TBBI = round(100 * TBBI, 2)
    ) %>%
    select(StationID, TotalAbundance, SpeciesRichness, TBBI, `Sal-B`)


  out <- biostatstbbi

  return(out)

}

