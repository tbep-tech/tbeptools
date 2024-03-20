#' FDEP IWR run 65
#'
#' Florida Department of Environmental Protection, Impaired Waters Rule, Run 65
#'
#' @format A data frame 195826 rows and 11 variables
#'
#' @details File was created using workflow at <https://tbep-tech.github.io/tidalcreek-stats/Creek_select_tbeptools>, example below is old and for Run 61.
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
