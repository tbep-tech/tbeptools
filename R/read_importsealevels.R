#' Import monthly sea levels by station from NOAA Tides and Currents
#'
#' Under [NOAA Tides and Currents](https://tidesandcurrents.noaa.gov/), there is
#' the NOAA Center for Operational Oceanographic Products and Services (CO-OPS).
#' This function uses the [CO-OPS Data Retrieval API](https://api.tidesandcurrents.noaa.gov/api/prod/)
#' to extract see level data by station.
#'
#' @param path_csv chr string path of CSV file to store tabular output. (Overwrites existing file.)
#' @param download_latest logical to download latest. (Overwrites existing file.)
#' @param df_stations data frame of stations with columns `station_id` (integer) and
#' `station_name` (character). Defaults to stations within Tampa Bay.
#' @param api_url chr string URL for NOAA Center for Operational Oceanographic
#' Products and Services (CO-OPS) API. Defaults to the CO-OPS API for data
#' retrieval: https://api.tidesandcurrents.noaa.gov/api/prod/datagetter.
#' @param beg_int int integer of beginning date in YYYYMMDD format. Defaults to `19010101`.
#' @param end_int int integer of ending date in YYYYMMDD format. Defaults to `lubridate::today()`.
#' @param product chr string of product type. For options, see
#' [Data Products | CO-OPS API](https://api.tidesandcurrents.noaa.gov/api/prod/#products).
#' Defaults to `"monthly_mean"`: "verified monthly mean water level data for the station."
#' @param datum chr string of datum. Defaults to `"stnd"`: "station datum -
#' original reference that all data is collected to, uniquely defined for each station." For options,
#' see [Datum | CO-OPS API](https://api.tidesandcurrents.noaa.gov/api/prod/#datum)
#' @param time_zone Time zone. Defaults to `"lst"`: "local standard time." However,
#' this does not get used with the `monthly_mean` product. For options, see
#' [Time Zone | CO-OPS API](https://api.tidesandcurrents.noaa.gov/api/prod/#timezone).
#' @param units chr string of units. Defaults to `"metric"` (i.e., meters). For other
#' options (i.e., `"english"`), see
#' [Units | CO-OPS API](https://api.tidesandcurrents.noaa.gov/api/prod/#units).
#'
#' @return Given the default arguments in (and especially `product = "monthly_mean"`),
#' this function returns a data frame from reading `path_csv`
#' (updated if `download_latest = TRUE` or newly written if `path_csv` does not exist)
#' having the following fields:
# read_importsealevels(tempfile(fileext=".csv")) |>
#   (\(x) data.frame(fld = names(x)) )() |>
#   glue::glue_data("#' - `{fld}`: ") |>
#   paste(collapse = "\n") |>
#   cat()
#' - `station_id`: integer column from input argument `df_stations`
#' - `station_name`: character column from input argument `df_stations`
#' - `Year`: year of the data
#' - `Month`: month of the data
#' - `MHHW`: Mean Higher-High Water
#' - `MHW`: Mean High Water
#' - `MSL`: Mean Sea Level
#' - `MTL`: Mean Tide Level
#' - `MLW`: Mean Low Water
#' - `MLLW`: Mean Lower-Low Water
#' - `DTL`: Mean Diurnal Tide Level
#' - `GT`: Great Diurnal Range
#' - `MN`: Mean Range of Tide
#' - `DHQ`: Mean Diurnal High Water Inequality
#' - `DLQ`: Mean Diurnal Low Water Inequality
#' - `HWI`: Greenwich High Water Interval (in Hours)
#' - `LWI`: Greenwich Low Water Interval (in Hours)
#' - `Highest`: Highest Tide
#' - `Lowest`: Lowest Tide
#' - `Inferred`: A flag that when set to 1 indicates that the water level value has been inferred
#'
#' For more details on these output data columns, see
#' [About Tidal Datums | NOAA Tides & Currents](https://tidesandcurrents.noaa.gov/datum_options.html).
#'
#' @importFrom httr2 request req_url_query req_perform resp_body_string
#' @importFrom readr read_csv write_csv
#' @importFrom dplyr mutate
#' @importFrom tidyr unnest
#' @importFrom purrr map
#' @importFrom lubridate today
#' @importFrom tibble tribble
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
    df_stations     = tibble::tribble(
      ~station_id, ~station_name,
      8726724    , "Clearwater Beach",
      8726674    , "East Bay",
      8726384    , "Port Manatee",
      8726520    , "St. Petersburg"),
    api_url         = "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter",
    beg_int         = 19010101,
    end_int         = lubridate::today() |>
      format("%Y%m%d") |>
      as.integer(),
    product         = "monthly_mean",
    datum           = "stnd",
    time_zone       = "lst",
    units           = "metric"){

  get_station_data <- function(station_id, ...){
    tryCatch(
      httr2::request(api_url) |>
        httr2::req_url_query(
          station     = station_id,
          begin_date  = beg_int,
          end_date    = end_int,
          product     = product,
          datum       = datum,
          time_zone   = time_zone,
          units       = units,
          format      = "csv") |>
        httr2::req_perform() |>
        httr2::resp_body_string() |>
        readr::read_csv(
          name_repair    = "unique_quiet",
          show_col_types = F),
      httr2_error = function(cnd){
        msg <- httr2::resp_body_string(cnd$resp) |> trimws()
        stop(paste(
          "Error in httr2::request to:\n  ", cnd$request$url,
          "Response:\n  ", msg)) } )
  }

  if (!file.exists(path_csv) | download_latest)
    df_stations |>
      dplyr::mutate(
        data = purrr::map(station_id, get_station_data)) |>
      tidyr::unnest(data) |>
      readr::write_csv(path_csv)

  readr::read_csv(path_csv, show_col_types = F)
}
