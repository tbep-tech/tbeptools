#' Get Tampa Bay Benthic Index scores
#'
#' Get Tampa Bay Benthic Index scores
#'
#' @param benthicdata nested \code{\link[tibble]{tibble}} formatted from \code{\link{read_importbenthic}}
#'
#' @details This function calculates scores for the TBBI based on station, taxa, and field sample data.  The total TBBI scores are returned as \code{TBBI} and \code{TBBICat}, where the latter is a categorical description of the scores.
#'
#' @return A single data frame of TBBI scores for each site.
#' @export
#'
#' @family anlz
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' anlz_tbbiscr(benthicdata)
anlz_tbbiscr <- function(benthicdata){

  stations <- benthicdata %>%
    tibble::deframe() %>%
    .[['stations']]
  fieldsamples <- benthicdata %>%
    tibble::deframe() %>%
    .[['fieldsamples']]
  taxacounts <- benthicdata %>%
    tibble::deframe() %>%
    .[['taxacounts']]

  # TaxaSums ----------------------------------------------------------------

  # taxa counts aggregated by station & taxa list id
  taxasums <- taxacounts %>%
    dplyr::filter(!TaxaListID %in% c(209, 2175, 2176, 2177, 2178, 2179, 2087, 1995, 1942)) %>%
    # filter(!(COUNT == 0 & TaxaListID != 5)) %>%
    dplyr::filter(StationID %in% unique(stations$StationID)) %>%
    dplyr::group_by(StationID, FAMILY, NAME, TaxaListID) %>%
    dplyr::summarise(
      SumofCount = sum(TaxaCount, na.rm = T),
      SumofAdjCount = sum(AdjCount, na.rm = T),
      .groups = 'drop'
    )

  # BioStats ----------------------------------------------------------------

  # biology stats aggregated by station
  biostats <- taxasums %>%
    dplyr::group_by(StationID) %>%
    dplyr::summarise(
      SpeciesRichness = length(na.omit(NAME)),
      RawCountAbundance = sum(SumofCount, na.rm = T),
      AdjCountAbundance = sum(SumofAdjCount, na.rm = T),
      .groups = 'drop'
    )

  # BioStatsPopulation ------------------------------------------------------

  spionid <- taxasums %>%
    dplyr::filter(FAMILY %in% 'Spionidae') %>%
    dplyr::group_by(StationID) %>%
    dplyr::summarise(SpionidAbundance = sum(SumofAdjCount, na.rm = T), .groups = 'drop')
  capitellid <-  taxasums %>%
    dplyr::filter(FAMILY %in% 'Capitellidae') %>%
    dplyr::group_by(StationID) %>%
    dplyr::summarise(CapitellidAbundance = sum(SumofAdjCount, na.rm = T), .groups = 'drop')

  # calculate biology populations/abundance by station
  biostatspopulation <- biostats %>%
    dplyr::left_join(spionid, by = 'StationID') %>%
    dplyr::left_join(capitellid, by = 'StationID') %>%
    dplyr::left_join(fieldsamples, by = 'StationID') %>%
    dplyr::mutate(
      StandPropLnSpecies = dplyr::case_when(
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
    dplyr::select(StationID, SpeciesRichness, RawCountAbundance, TotalAbundance, SpionidAbundance, CapitellidAbundance, StandPropLnSpecies)

  # BioStatsTBBI ------------------------------------------------------------

  biostatstbbi <- biostatspopulation %>%
    dplyr::mutate(
      TBBI = dplyr::case_when(
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
    dplyr::select(StationID, TotalAbundance, SpeciesRichness, TBBI) %>%
    dplyr::filter(!is.na(StationID))

  # empty samples -----------------------------------------------------------

  empts <- taxacounts %>%
    dplyr::filter(TaxaListID %in% 1942) %>%
    dplyr::mutate(TotalAbundance = 0, SpeciesRichness = 0, TBBI = 0) %>%
    dplyr::select(StationID, TotalAbundance, SpeciesRichness, TBBI)

  # final output ------------------------------------------------------------

  out <- biostatstbbi %>%
    dplyr::bind_rows(empts) %>%
    dplyr::mutate(
      TBBICat = dplyr::case_when(
        TBBI == 0 ~ 'Empty Sample',
        TBBI < 73 ~ 'Degraded',
        TBBI >= 73 & TBBI < 87 ~ 'Intermediate',
        TBBI >= 87 ~ 'Healthy',
        T ~ NA_character_
      )
    ) %>%
    dplyr::full_join(fieldsamples, by = 'StationID') %>%
    dplyr::left_join(stations, ., by = c('StationID', 'date'))

  return(out)

}
