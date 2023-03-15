#' Format benthic data for the Tampa Bay Benthic Index
#'
#' @param pathin A path to unzipped csv files with base tables used to calculate benthic index
#'
#' @return A nested \code{\link[tibble]{tibble}} of station, field sample, and taxa data
#'
#' @details Function is used internally within \code{\link{read_importbenthic}}
#'
#' @concept read
#'
#' @importFrom dplyr %>%
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' # location to download data
#' path <- '~/Desktop/benthic.zip'
#'
#' # download
#' urlin1 <- 'https://epcbocc.sharepoint.com/:x:/s/Share/'
#' urlin2 <- 'EQUCWBuwCNdGuMREYAyAD1gBKC98mYtCHMWX0FYLrbT4KA?e=nDfnnQ'
#' urlin <- paste0(urlin1, urlin2, '&download=1')
#' read_dlcurrent(path, download_latest = TRUE, urlin = urlin)
#'
#' # unzip
#' tmppth <- tempfile()
#' utils::unzip(path, exdir = tmppth, overwrite = TRUE)
#'
#' # format benthic data
#' read_formbenthic(pathin = tmppth)
#'
#' # remove temporary path
#' unlink(tmppth, recursive = TRUE)
#'
#' }
read_formbenthic <- function(pathin){

  tzone <- 'America/Jamaica'

  # fetch relevant tables ---------------------------------------------------

  # files
  fls <- list.files(pathin, recursive = T, full.names = T)

  # station metadata
  Stations <- read.csv(grep('/Stations\\.csv$', fls, value = TRUE))
  Header <- read.csv(grep('Header', fls, value = TRUE))
  Programs <- read.csv(grep('Programs\\.csv$', fls, value = TRUE), encoding = 'UTF-8')
  ProgramsStations <- read.csv(grep('ProgramsStations', fls, value = TRUE))
  SegmentName <- read.csv(grep('SegmentName', fls, value = TRUE))
  FundingProject <- read.csv(grep('FundingProject', fls, value = TRUE), encoding = 'UTF-8')

  # water chem
  FieldSamples <- read.csv(grep('FieldSamples', fls, value = TRUE))

  # bug data
  TaxaCount <- read.csv(grep('TaxaCount', fls, value = TRUE))
  TaxaList <- read.csv(grep('TaxaList', fls, value = TRUE))
  TaxaGroup <- read.csv(grep('TaxaIdGroup', fls, value = TRUE))
  TaxaUnits <- read.csv(grep('TaxaUnits', fls, value = TRUE))

  # Station meta ------------------------------------------------------------

  programsstations <- ProgramsStations %>%
    select(StationID, ProgramID)

  names(Programs) <- gsub('^X\\.U\\.FEFF\\.', '', names(Programs))
  programs <- Programs %>%
    dplyr::select(ProgramID = ProgramId, ProgramName) %>%
    dplyr::filter(ProgramID %in% c(4, 8, 13, 18))
    # dplyr::filter(ProgramID %in% c(4, 8, 13, 14, 16, 18))

  header <- Header %>%
    dplyr::select(StationID, FundingId, SampleTime = ArrivalTime, IsComplete)

  # subset columns from relevant tables
  stations <- Stations %>%
    dplyr::select(StationID, StationNumber, AreaID, Latitude, Longitude) %>%
    dplyr::filter(!Longitude %in% 'NULL') %>%
    dplyr::mutate(
      Longitude = as.numeric(Longitude),
      Latitude = as.numeric(Latitude)
    )

  # for segment id, do not use spatial join
  segments <- SegmentName %>%
    dplyr::select(AreaID, AreaAbbr) %>%
    dplyr::mutate(
      AreaID = as.character(AreaID)
    )

  # funding source
  names(FundingProject) <- gsub('^X\\.U\\.FEFF\\.', '', names(FundingProject))
  fundingproject <- FundingProject %>%
    dplyr::select(FundingId, FundingProject) %>%
    dplyr::mutate(
      FundingProject = gsub('\\s+$', '', FundingProject),
      FundingId = as.character(FundingId)
      )

  stations <- programs %>%
    dplyr::inner_join(programsstations, by = 'ProgramID') %>%
    dplyr::inner_join(header, by = 'StationID') %>%
    dplyr::inner_join(stations, by = 'StationID') %>%
    dplyr::inner_join(segments, by = 'AreaID') %>%
    dplyr::inner_join(fundingproject, by = 'FundingId') %>%
    dplyr::filter(IsComplete == 1) %>%
    dplyr::mutate(
      SampleTime = lubridate::mdy_hm(SampleTime, tz = tzone),
      date = as.Date(SampleTime),
      yr = lubridate::year(date)
    ) %>%
    dplyr::select(StationID, StationNumber, AreaAbbr, FundingProject, ProgramID, ProgramName, Latitude, Longitude, date, yr)

  # field samples -----------------------------------------------------------

  fieldsamples <- FieldSamples %>%
    dplyr::select(StationID, SampleTime, StratumID, Salinity) %>%
    dplyr::mutate(
      SampleTime = lubridate::mdy_hm(SampleTime, tz = tzone),
      date = as.Date(SampleTime)
    ) %>%
    filter(StratumID %in% c(1, 3, 4)) %>%
    filter(StationID %in% unique(Stations$StationID)) %>%
    dplyr::mutate(
      Stratum  = dplyr::case_when(
        StratumID == 1 ~ 'T',
        StratumID %in% c(3, 4) ~ 'B',
        T ~ NA_character_
      ),
      Salinity = gsub('NULL', '', Salinity),
      Salinity = as.numeric(Salinity)
    ) %>%
    dplyr::filter(Stratum %in% 'B') %>%
    dplyr::group_by(StationID, date, Stratum) %>%
    dplyr::summarise(Salinity = mean(Salinity, na.rm = T), .groups = 'drop') %>%
    dplyr::select(-Stratum)

  # taxa counts -------------------------------------------------------------

  taxalist <- TaxaList %>%
    dplyr::select(TaxaListID, FAMILY, NAME, `COLONIAL/PLANKTONIC?` = `COLONIAL.PLANKTONIC.`)
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
      COUNT = gsub('NULL', NA, COUNT),
      COUNT = as.numeric(COUNT),
      AdjCount = dplyr::case_when(
        `COLONIAL/PLANKTONIC?` == 'Colonial' ~ 1,
        T ~ COUNT * StandardizingConstant
      ),
      StationID = gsub('NULL', '', StationID),
      StationID = as.integer(StationID),
      NAME = iconv(NAME, 'latin1', 'ASCII', sub = '')
    ) %>%
    dplyr::filter(!is.na(StationID)) %>%
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

