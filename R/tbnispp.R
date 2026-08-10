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
#' @details See \code{data-raw/tbnispp-raw.R} for the script used to create the
#'   data object, which pulls the source rds file from the
#'   \href{https://github.com/tbep-tech/tbni-proc}{tbni-proc} repo.
#' 
#' @examples
#' dim(tbnispp)
"tbnispp"
