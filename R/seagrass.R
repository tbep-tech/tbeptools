#' Seagrass coverage by year
#'
#' Seagrass coverage by year
#'
#' @format A data frame used to create the flagship seagrass coverage graphic:
#' \describe{
#'   \item{Year}{int}
#'   \item{Acres}{num}
#'   \item{Hectares}{num}
#' }
#'
#' @details Original data are from the Southwest Florida Water Management District and available online at <https://data-swfwmd.opendata.arcgis.com/>.  Totals are for all of Tampa Bay.
#'
#' @concept data
#'
#' @examples
#' \dontrun{
#'
#' seagrass <- structure(list(
#'    Year = c(1950L, 1982L, 1988L, 1990L, 1992L, 1994L, 1996L,
#'         1999L, 2001L, 2004L, 2006L, 2008L, 2010L, 2012L, 2014L,
#'         2016L, 2018L, 2020L, 2022L),
#'    Acres = c(40420, 21650, 23285, 25226, 25753, 26518, 26916,
#'         24841, 26078, 27021, 28299, 29647, 32897, 34642, 40294.71,
#'         41655.16, 40651.55, 34298, 30137),
#'    Hectares = c(16357.39, 8761.44, 9423.11, 10208.6, 10421.87,
#'         10731.45, 10892.52, 10052.8, 10553.39, 10935.01, 11452.2,
#'         11997.72, 13312.94, 14019.27, 16306.69, 16857.25, 16451.1,
#'         13880, 12196)
#'  ), class = "data.frame", row.names = c(NA, -19L))
#'
#' save(seagrass, file = 'data/seagrass.RData', compress = 'xz')
#'
#' }
"seagrass"
