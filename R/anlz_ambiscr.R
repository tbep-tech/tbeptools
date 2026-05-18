#' Get AMBI scores for benthic stations
#'
#' Get AMBI scores for benthic stations
#'
#' @param benthicdata nested \code{\link[tibble]{tibble}} formatted from \code{\link{read_importbenthic}}
#' @param type chr string indicating which AMBI variant to calculate, one of \code{"AMBI"} (conventional, based on Gillett et al. 2015) or \code{"AMBI-TB"} (Tampa Bay-specific group assignments)
#'
#' @details
#' This function calculates the AZTI Marine Biotic Index (AMBI) for benthic stations in Tampa Bay.  The index assigns each taxon to one of five ecological groups (I = most sensitive, V = most tolerant to pollution) and computes a Biotic Coefficient (BC) from the proportion of taxa in each group.
#'
#' The Biotic Coefficient is calculated as:
#'
#' \deqn{BC = (0 \times \%G1 + 1.5 \times \%G2 + 3 \times \%G3 + 4.5 \times \%G4 + 6 \times \%G5) / 100}
#'
#' where \%G1 through \%G5 are the percentages of taxa records belonging to each ecological group.  Note that the count is based on the number of taxa records (species richness per group), not total organism abundance.  Taxa without a group assignment in \code{\link{ambispp}} are excluded from the count.
#'
#' An adjusted AMBI score on a 0-10 scale is also returned:
#'
#' \deqn{Adjusted AMBI = (7 - BC) \times (10 / 7)}
#'
#' Higher adjusted scores indicate healthier benthic conditions.  Azoic stations (empty samples, TaxaListID == 1942 in \code{\link{benthicdata}}) receive BC = 7 and adjusted score = 0.
#'
#' Two variants are supported via the \code{type} argument.  \code{"AMBI"} uses ecological group assignments from published literature (\code{AMBIGroupID} in \code{\link{ambispp}}).  \code{"AMBI-TB"} uses Tampa Bay-specific assignments (\code{TBAMBIGroupID} in \code{\link{ambispp}}).  The calculation is identical, only the group assignment column differs.
#'
#' @references
#' Gillett, D.J., Weisberg, S.B., Grayson, T., Hamilton, A., Hansen, V., Leppo, E.W., Pelletier, M.C., et al. (2015). Effect of ecological group classification schemes on performance of the AMBI benthic index in US coastal waters. Ecological Indicators, 50, 99-107. \doi{10.1016/j.ecolind.2014.11.005}
#'
#' @return A data frame of AMBI scores for each station, with columns from \code{\link{benthicdata}} stations joined to:
#' \describe{
#'   \item{TotalGroupCount}{int, total number of classified taxa records used in the calculation}
#'   \item{PercentG1 - PercentG5}{num, percentage of taxa records in each ecological group}
#'   \item{BC}{num, Biotic Coefficient (0-6 scale, or 7 for azoic)}
#'   \item{AMBI or TBAMBI}{num, adjusted AMBI score (0-10 scale)}
#'   \item{SitePollutionClassification}{chr, pollution category based on BC}
#'   \item{BioticIndex}{chr, biotic index value (0-6 or Azoic)}
#'   \item{DominatingEcologicalGroup}{chr, dominating ecological group based on BC}
#'   \item{BenthicCommunityHealth}{chr, community health descriptor based on BC}
#'   \item{AMBICat or TBAMBICat}{chr, adjusted AMBI category based on the 0-10 scale}
#' }
#'
#' @export
#'
#' @concept analyze
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' anlz_ambiscr(benthicdata)
#' anlz_ambiscr(benthicdata, type = 'AMBI-TB')
anlz_ambiscr <- function(benthicdata, type = c('AMBI', 'AMBI-TB')) {

  type <- match.arg(type)
  grp_col <- if (type == 'AMBI') 'AMBIGroupID' else 'TBAMBIGroupID'
  score_col <- if (type == 'AMBI') 'AMBI' else 'TBAMBI'
  cat_col <- if (type == 'AMBI') 'AMBICat' else 'TBAMBICat'

  stations <- benthicdata %>%
    tibble::deframe() %>%
    .[['stations']]
  taxacounts <- benthicdata %>%
    tibble::deframe() %>%
    .[['taxacounts']]

  # identify azoic stations (empty samples) before any filtering
  empts <- taxacounts %>%
    dplyr::filter(TaxaListID %in% 1942) %>%
    dplyr::select(StationID) %>%
    dplyr::distinct()

  # join taxacounts to ambispp group assignments
  # exclude azoic placeholder records; only stations present in stations table
  grpcounts <- taxacounts %>%
    dplyr::filter(!TaxaListID %in% 1942) %>%
    dplyr::filter(StationID %in% unique(stations$StationID)) %>%
    dplyr::left_join(ambispp[, c('TaxaListID', grp_col)], by = 'TaxaListID') %>%
    dplyr::filter(!is.na(.data[[grp_col]]))

  # count taxa records per station per ecological group (not sum of organism counts)
  group_tally <- grpcounts %>%
    dplyr::group_by(StationID, .data[[grp_col]]) %>%
    dplyr::summarise(n_records = dplyr::n(), .groups = 'drop') %>%
    tidyr::pivot_wider(
      names_from = dplyr::all_of(grp_col),
      names_prefix = 'G',
      values_from = n_records,
      values_fill = 0L
    )

  # ensure all G1-G5 columns exist even if some groups are absent in the data
  for (g in paste0('G', 1:5)) {
    if (!g %in% names(group_tally))
      group_tally[[g]] <- 0L
  }

  # compute biotic coefficient and adjusted AMBI score
  scores <- group_tally %>%
    dplyr::mutate(
      TotalGroupCount = G1 + G2 + G3 + G4 + G5,
      PercentG1 = (G1 / TotalGroupCount) * 100,
      PercentG2 = (G2 / TotalGroupCount) * 100,
      PercentG3 = (G3 / TotalGroupCount) * 100,
      PercentG4 = (G4 / TotalGroupCount) * 100,
      PercentG5 = (G5 / TotalGroupCount) * 100,
      BC = (0 * PercentG1 + 1.5 * PercentG2 + 3 * PercentG3 +
              4.5 * PercentG4 + 6 * PercentG5) / 100
    ) %>%
    dplyr::mutate(!!score_col := round((7 - BC) * (10 / 7), 2)) %>%
    dplyr::select(StationID, TotalGroupCount, PercentG1, PercentG2, PercentG3, PercentG4, PercentG5,
                  BC, dplyr::all_of(score_col))

  # azoic stations: BC = 7, adjusted score = 0
  azoic_scores <- empts %>%
    dplyr::mutate(
      TotalGroupCount = 0L,
      PercentG1 = 0, PercentG2 = 0, PercentG3 = 0, PercentG4 = 0, PercentG5 = 0,
      BC = 7,
      !!score_col := 0
    )

  combined <- dplyr::bind_rows(scores, azoic_scores)

  # apply BC-based and adjusted score classifications
  combined <- combined %>%
    dplyr::mutate(
      SitePollutionClassification = dplyr::case_when(
        BC == 7     ~ 'Azoic',
        BC <= 1.2   ~ 'Unpolluted',
        BC <= 3.301 ~ 'Slightly Polluted',
        BC <= 5.01  ~ 'Meanly Polluted',
        BC <= 6.01  ~ 'Heavily Polluted',
        TRUE        ~ NA_character_
      ),
      BioticIndex = dplyr::case_when(
        BC == 7     ~ 'Azoic',
        BC <= 0.2   ~ '0',
        BC <= 1.201 ~ '1',
        BC <= 3.301 ~ '2',
        BC <= 4.301 ~ '3',
        BC <= 5.01  ~ '4',
        BC <= 5.501 ~ '5',
        BC <= 6.01  ~ '6',
        TRUE        ~ NA_character_
      ),
      DominatingEcologicalGroup = dplyr::case_when(
        BC == 7     ~ 'Azoic',
        BC <= 1.2   ~ 'Group I',
        BC <= 3.301 ~ 'Group III',
        BC <= 5.01  ~ 'Group IV-V',
        BC <= 6.01  ~ 'Group V',
        TRUE        ~ NA_character_
      ),
      BenthicCommunityHealth = dplyr::case_when(
        BC == 7     ~ 'Azoic',
        BC <= 0.2   ~ 'Normal',
        BC <= 1.201 ~ 'Impoverished',
        BC <= 3.301 ~ 'Unbalanced',
        BC <= 4.301 ~ 'Transitional to Pollution',
        BC <= 5.01  ~ 'Polluted',
        BC <= 5.501 ~ 'Transition to Heavy Pollution',
        BC <= 6.01  ~ 'Heavily Polluted',
        TRUE        ~ NA_character_
      ),
      !!cat_col := dplyr::case_when(
        BC == 7                          ~ 'Azoic',
        .data[[score_col]] <= 1.39       ~ 'Extremely Polluted',
        .data[[score_col]] <= 2.89       ~ 'Heavily Polluted',
        .data[[score_col]] <= 5.29       ~ 'Meanly Polluted',
        .data[[score_col]] <= 8.29       ~ 'Slightly Polluted',
        .data[[score_col]] <= 10.0       ~ 'Unpolluted',
        TRUE                             ~ NA_character_
      )
    )

  # join scores to stations
  out <- stations %>%
    dplyr::left_join(combined, by = 'StationID')

  return(out)

}
