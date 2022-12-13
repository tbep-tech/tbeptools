#' FIM data for Tampa Bay Nekton Index current as of 12122022
#'
#' FIM data for Tampa Bay Nekton Index current as of 12122022
#'
#' @format A data frame with 45945 rows and 19 variables:
#' \describe{
#'   \item{Reference}{chr}
#'   \item{Sampling_Date}{Date}
#'   \item{Latitude}{num}
#'   \item{Longitude}{num}
#'   \item{Zone}{chr}
#'   \item{Grid}{int}
#'   \item{NODCCODE}{chr}
#'   \item{Year}{num}
#'   \item{Month}{num}
#'   \item{Total_N}{num}
#'   \item{ScientificName}{chr}
#'   \item{Include_TB_Index}{chr}
#'   \item{Hab_Cat}{chr}
#'   \item{Est_Cat}{chr}
#'   \item{Est_Use}{chr}
#'   \item{Feeding_Cat}{chr}
#'   \item{Feeding_Guild}{chr}
#'   \item{Selected_Taxa}{chr}
#'   \item{bay_segment}{chr}
#'   }
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' csv <- '~/Desktop/fimdata.csv'
#'
#' fimdata <- read_importfim(csv, download_latest = TRUE)
#'
#' save(fimdata, file = 'data/fimdata.RData', compress = 'xz')
#'
#' }
"fimdata"
