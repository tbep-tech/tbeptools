#' Read PRISM raster layers into data frame
#'
#' Scan directory for rasters (*.tif) and parse PRISM layer names into columns of
#' a data frame.
#'
#' Any existing rasters in `dir_tif` are scanned based on a common naming
#' structure for the raster file name (`prism_daily_{month}-{day}.tif`) and
#' layer names (`{date}_{variable}_v{version}-{date_updated}`) into a data
#' frame.
#'
#' For more on the [Parameter-elevation Relationship on Independent Slopes Model
#' (PRISM)](https://prism.oregonstate.edu/), see [`read_importprism()`].
#'
#' @param dir_tif directory path PRISM daily rasters were downloaded and cropped
#'   using [`read_importprism()`].
#'
#' @return A data frame with columns for:
#' - `path_tif` path to GeoTIFF
#' - `lyr` layer name
#' - `date` date of modeled weather data
#' - `md` month-day
#' - `variable` variable of modeled weather data
#' - `version` version (1-8)
#' - `date_updated` date the model was updated
#'
#' @importFrom dplyr arrange filter mutate select tibble
#' @importFrom here here
#' @importFrom lubridate day month
#' @importFrom purrr map
#' @importFrom stringr str_replace
#' @importFrom terra rast
#' @importFrom tidyr unnest
#'
#' @export
#'
#' @concept read
#'
#' @examples
#' dir_tif <- here::here("inst/prism")
#' read_prism_rasters(dir_tif)
read_prism_rasters <- function(dir_tif){
  # read a PRISM tif file
  # tif: path to a PRISM tif file
  # return: a raster object

  rx_lyr    <- "([-0-9]{10})_([A-z]+)_v([1-8]{1})-([-0-9]{10})"

  dplyr::tibble(
    path_tif = list.files(dir_tif, ".*\\.tif$", full.names = T) ) |>
    dplyr::mutate(
      lyr = purrr::map(path_tif, \(path_tif) terra::rast(path_tif) |> names() ) ) |>
    tidyr::unnest(lyr) |>
    dplyr::mutate(
      date         = stringr::str_replace(lyr, rx_lyr, "\\1") |>
        as.Date(),
      md           = sprintf("%02d-%02d", lubridate::month(date), lubridate::day(date)),
      variable     = stringr::str_replace(lyr, rx_lyr, "\\2"),
      version      = stringr::str_replace(lyr, rx_lyr, "\\3") |>
        as.integer(),
      date_updated = stringr::str_replace(lyr, rx_lyr, "\\4") |>
        as.Date()) |>
    dplyr::arrange(md, date, variable, version) # order by: month-day, date, variable
}
