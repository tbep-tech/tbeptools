#' Import PRISM daily weather data
#'
#' Download and crop PRISM daily weather data.
#'
#' The [Parameter-elevation Relationship on Independent Slopes Model
#' (PRISM)](https://prism.oregonstate.edu/) is a combined dataset consisting of
#' ground gauge station and RADAR products, at a 4km grid resolution covering
#' the contiguous United States from 1981 to present.
#'
#' ### Variables
#'
#' The available variables (`vars`) are:
#' - `tmin`: minimum temperature
#' - `tmax`: maximum temperature
#' - `tmean`: mean temperature (`tmean = mean(tmin, tmax)`)
#' - `tdmean`: mean dew point temperature
#' - `ppt`: total precipitation (rain and snow)
#' - `vpdmin`: daily minimum vapor pressure deficit
#' - `vpdmax`: daily maximum vapor pressure deficit
#'
#' ### Updates
#'
#' The daily PRISM data is available over three stability levels, or 8 versions
#' given by the [update
#' schedule](https://prism.oregonstate.edu/calendar/list.php):
#' - `stable`: data is considered final and will not change (before 6 months)
#' - `provisional`: data is considered final but may be updated (previous 6 months)
#' - `early`: data is preliminary and may be updated (this month)
#'
#' ### More on PRISM
#'
#' For more on [Parameter-elevation Relationship on Independent Slopes Model
#' (PRISM)](https://prism.oregonstate.edu/), see:
#'  -   [PRISM model methods (Daly et al., 2008)](https://prism.oregonstate.edu/documents/pubs/2008intjclim_physiographicMapping_daly.pdf)
#'  -   [PRISM dataset descriptions](https://prism.oregonstate.edu/documents/PRISM_datasets.pdf)
#'  -   [PRISM download methods](https://prism.oregonstate.edu/downloads) information (FTP, web services)
#'
#' @param sf_zones spatial feature object ([`sf`]) with zones to extract zonal
#'   statistics from PRISM daily weather data
#' @param fld_zones unique field name in `sf_zones` to include in extracted
#'   zonal statistics
#' @param zonal_csv path to output of zonal statistics (`terra::zonal()`) as
#'   table in CSV format
#' @param dir_tif directory path to store downloaded and cropped PRISM daily
#'   rasters (as GeoTIFF) across years with file name of format
#'   `prism_daily_%m-%d.tif`. The default path is
#'   `fs::path_ext_remove(zonal_csv)`.  Date and version in the raster layers
#'   will be compared with the [update
#'   schedule](https://prism.oregonstate.edu/calendar/list.php) to determine if
#'   it should be updated, otherwise will be skipped.
#' @param vars character vector of PRISM variables to download and crop. The
#'   default is `c("tmin", "tmax", "tdmean", "ppt")`. See Details for others and
#'   details.
#' @param bbox bounding box of the spatial extent to crop PRISM daily rasters,
#'   which could be bigger than `st_bbox(sf_zones)`.
#' @param date_beg defaults to the start of PRISM daily availability 1981-01-01.
#' @param date_end defaults to today's date, but will be adjusted to the most
#'   recently available data, per [update
#'   schedule](https://prism.oregonstate.edu/calendar/list.php)
#' @param redo logical whether to recalculate the zonal statistics. Defaults to
#'   False.
#' @param verbose logical whether to show informative messages on processing
#' @param zonal_fun function to apply to the `terra::zonal()` function. Defaults
#'   to "mean".
#'
#' @return data frame with the following columns:
#' - ...
#'
#' @importFrom dplyr bind_rows case_when group_by mutate select summarise tibble
#'   ungroup
#' @importFrom fs dir_create dir_delete path_ext_remove
#' @importFrom glue glue
#' @importFrom here here
#' @importFrom lubridate day days month today year ym
#' @importFrom purrr map pwalk
#' @importFrom readr parse_datetime
#' @importFrom rvest html_node html_table read_html
#' @importFrom sf st_as_sfc st_as_sf st_bbox st_crs
#' @importFrom stringr str_replace
#' @importFrom terra crs nlyr rast subset trim varnames writeRaster zonal
#' @importFrom tidyr unnest pivot_longer
#' @importFrom utils download.file
#'
#' @export
#'
#' @examples
#' dir_tmp <- tempdir()
#' tmp_csv <- file.path(dir_tmp, "prism.csv")
#'
#' d <- read_importprism(
#'   sf_zones  = tbsegshed,
#'   fld_zones = "bay_segment",
#'   zonal_csv = tmp_csv,
#'   date_beg  = as.Date("1981-01-01"),
#'   date_end  = as.Date("1981-01-03"),
#'   verbose   = T)
#'
#' d
read_importprism <- function(
    sf_zones,
    fld_zones,
    zonal_csv,
    zonal_fun = "mean",
    bbox      = sf::st_bbox(sf_zones), # c(xmin = -82.9, ymin = 27.2, xmax = -81.7, ymax = 28.6),
    dir_tif   = fs::path_ext_remove(zonal_csv),
    vars      = c("tmin", "tmax", "tdmean", "ppt"),
    date_beg  = as.Date("1981-01-01"),
    date_end  = Sys.Date(),
    redo      = F,
    verbose   = F ){

  # TODO: apply zonal outputs to tbshed + tbsegshed
  # terra::zonal()
  # librarian::shelf(
  #   dplyr, fs, glue, here, lubridate, purrr, sf, stringr, terra, tibble, tidyr)

  # zonal_csv <- here::here("../climate-change-indicators/data/prism.csv")
  # dir_tif   <- here::here("../climate-change-indicators/data/prism")

  # https://services.nacse.org/prism/data/public/4km/ppt/20240512
  # vars      <- c("tmin", "tmax", "tdmean", "ppt")
  # prism_beg <- lubridate::date("1981-01-01")
  # yesterday <- lubridate::today(tzone = "UTC") - lubridate::days(1)
  # accommodate up to 12 hrs to publish yesterday
  # yesterday_tz <- "Etc/GMT+12"
  # yesterday <- lubridate::today(tzone = yesterday_tz) - lubridate::days(1)
  # dates_all <- (prism_beg:(yesterday)) |> as.Date()

  get_updates <- function(){
    prism_beg   <- as.Date("1981-01-01")
    url_udpates <- "https://prism.oregonstate.edu/calendar/list.php"
    rx_udpates  <- "([0-9]{4}-[0-9]{2}-[0-9]{2}) \\(([0-9]{1})\\)"

    d_updates <- rvest::read_html(url_udpates) |>
      rvest::html_node("#calendar > table") |>
      rvest::html_table() |>
      dplyr::mutate(
        date = as.Date(Date, format = "%d %b %Y")) |>
      dplyr::select(-Date) |>
      dplyr::relocate(date) |>
      dplyr::rename(
        out_ver = 2) |>  # all vars are for same date_updated
      dplyr::mutate(
        date_updated = stringr::str_replace(out_ver, rx_udpates, "\\1") |>
          as.Date(),
        version      = stringr::str_replace(out_ver, rx_udpates, "\\2") |>
          as.integer()) |>
      dplyr::select(date, version, date_updated)

    # append remaining dates since beginning of PRISM with version 8
    v8_end <- min(d_updates$date) - lubridate::days(1)
    d_updates <- d_updates |>
      dplyr::bind_rows(
        dplyr::tibble(
          date         = as.Date(v8_end :prism_beg),
          version      = 8L,
          date_updated = purrr::map_chr(date, \(x){
            # set to 1st of month 6+ months ahead
            sprintf("%d-%02d-01", year(x), month(x)) |>
              as.Date() |>
              (\(y) y + months(6) + lubridate::days(20))() |>
              as.character()
          }) |> as.Date() ) ) |>
      dplyr::arrange(desc(date), desc(version))

    # confirm no duplicates
    stopifnot( sum(duplicated(d_updates$date)) == 0 )
    # confirm no missing dates
    stopifnot(all( as.Date(prism_beg : max(d_updates$date)) == sort(d_updates$date) ))

    d_updates
  }
  d_updates <- get_updates()

  # OLD d_done ----
  #
  #   # dates_all <- (date_beg:date_end) |> as.Date()
  #   dates_all <- d_updates$date_obs
  #   rx_tif    <- "prism_daily_([0-9]{2})-([0-9]{2}).tif"
  #   rx_lyr    <- "PRISM_(.*)_(.*)_(.*)_(.*)_bil"
  #
  #   d_done <- tibble::tibble(
  #     path_tif = list.files(dir_tif, ".*\\.tif$", full.names = T),
  #     tif      = basename(path_tif),
  #     tif_md   = stringr::str_replace(tif, rx_tif, "\\1-\\2"),
  #     tif_mo   = stringr::str_replace(tif, rx_tif, "\\1"),
  #     tif_day  = stringr::str_replace(tif, rx_tif, "\\2") ) |>
  #     dplyr::mutate(
  #       lyr = purrr::map(path_tif, \(path_tif) terra::rast(path_tif) |> names() ) ) |>
  #     tidyr::unnest(lyr) |>
  #     dplyr::mutate(
  #       lyr_var       = stringr::str_replace(lyr, rx_lyr, "\\1"),
  #       lyr_stability = stringr::str_replace(lyr, rx_lyr, "\\2"),
  #       lyr_scale     = stringr::str_replace(lyr, rx_lyr, "\\3"),
  #       lyr_date      = stringr::str_replace(lyr, rx_lyr, "\\4") |>
  #         as.Date(format = "%Y%m%d")) |>
  #     dplyr::arrange(tif_md, lyr_date, lyr_var) # order by: month-day, date, variable

  # DEBUG: rename PRISM layers {date}_{var}_v{ver} ----
  #   librarian::shelf(
  #     dplyr, fs, glue, here, lubridate, purrr, sf, stringr, terra, tibble, tidyr)
  #
  #   d_done2 <- d_done |>
  #     left_join(
  #       d_updates |>
  #         arrange(date_obs),
  #       by = c("lyr_date" = "date_obs")) |>
  #     mutate(
  #       lyr_yr  = year(lyr_date),
  #       lyr_new = glue("{lyr_date}_{lyr_var}_v{ver}")) |>
  #     arrange(lyr_new) |>
  #     group_by(path_tif) |>
  #     nest()
  #
  #
  #   d_done2 |>
  #     ungroup() |>
  #     dplyr::slice(-1) |>
  #     pwalk(\(path_tif, data){
  #       r <- terra::rast(path_tif)
  #       x <- data
  #
  #       stopifnot(nlyr(r) == length(x$lyr_new))
  #       x <- x |>
  #         left_join(
  #           tibble(
  #             name_r = names(r),
  #             i_r    = 1:terra::nlyr(r)),
  #           by = c("lyr" = "name_r") )
  #       stopifnot(any(!is.na(x$i_r)))
  #
  #       r2 <- terra::subset(r, x$i_r)
  #       names(r2) <- x$lyr_new
  #
  #       tmp <- tempfile(fileext = ".tif")
  #       terra::writeRaster(
  #         r2, tmp, gdal = c("COMPRESS=DEFLATE"))
  #       fs::file_move(tmp, path_tif)
  #     })

  # DEBUG: rename PRISM layers {date}_{var}_v{ver}-{date_updated} ----
  # librarian::shelf(
  #   dplyr, fs, glue, here, lubridate, purrr, sf, stringr, terra, tibble, tidyr)
  #
  # d_done2 <- d_done |>
  #   left_join(
  #     d_updates,
  #     by = c("date","version")) |>
  #   mutate(
  #     lyr_new = glue("{date}_{variable}_v{version}-{date_updated}")) |>
  #   arrange(lyr_new) |>
  #   group_by(path_tif) |>
  #   nest()
  #
  # d_done2 |>
  #   ungroup() |>
  #   # dplyr::slice(-1) |>
  #   pwalk(\(path_tif, data){
  #     r <- terra::rast(path_tif)
  #     x <- data
  #
  #     stopifnot(nlyr(r) == length(x$lyr_new))
  #     x <- x |>
  #       left_join(
  #         tibble(
  #           name_r = names(r),
  #           i_r    = 1:terra::nlyr(r)),
  #         by = c("lyr" = "name_r") )
  #     stopifnot(any(!is.na(x$i_r)))
  #
  #     r2 <- terra::subset(r, x$i_r)
  #     names(r2) <- x$lyr_new
  #
  #     tmp <- tempfile(fileext = ".tif")
  #     terra::writeRaster(
  #       r2, tmp, gdal = c("COMPRESS=DEFLATE"))
  #     fs::file_move(tmp, path_tif)
  #   })

  # d_done ----

  rx_tif    <- "prism_daily_([0-9]{2})-([0-9]{2}).tif"
  rx_lyr    <- "([-0-9]{10})_([A-z]+)_v([1-8]{1})-([-0-9]{10})"

  d_done <- dplyr::tibble(
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

  # OLD d_todo ----
  # # define expected stability by date
  # early_end  <- lubridate::today(tzone = "UTC") - lubridate::days(1)
  # early_beg  <- lubridate::ym(glue::glue("{lubridate::year(early_end)}-{lubridate::month(early_end)}"))
  # prov_end   <- early_beg - days(1)
  # prov_beg   <- early_beg - months(6)
  # stable_end <- prov_beg - days(1)
  # stable_beg <- prism_beg
  # # early:       2024-05-01 to 2024-05-06 (this month)
  # # provisional: 2023-11-01	to 2024-04-30 (previous 6 months)
  # # stable:      1981-01-01 to 2023-10-31 (before 6 months)
  #
  # # 2023-11-01
  #
  # d_todo <- tibble::tibble(
  #   lyr_var = vars |> sort()) |>
  #   dplyr::cross_join(
  #     tibble::tibble(
  #       lyr_date = dates_all) |>
  #       dplyr::mutate(
  #         lyr_stability = cut(
  #           lyr_date,
  #           breaks = c(stable_beg, stable_end, prov_beg, prov_end, early_beg, early_end),
  #           labels = c("stable", "stable", "provisional", "provisional", "early"),
  #           include.lowest = T) ) ) |>
  #   dplyr::anti_join(
  #     d_done |>
  #       dplyr::select(lyr_date, lyr_var, lyr_stability) |>
  #       dplyr::arrange(lyr_date, lyr_var, lyr_stability),
  #     by = c("lyr_date", "lyr_var", "lyr_stability")) |>
  #   dplyr::arrange(lyr_date, lyr_var, lyr_stability)

  # d_todo ----

  d_todo <- d_updates |>
    filter(
      date >= !!date_beg,
      date <= !!date_end) |>
    cross_join(
      tibble(
        variable = vars)) |>
    dplyr::anti_join(
      d_done |>
        dplyr::select(date, variable, version),
      by = c("date", "variable", "version")) |>
    dplyr::arrange(date, variable, version)

  get_lyrs <- function(r){
    tibble::tibble(
      idx = 1:terra::nlyr(r),
      lyr = names(r)) |>
      mutate(
        date         = stringr::str_replace(lyr, rx_lyr, "\\1") |>
          as.Date(),
        variable     = stringr::str_replace(lyr, rx_lyr, "\\2"),
        version      = stringr::str_replace(lyr, rx_lyr, "\\3") |>
          as.integer(),
        date_updated = stringr::str_replace(lyr, rx_lyr, "\\4") |>
          as.Date())
  }

  crs_proj  = "+proj=longlat +datum=NAD83 +no_defs"
  ply_bb <- sf::st_bbox(bbox, crs = "epsg:4326") |>
    sf::st_as_sfc() |>
    sf::st_as_sf() |>
    st_transform(crs_proj)

  prism_get_daily <- function(
    var, date, version, date_updated){
    # dir_tif = here::here("data/prism"),
    # crs_proj  = "+proj=longlat +datum=NAD83 +no_defs",
    # bb        = c(xmin = -82.9, ymin = 27.2, xmax = -81.7, ymax = 28.6)){
    # TODO: + sf_aoi spatial feature area of interest. Expecting `sf::st_crs(tbeptools::tbshed) == sf::st_crs(4326)`

    # DEBUG
    # var          = "ppt"
    # date         = as.Date("2024-05-13")
    # version      = 2
    # date_updated = as.Date("2024-05-18")

    u <- sprintf("https://services.nacse.org/prism/data/public/4km/%s/%s", var, format(date, "%Y%m%d"))
    # https://services.nacse.org/prism/data/public/4km/ppt/20231211
    # https://services.nacse.org/prism/data/public/4km/tdmean/20231211

    # date = as.Date("1981-01-01"); var = "tdmean"
    z <- glue::glue("{dir_tif}/temp_{date}_{var}.zip")
    dir_z <- fs::path_ext_remove(z)

    if (verbose)
      message(glue::glue("Downloading PRISM daily {date} {var}"))

    download.file(u, z, quiet = T)

    # If downloaded zip < 1 KB, assume one of these errors:
    # - You have tried to download the file PRISM_tdmean_stable_4kmD2_19810101_bil.zip more than twice in one day (Pacific local time).  Note that repeated offenses may result in your IP address being blocked.
    # - Invalid date: 20240513</br>Valid day ranges for the given month are 1 to 12 [real reason: requesting beyond available date, ie not yet published]
    if (file.size(z) < 1000)
      stop(readLines(z, warn=F))

    dir.create(dir_z, showWarnings = F)
    unzip(z, exdir = dir_z)
    unlink(z)

    r_new <- list.files(dir_z, "PRISM_.*_bil\\.bil$", full.names = T) |>
      # file.exists()
      terra::rast() |>
      terra::crop(ply_bb, mask = T, touches = T) |>
      terra::trim()
    terra::crs(r_new) <- crs_proj

    names(r_new) <- glue::glue("{date}_{var}_v{version}-{date_updated}")
    terra::varnames(r_new) <- ""

    md_tif <- sprintf("%s/prism_daily_%02d-%02d.tif", dir_tif, month(date), lubridate::day(date))

    if (!file.exists(md_tif)){
      terra::writeRaster(
        r_new, md_tif,
        datatype = "FLT4S",
        filetype = "GTiff", gdal = c("COMPRESS=DEFLATE"),
        overwrite = T)
      dir_delete(dir_z)
      return(T)
    }

    r_md  <- rast(md_tif)
    df_md <- get_lyrs(r_md)

    # remove old date-var, eg for stability improved
    i_lyr_rm <- df_md |>
      filter(
        date     == !!date,
        variable == !!var) |>
      pull(idx)
    if (length(i_lyr_rm) > 0)
      r_md <- terra::subset(r_md, i_lyr_rm, negate = T)

    # combine old and new
    r_md <- c(r_md, r_new)

    # write out
    tmp <- tempfile(fileext = ".tif")
    terra::writeRaster(
      r_md, tmp,
      datatype = "FLT4S",
      filetype = "GTiff", gdal = c("COMPRESS=DEFLATE"),
      overwrite = T)
    fs::file_move(tmp, md_tif)
    fs::dir_delete(dir_z)
    return(T)
  }

  msg <- ifelse(
    nrow(d_todo) > 0,
    glue::glue("read_importprism(): {nrow(d_todo)} variable-dates {paste(range(d_todo$date), collapse=' to ')} to download and crop "),
    glue::glue("read_importprism(): `dir_tif` already has all available data {date_beg} to {date_end}"))
  if (verbose)
    message(msg)

  # browser()
  d_todo |>
    select(var = variable, date, version, date_updated) |>
    pwalk(prism_get_daily)

  # TODO: return zonal stats ----
  tifs <- list.files(dir_tif, ".*\\.tif$", full.names = T)
  r <- rast(tifs)
  # mapview::mapView(tbeptools::tbsegshed) +
  #   mapview::mapView(tbeptools::tbshed)


  # TODO: skip zonal stats on already done
  # TODO: consider parquet format (with duckdb) or compressed since 24 MB
  d_z <- terra::zonal(
    x     = r,
    z     = terra::vect(
      sf_zonal |>
        select(dplyr::all_of(fld_zones)) ),
    fun   = zonal_fun,
    exact = T,
    na.rm = T,
    as.polygons = T) |>
    sf::st_as_sf() |>
    sf::st_drop_geometry() |>
    tidyr::pivot_longer(
      cols = -any_of(fld_zones), names_to = "lyr", values_to = zonal_fun)  |>
    dplyr::mutate(
      date         = stringr::str_replace(lyr, rx_lyr, "\\1") |>
        as.Date(),
      variable     = stringr::str_replace(lyr, rx_lyr, "\\2"),
      version      = stringr::str_replace(lyr, rx_lyr, "\\3") |>
        as.integer(),
      date_updated = stringr::str_replace(lyr, rx_lyr, "\\4") |>
        as.Date()) |>
    dplyr::select(-lyr)
  readr::write_csv(d_z, zonal_csv) # 24 MB

  readr::read_csv(zonal_csv)
}


