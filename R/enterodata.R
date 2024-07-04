#' Enterococcus data from 5 stations over 5 years
#'
#' @format A data frame with 413 rows and 12 columns:
#' \describe{
#'  \item{date}{data, sample date}
#'  \item{station}{character, sample station, as named in the Water Quality Portal}
#'  \item{ecocci}{numeric, sample's Enterococcus concentration}
#'  \item{ecocci_censored}{logical, whether sample concentration was censored (below detection limit)}
#'  \item{Latitude}{numeric, latitude in decimal degrees}
#'  \item{Longitude}{numeric, longitude in decimal degrees}
#'  \item{ecocci_units}{character, units of measurement of Enterococcus}
#'  \item{time}{character, time sample was obtained, in 24hr format}
#'  \item{time_zone}{character, time zone of sample time}
#'  \item{MDL}{numeric, minimum detection limit of laboratory for Enterococcus}
#'  \item{yr}{numeric year of sample date}
#'  \item{mo}{numeric month of sample date}
#' }
#' @details
#' A sample dataset containing Enterococcus from 5 stations in the TBEP watershed from 2019-2023, for use in function examples.
#' @source Water Quality Portal, https://waterqualitydata.us
#'

"enterodata"
