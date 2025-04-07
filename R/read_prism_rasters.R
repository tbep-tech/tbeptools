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
#' @importFrom lubridate day month
#' @importFrom purrr map
#' @importFrom terra rast
#' @importFrom tidyr unnest
#'
#' @export
#'
#' @concept read
#'
#' @examples
#' dir_tif <- system.file("prism", package = "tbeptools")
#' read_prism_rasters(dir_tif)
read_prism_rasters <- function(dir_tif){

  rx_lyr    <- "([-0-9]{10})_([A-z]+)_v([1-8]{1})-([-0-9]{10})"

  out <- dplyr::tibble(
    path_tif = list.files(dir_tif, ".*\\.tif$", full.names = T) ) %>%
    dplyr::mutate(
      lyr = purrr::map(path_tif, \(path_tif) terra::rast(path_tif) %>% names() ) ) %>%
    tidyr::unnest(lyr) %>%
    dplyr::mutate(
      date         = gsub(rx_lyr, '\\1', lyr) %>%
        as.Date(),
      md           = sprintf("%02d-%02d", lubridate::month(date), lubridate::day(date)),
      variable     = gsub(rx_lyr, '\\2', lyr),
      version      = gsub(rx_lyr, '\\3', lyr) %>%
        as.integer(),
      date_updated = gsub(rx_lyr, '\\4', lyr) %>%
        as.Date()) %>%
    dplyr::arrange(md, date, variable, version) # order by: month-day, date, variable

  return(out)

}
