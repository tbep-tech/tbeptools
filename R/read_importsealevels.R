#' Import monthly sea levels by station from NOAA Tides and Currents
#'
#' Under [NOAA Tides and Currents](https://tidesandcurrents.noaa.gov/), there is
#' the NOAA Center for Operational Oceanographic Products and Services (CO-OPS).
#' This function uses the [CO-OPS Data Retrieval
#' API](https://api.tidesandcurrents.noaa.gov/api/prod/) to extract see level
#' data by station.
#'
#' @param path_csv chr string path of CSV file to store tabular output.
#'   (Overwrites existing file.)
#' @param download_latest logical to download latest. (Overwrites existing
#'   file.)
#' @param df_stations data frame of stations with column `station_id` (integer).
#'   Defaults to [sealevelstations], subset to columns `station_id` and
#'   `station_name`.
#' @param api_url chr string URL for NOAA Center for Operational Oceanographic
#'   Products and Services (CO-OPS) API. Defaults to the CO-OPS API for data
#'   retrieval: https://api.tidesandcurrents.noaa.gov/api/prod/datagetter.
#' @param beg_int int integer of beginning date in YYYYMMDD format. Defaults to
#'   `19010101`.
#' @param end_int int integer of ending date in YYYYMMDD format. Defaults to
#'   `lubridate::today()`.
#' @param product chr string of product type. For options, see [Data Products |
#'   CO-OPS API](https://api.tidesandcurrents.noaa.gov/api/prod/#products).
#'   Defaults to `"monthly_mean"`: "verified monthly mean water level data for
#'   the station."
#' @param datum chr string of datum. Defaults to `"stnd"`: "station datum -
#'   original reference that all data is collected to, uniquely defined for each
#'   station." For options, see [Datum | CO-OPS
#'   API](https://api.tidesandcurrents.noaa.gov/api/prod/#datum)
#' @param time_zone Time zone. Defaults to `"lst"`: "local standard time."
#'   However, this does not get used with the `monthly_mean` product. For
#'   options, see [Time Zone | CO-OPS
#'   API](https://api.tidesandcurrents.noaa.gov/api/prod/#timezone).
#' @param units chr string of units. Defaults to `"metric"` (i.e., meters). For
#'   other options (i.e., `"english"`), see [Units | CO-OPS
#'   API](https://api.tidesandcurrents.noaa.gov/api/prod/#units).
#'
#' @return Given the default arguments in (and especially `product =
#'   "monthly_mean"`), this function returns a data frame from reading
#'   `path_csv` (updated if `download_latest = TRUE` or newly written if
#'   `path_csv` does not exist) having the following fields:
#' - `station_id`: integer column from input argument `df_stations`
#' - `station_name`: character column from input argument `df_stations`
#' - `date`: first of the month given by `year` and `month` from API output
#' - `year`: year of the data
#' - `month`: month of the data
#' - `mhhw`: Mean Higher-High Water
#' - `mhw`: Mean High Water
#' - `msl`: Mean Sea Level
#' - `mtl`: Mean Tide Level
#' - `mlw`: Mean Low Water
#' - `mllw`: Mean Lower-Low Water
#' - `dtl`: Mean Diurnal Tide Level
#' - `gt`: Great Diurnal Range
#' - `mn`: Mean Range of Tide
#' - `dhq`: Mean Diurnal High Water Inequality
#' - `dlq`: Mean Diurnal Low Water Inequality
#' - `hwi`: Greenwich High Water Interval (in Hours)
#' - `lwi`: Greenwich Low Water Interval (in Hours)
#' - `highest`: Highest Tide
#' - `lowest`: Lowest Tide
#' - `inferred`: A flag that when set to 1 indicates that the water level value has been inferred
#'
#' For more details on these output data columns, see [About Tidal Datums |
#' NOAA Tides &
#' Currents](https://tidesandcurrents.noaa.gov/datum_options.html).
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_string
#' @importFrom dplyr mutate
#' @importFrom tidyr unnest
#' @importFrom purrr map
#' @importFrom lubridate today
#'
#' @export
#'
#' @concept read
#'
#' @examples
#' read_importsealevels(tempfile("sealevels", fileext=".csv"))
read_importsealevels <- function(
    path_csv,
    download_latest = TRUE,
    df_stations     = sealevelstations[,c("station_id", "station_name")],
    api_url         = "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter",
    beg_int         = 19010101,
    end_int         = lubridate::today() %>%
      format("%Y%m%d") %>%
      as.integer(),
    product         = "monthly_mean",
    datum           = "stnd",
    time_zone       = "lst",
    units           = "metric"){

  get_station_data <- function(station_id, ...){
    tryCatch(
      httr2::request(api_url) %>%
        httr2::req_url_query(
          station     = station_id,
          begin_date  = beg_int,
          end_date    = end_int,
          product     = product,
          datum       = datum,
          time_zone   = time_zone,
          units       = units,
          format      = "csv") %>%
        httr2::req_perform() %>%
        httr2::resp_body_string() %>%
        textConnection() %>%
        read.csv(
          stringsAsFactors = FALSE),
      error = function(e){
        stop(paste("Error in httr2::request"))
        }
      )
  }

  if (!file.exists(path_csv) | download_latest)
    df_stations %>%
    dplyr::mutate(
      data = purrr::map(station_id, get_station_data)) %>%
    tidyr::unnest(data) %>%
    dplyr::rename_with(tolower) %>%
    mutate(
      date = sprintf("%d-%02d-01", year, month) %>%
        as.Date()) %>%
    dplyr::relocate(date, .before = year) %>%
    write.csv(path_csv, row.names = FALSE)

  out <- read.csv(path_csv, stringsAsFactors = FALSE) %>%
    dplyr::mutate(
      date = as.Date(date)
    )

  return(out)

}
