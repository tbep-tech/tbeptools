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

  # # show tables
  # sqlTables(channel)

  # fetch biology table
  out <- RODBC::sqlFetch(channel, "Biology")

  tzone <- 'America/Jamaica'

  # fetch relevant tables ---------------------------------------------------

  FieldSamples <- sqlFetch(channel, 'FieldSamples')
  Stations <- sqlFetch(channel, 'Stations')
  FundingProject <- sqlFetch(channel, 'FundingProject')
  Header <- sqlFetch(channel, 'Header')
  SegmentName <- sqlFetch(channel, 'SegmentName')
  Areas <- sqlFetch(channel, 'Areas')
  Programs_Stations <- sqlFetch(channel, 'ProgramsStations')
  Programs <- sqlFetch(channel, 'Programs')
  vHLabQC <- sqlFetch(channel, 'vHLabQC')
  TaxaCount <- sqlFetch(channel, 'TaxaCount')
  TaxaList <- sqlFetch(channel, 'TaxaList')
  TaxaGroup <- sqlFetch(channel, 'TaxaIdGroup')
  TaxaUnits <- sqlFetch(channel, 'TaxaUnits')

  # programs ----------------------------------------------------------------

  Programs <- Programs %>%
    select(ProgramID, ProgramName) %>%
    filter(ProgramID %in% c(4, 8, 13, 18))

  # Create stations table ---------------------------------------------------

  # subset columns from relevant tables
  station <- Stations %>%
    select(Latitude, Longitude, StationID, StationNumber, AreaID)

  header <- Header %>%
    select(FundingId, SampleTime = ArrivalTime, StationID, Hexagon = GRID_HEX, Comments = GeneralComments, Organics, Metals, IsComplete)

  segment <- SegmentName %>%
    select(AreaAbbr, AreaID)

  area <- Areas %>%
    select(AreaID, AreaName)

  project <- FundingProject %>%
    select(FundingId, FundingProject)

  Stations <- inner_join(Programs_Stations, Programs, by = 'ProgramID') %>%
    inner_join(station, by = 'StationID') %>%
    inner_join(segment, by = 'AreaID') %>%
    inner_join(area, by = 'AreaID') %>%
    inner_join(header, by = 'StationID') %>%
    left_join(project, by = 'FundingId') %>%
    # filter(IsComplete == 1) %>%
    mutate(
      StartDate = as.Date(StartDate),
      EndDate = as.Date(EndDate),
      SampleTime = ymd_hms(SampleTime, tz = tzone),
      Year = year(SampleTime),
      FundingProject = str_trim(FundingProject)
    ) %>%
    select(ProgramID, ProgramName, FundingProject, AreaAbbr, AreaName, Hexagon, Year, SampleTime, StationID,
           StationNumber, Latitude, Longitude, Comments, Organics, Metals, IsComplete)

  # does not match
  dim(Stations)
  dim(Code_Q2_Stations)

  # field qc table ----------------------------------------------------------

  FieldSamples_QC <- vHLabQC %>%
    select(QCID, EquipmentID, ParameterID, StartDate, EndDate, Standard, BracketingTypeId, ParameterID, QCTypeID, Qualifier) %>%
    filter(
      (QCTypeID %in% c(1, 6) & Qualifier == 'J') | (QCTypeID %in% c(1, 6, 5) & !is.na(BracketingTypeId))
    ) %>%
    mutate(
      StartDate = force_tz(StartDate, tz = tzone),
      EndDate = force_tz(EndDate, tz = tzone) + 60*60*24 - 1,
      PivotFieldName = case_when(
        !is.na(BracketingTypeId) ~ paste0('_', BracketingTypeId, 'S'),
        T ~ ''
      ),
      PivotFieldName = paste0('Q', ParameterID, PivotFieldName),
      PivotFieldValue = case_when(
        !is.na(BracketingTypeId) ~ as.character(Standard),
        T ~ Qualifier
      )
    ) %>%
    select(-QCTypeID, -Qualifier)

  # there is an extra row in the Code_Q3 because of a recent date not in my database
  nrow(FieldSamples_QC)
  nrow(Code_Q3_FieldSamples_Qc)

  # field qc table pivoted --------------------------------------------------

  FieldSamples_QCPivoted <- FieldSamples_QC %>%
    filter(PivotFieldName %in% c('Q1', 'Q1_7S', 'Q1_8S', 'Q2', 'Q3', 'Q4', 'Q4_7S', 'Q4_8S', 'Q5')) %>%
    group_by(EquipmentID, StartDate, EndDate, PivotFieldName) %>%
    filter(PivotFieldValue == max(PivotFieldValue, na.rm = T)) %>%
    ungroup() %>%
    spread(PivotFieldName, PivotFieldValue)

  # field samples -----------------------------------------------------------

  FieldSamples <- FieldSamples %>%
    select(StationID, SampleTime, ProgramID, EquipmentID, DisplayID, StratumID, IsQC, Temp = Temperature, DO, DOPercent, pH, Conductivity, Salinity, Depth) %>%
    mutate(
      SampleTime = force_tz(SampleTime, tz = tzone)
    ) %>%
    left_join(FieldSamples_QCPivoted, by = 'EquipmentID') %>%
    filter(SampleTime > StartDate & SampleTime < EndDate) %>%
    # filter(IsQC == 0) %>%
    filter(StratumID %in% c(1, 3, 4)) %>%
    filter(ProgramID %in% unique(Programs$ProgramID)) %>%
    filter(StationID %in% unique(Stations$StationID)) %>%
    mutate(
      Stratum  = case_when(
        StratumID == 1 ~ 'T',
        StratumID %in% c(3, 4) ~ 'B',
        # StratumID == 4 ~ 'B',
        T ~ NA_character_
      ),
      TempQual = Q5,
      DOQual = Q3,
      DOpercent = case_when(
        is.na(DOPercent) ~ round(
          ( DO / exp((-139.34411 + ( 157570.1 / (Temp + 273.15 )) - ( 66423080 / (Temp + 273.15) ^ 2) + ( 12438000000 / (Temp + 273.15) ^ 3) - ( 862194900000 / (Temp + 273.15 ) ^ 4))
                     - ( Salinity * (0.017674 - (10.754 /(Temp + 273.15 )) + (2140.7 / (Temp + 273.15)^2)))
          ) ) * 100, 1),
        T ~ DOPercent
      ),
      DOpercentQual = case_when(
        is.na(DOPercent) & !is.na(DO) & !is.na(Salinity) & !is.na(Temp) ~ 'C',
        !is.na(DOPercent) ~ Q3
      ),
      pHQual = case_when(
        is.na(Q4_7S) & is.na(Q4_8S) ~ Q4,
        !is.na(Q4_7S) & pH < as.numeric(Q4_7S) ~ 'J',
        !is.na(Q4_8S) & pH > as.numeric(Q4_8S) ~ 'J',
        T ~ NA_character_
      ),
      ConductivityQual = case_when(
        is.na(Q1_7S) & is.na(Q1_8S) ~ Q1,
        !is.na(Q1_7S) & Conductivity < as.numeric(Q1_7S)*1000 ~ 'J',
        !is.na(Q1_8S) & Conductivity > as.numeric(Q1_8S)*1000 ~ 'J',
        T ~ NA_character_
      ),
      SalinityQual = case_when(
        is.na(Salinity) & is.na(Q1_7S) & is.na(Q1_8S) ~ Q1,
        is.na(Salinity) & !is.na(Q1_7S) & Conductivity < as.numeric(Q1_7S)*1000 ~ 'J',
        is.na(Salinity) & !is.na(Q1_8S) & Conductivity > as.numeric(Q1_8S)*1000 ~ 'J',
        T ~ NA_character_
      ),
      DepthQual = Q2
    ) %>%
    select(StationID, ProgramID, SampleTime, EquipmentID, DisplayID, StratumID, Stratum, Temp, TempQual, DO, DOQual, DOpercent, DOpercentQual,
           pH, pHQual, Conductivity, ConductivityQual, Salinity, SalinityQual, Depth, DepthQual)

  # taxa counts -------------------------------------------------------------

  TaxaList <- TaxaList %>%
    select(TaxaListID, NODCCODE, PHYLUM, SUBPHYLUM, CLASS, SubClass, ORDER, SUBORDER, InfraOrder, FAMILY, NAME, `COLONIAL/PLANKTONIC?`)
  TaxaGroup <- TaxaGroup %>%
    select(TaxaCountID = TAXA_ID, TAXA_GROUP)
  TaxaUnits <- TaxaUnits %>%
    select(Units = ID, StandardizingConstant)

  TaxaCounts <- TaxaCount %>%
    rename(
      TaxaListID = TaxaListId,
      TaxaCountID = TaxaID
    ) %>%
    inner_join(TaxaList, by = 'TaxaListID') %>%
    left_join(TaxaGroup, by = 'TaxaCountID') %>%
    inner_join(TaxaUnits, by = 'Units') %>%
    filter(Units != 3) %>%
    filter(Grab == 1) %>%
    filter(!TaxaListID %in% c(209, 2175, 2176, 2177, 2178, 2179, 2087, 1995, 1942)) %>%
    # filter(!(COUNT == 0 & TaxaCountID != 5)) %>%
    filter(StationID %in% unique(Stations$StationID)) %>%
    mutate(
      AdjCount = case_when(
        `COLONIAL/PLANKTONIC?` == 'COLONIAL' ~ 1,
        T ~ COUNT * StandardizingConstant
      )
    ) %>%
    select(StationID, TaxaCountID, TaxaListID, NODCCODE, TAXA_GROUP, PHYLUM, SUBPHYLUM, CLASS, SUBCLASS = SubClass, ORDER, SUBORDER,
           INFRAORDER = InfraOrder, FAMILY, NAME, `COLONIAL/PLANKTONIC` = `COLONIAL/PLANKTONIC?`, TaxaCount = COUNT, AdjCount
    )

  # TaxaSums ----------------------------------------------------------------

  # taxa counts aggregated by station & taxa list id
  TaxaSums <- TaxaCounts %>%
    group_by(StationID, NODCCODE, TAXA_GROUP, PHYLUM, SUBPHYLUM, CLASS, SUBCLASS, ORDER, SUBORDER, INFRAORDER, FAMILY, NAME, `COLONIAL/PLANKTONIC`, TaxaListID) %>%
    summarise(
      SumofCount = sum(TaxaCount, na.rm = T),
      SumofAdjCount = sum(AdjCount, na.rm = T),
      .groups = 'drop'
    )

  # BioStats ----------------------------------------------------------------

  # biology stats aggregated by station
  BioStats <- TaxaSums %>%
    group_by(StationID) %>%
    summarise(
      SpeciesRichness = length(na.omit(NAME)),
      RawCountAbundance = sum(SumofCount, na.rm = T),
      AdjCountAbundance = sum(SumofAdjCount, na.rm = T),
      .groups = 'drop'
    )

  # BioStatsPopulation ------------------------------------------------------

  spionid <- TaxaSums %>%
    filter(FAMILY %in% 'Spionidae') %>%
    group_by(StationID) %>%
    summarise(SpionidAbundance = sum(SumofAdjCount, na.rm = T), .groups = 'drop')
  capitellid <-  TaxaSums %>%
    filter(FAMILY %in% 'Capitellidae') %>%
    group_by(StationID) %>%
    summarise(CapitellidAbundance = sum(SumofAdjCount, na.rm = T), .groups = 'drop')
  fsb <- FieldSamples %>%
    filter(Stratum == 'B')

  # calculate biology populations/abundance by station
  BioStatsPopulation <- BioStats %>%
    left_join(spionid, by = 'StationID') %>%
    left_join(capitellid, by = 'StationID') %>%
    left_join(fsb, by = 'StationID') %>%
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

  BioStatsTBBI <- BioStatsPopulation %>%
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

  out <- BioStatsTBBI
  return(out)

}

