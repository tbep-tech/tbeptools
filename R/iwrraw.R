#' FDEP IWR run 61
#'
#' Florida Department of Environmental Protection, Impaired Waters Rule, Run 61
#'
#' @format A data frame 405682 rows and 15 variables
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#'
#' load(file = '../../02_DOCUMENTS/tidal_creeks/iwrraw_run61.RData')
#' iwrraw <- sf::st_set_geometry(iwrraw, NULL) %>%
#'   rename(JEI = jei)
#' save(iwrraw, file = 'data/iwrraw.RData', compress = 'xz')
#' }
"iwrraw"
