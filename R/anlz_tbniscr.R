#' Get Tampa Bay Nekton Index scores
#'
#' Get Tampa Bay Nekton Index scores
#'
#' @param fimdata \code{data.frame} formatted from \code{\link{read_importfim}}
#' @param raw logical indicating if raw metric values are also returned
#'
#' @details This function calculates raw and scored metrics for the TBNI, including \code{NumTaxa}, \code{BenthicTaxa}, \code{TaxaSelect}, \code{NumGuilds}, and \code{Shannon}.  The total TBNI score is returned as \code{TBNI_Score}.
#'
#' @return A data frame of metrics and TBNI scores in wide format.
#' @export
#'
#' @concept analyze
#'
#' @seealso \code{\link{anlz_tbnimet}}
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' anlz_tbniscr(fimdata)
anlz_tbniscr <- function(fimdata, raw = TRUE){

  # raw metrics
  tbnimet <- anlz_tbnimet(fimdata)

  # scored metrics and TBNI
  out <- tbnimet %>%
    dplyr::select(Reference, Year, Month, Season, bay_segment, NumTaxa, BenthicTaxa, TaxaSelect, NumGuilds, Shannon) %>%
    dplyr::left_join(tbniref, by = c("bay_segment", "Season")) %>%
    dplyr::mutate(ScoreNumTaxa = dplyr::case_when(NumTaxa == 0 ~ 0,
                                    NumTaxa > NumTaxa_P95 ~ 10,
                                    TRUE ~ ((NumTaxa-NumTaxa_P5)/(NumTaxa_P95-NumTaxa_P5))*10),
           ScoreShannon = dplyr::case_when(NumTaxa == 0 ~ 0,
                                    Shannon > Shannon_P95 ~ 10,
                                    TRUE ~ ((Shannon-Shannon_P5)/(Shannon_P95-Shannon_P5))*10),
           ScoreTaxaSelect = dplyr::case_when(NumTaxa == 0 ~ 0,
                                       TaxaSelect > TaxaSelect_P95 ~ 10,
                                       TRUE ~ ((TaxaSelect-TaxaSelect_P5)/(TaxaSelect_P95-TaxaSelect_P5))*10),
           ScoreBenthicTaxa = dplyr::case_when(NumTaxa == 0 ~ 0,
                                        BenthicTaxa > BenthicTaxa_P95 ~ 10,
                                        TRUE ~ ((BenthicTaxa-BenthicTaxa_P5)/(BenthicTaxa_P95-BenthicTaxa_P5))*10),
           ScoreNumGuilds = dplyr::case_when(NumTaxa == 0 ~ 0,
                                      NumGuilds > NumGuilds_P95 ~ 10,
                                      TRUE ~ ((NumGuilds-NumGuilds_P5)/(NumGuilds_P95-NumGuilds_P5))*10)) %>%
    dplyr::mutate(
      ScoreBenthicTaxa = replace(ScoreBenthicTaxa, ScoreBenthicTaxa <0, 0),
      ScoreNumTaxa = round(ScoreNumTaxa),
      ScoreShannon = round(ScoreShannon),
      ScoreTaxaSelect = round(ScoreTaxaSelect),
      ScoreBenthicTaxa = round(ScoreBenthicTaxa),
      ScoreNumGuilds = round(ScoreNumGuilds),
      TBNI_Score = (ScoreNumTaxa + ScoreShannon + ScoreTaxaSelect + ScoreBenthicTaxa + ScoreNumGuilds) * 10 / 5
    ) %>%
    dplyr::select(Reference, Year, Month, Season, bay_segment, TBNI_Score, NumTaxa, ScoreNumTaxa, BenthicTaxa, ScoreBenthicTaxa, TaxaSelect,
                  ScoreTaxaSelect, NumGuilds, ScoreNumGuilds, Shannon, ScoreShannon)

  if(!raw)
    out <- out %>%
      dplyr::select(-NumTaxa, -BenthicTaxa, -TaxaSelect, -NumGuilds, -Shannon)

  return(out)

}
