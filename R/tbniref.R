#' Reference conditions for Tampa Bay Nekton Index metrics
#'
#' Reference conditions for Tampa Bay Nekton Index metrics
#'
#' @format A data frame with 16 rows and 12 variables:
#' \describe{
#'   \item{bay_segment}{chr}
#'   \item{Season}{chr}
#'   \item{NumTaxa_P5}{num}
#'   \item{NumTaxa_P95}{num}
#'   \item{BenthicTaxa_P5}{num}
#'   \item{BenthicTaxa_P95}{num}
#'   \item{TaxaSelect_P5}{num}
#'   \item{TaxaSelect_P95}{num}
#'   \item{NumGuilds_P5}{num}
#'   \item{NumGuilds_P95}{num}
#'   \item{Shannon_P5}{num}
#'   \item{Shannon_P95}{num}
#' }
#'
#' @examples
#' \dontrun{
#'
#' library(tbeptools)
#'
#' tbniref <- anlz_tbnimet(fimdata) %>%
#'   dplyr::filter(between(Year, 1998, 2015)) %>%
#'   dplyr::select(Season, bay_segment, NumTaxa, BenthicTaxa, TaxaSelect, NumGuilds, Shannon) %>%
#'   dplyr::group_by(bay_segment, Season) %>%
#'   dplyr::summarize(NumTaxa_P5 = round(quantile(NumTaxa, probs = 0.05)),
#'                    NumTaxa_P95 = round(quantile(NumTaxa, probs = 0.95)),
#'                    BenthicTaxa_P5 = round(quantile(BenthicTaxa, probs = 0.05)),
#'                    BenthicTaxa_P95 = round(quantile(BenthicTaxa, probs = 0.95)),
#'                    TaxaSelect_P5 = round(quantile(TaxaSelect, probs = 0.05)),
#'                    TaxaSelect_P95 = round(quantile(TaxaSelect, probs = 0.95)),
#'                    NumGuilds_P5 = round(quantile(NumGuilds, probs = 0.05)),
#'                    NumGuilds_P95 = round(quantile(NumGuilds, probs = 0.95)),
#'                    Shannon_P5 = quantile(Shannon, probs = 0.05),
#'                    Shannon_P95 = quantile(Shannon, probs = 0.95))
#'
#' save(tbniref, file = 'data/tbniref.RData', compress = 'xz')
#'
#' }
"tbniref"
