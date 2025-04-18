#' Sea level stations in Tampa Bay
#'
#' Stations in Tampa Bay with sea level data through  [CO-OPS Data Retrieval
#' API](https://api.tidesandcurrents.noaa.gov/api/prod/) for use with
#' [read_importsealevels()].
#'
#' @format A data frame with 4 rows and 5 columns:
#' - `station_id` integer station identifier
#' - `station_name` character station name
#' - `longitude` double longitude
#' - `latitude` double latitude
#' - `date_est` date established
#'
#' @concept data
"sealevelstations"
