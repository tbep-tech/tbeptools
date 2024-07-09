#' Reference table for Tampa Bay Nekton Index species classifications
#'
#' Reference table for Tampa Bay Nekton Index species classifications
#'
#' @format A data frame with 196 rows and 10 variables:
#' \describe{
#'   \item{TSN}{int}
#'   \item{NODCCODE}{chr}
#'   \item{ScientificName}{chr}
#'   \item{Include_TB_Index}{chr}
#'   \item{Hab_Cat}{chr}
#'   \item{Est_Cat}{chr}
#'   \item{Est_Use}{chr}
#'   \item{Feeding_Cat}{chr}
#'   \item{Feeding_Guild}{chr}
#'   \item{Selected_Taxa}{chr}
#' }
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#'
#' # import and clean
#' tbnispp <- read.csv('../tbni-proc/data/TBIndex_spp_codes.csv',
#'     header = TRUE, stringsAsFactors = FALSE) %>%
#'   mutate(
#'     NODCCODE = as.character(NODCCODE),
#'     NODCCODE = case_when(NODCCODE == "9.998e+09" ~ "9998000000",
#'                              TRUE ~ NODCCODE)
#'   )
#'
#' save(tbnispp, file = 'data/tbnispp.RData', compress = 'xz')
#' }
"tbnispp"
