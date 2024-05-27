#' Import PRISM daily weather data
#'
#' Download and crop the latest weather rasters from Parameter-elevation
#' Relationship on Independent Slopes Model (PRISM). Summarize by zone and save
#' as CSV.
#'
#' The [Parameter-elevation Relationship on Independent Slopes Model
#' (PRISM)](https://prism.oregonstate.edu/) is a combined dataset consisting of
#' ground gauge station and RADAR products, at a 4km grid resolution covering
#' the contiguous United States from 1981 to present.
#'
#' ### Variables
#'
#' The available variables (`vars`) are:
#' - `tmin`: minimum temperature (ºC)
#' - `tmax`: maximum temperature (ºC)
#' - `tmean`: mean temperature (ºC; `tmean = mean(tmin, tmax)`)
#' - `tdmean`: mean dew point temperature (ºC)
#' - `ppt`: total precipitation (mm; rain and snow)
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
#' ### Processing details
#'
#' 1. The PRISM [update
#' schedule](https://prism.oregonstate.edu/calendar/list.php) is downloaded and
#' processed in a data frame to understand the latest date and variable
#' available, along with version and date updated.
#'
#' 1. Any existing rasters in `dir_tif` are fetched based on a common naming
#' structure for the raster file name (`prism_daily_{month}-{day}.tif`) and
#' layer names (`{date}_{variable}_v{version}-{date_updated}`) into a data
#' frame.
#'
#' 1. Based on intersecting above with the requested dates, any missing or more
#' recently updated variable-date PRISM rasters are downloaded and cropped to
#' the bounding box (`bbox`) and written as GeoTIFFs (*.tif). Layers are renamed
#' to include extra information on `{version}` (1-8) and `{date_udpated}`.
#'
#' 1. Summary statistics (based on `sf_zones` and `zonal_fun`) are calculated on
#' the cropped PRISM daily rasters.
#'
#' ### More on PRISM
#'
#' For more on [Parameter-elevation Relationship on Independent Slopes Model
#' (PRISM)](https://prism.oregonstate.edu/), see:
#'  -   [PRISM model methods (Daly et al., 2008)](https://prism.oregonstate.edu/documents/pubs/2008intjclim_physiographicMapping_daly.pdf)
#'  -   [PRISM dataset descriptions](https://prism.oregonstate.edu/documents/PRISM_datasets.pdf)
#'  -   [PRISM download methods](https://prism.oregonstate.edu/downloads) information (FTP, web services)
#'
#' @param vars character vector of PRISM variables to download and crop. The
#'   default is `c("tmin", "tmax", "tdmean", "ppt")`. See Details for others and
#'   details.
#' @param date_beg defaults to the start of PRISM daily availability 1981-01-01.
#' @param date_end defaults to today's date, but will be adjusted to the most
#'   recently available data, per [update
#'   schedule](https://prism.oregonstate.edu/calendar/list.php). CAUTION: If you
#'   try to request the same date-variable in a given day, you will get an error
#'   from the PRISM service with a message like "You have tried to download the
#'   file PRISM_tdmean_stable_4kmD2_19810101_bil.zip more than twice in one day
#'   (Pacific local time).  Note that repeated offenses may result in your IP
#'   address being blocked."
#' @param bbox bounding box of the spatial extent to crop PRISM daily rasters,
#'   which could be bigger than `st_bbox(sf_zones)`.
#' @param dir_tif directory path to store downloaded and cropped PRISM daily
#'   rasters (as GeoTIFF) across years with file name of format
#'   `prism_daily_{month}-{day}.tif`. The default path is
#'   `fs::path_ext_remove(zonal_csv)`.  Date and version in the raster layers
#'   will be compared with the [update
#'   schedule](https://prism.oregonstate.edu/calendar/list.php) to determine if
#'   it should be updated, otherwise will be skipped.
#' @param sf_zones spatial feature object ([`sf`]) with zones to extract zonal
#'   statistics from PRISM daily weather data
#' @param fld_zones character vector of unique field name(s) in `sf_zones` to
#'   include in extracted zonal statistics
#' @param zonal_fun function to apply to the `terra::zonal()` function. Defaults
#'   to `"mean"`. Other options are `"min"`, `"max"`, `"sum"`, `"isNA"`, and
#'   `"notNA"`.
#' @param zonal_csv path to output of zonal statistics (`terra::zonal()`) as
#'   table in CSV format
#' @param redo_zonal logical whether to recalculate the zonal statistics.
#'   Defaults to False.
#' @param verbose logical whether to show informative messages on processing
#'
#' @return data frame with the following columns:
#' - `{fld_zones}` column(s) specified from input `sf_zones`
#' - `{zonal_fun}`: value of input function (e.g. `"mean"`) summarizing raster to zone
#' - `date`: date of PRISM daily raster
#' - `variable`: PRISM variable
#' - `version`: PRISM version
#' - `date_updated`: date of PRISM daily raster update
#'
#' @importFrom dplyr any_of bind_rows case_when group_by mutate select summarise
#'   tibble ungroup
#' @importFrom fs dir_create dir_delete path_ext_remove
#' @importFrom glue glue
#' @importFrom here here
#' @importFrom lubridate day days month today year ym
#' @importFrom purrr map pwalk
#' @importFrom readr parse_datetime
#' @importFrom rvest html_node html_table read_html
#' @importFrom sf st_as_sfc st_as_sf st_bbox st_crs
#' @importFrom stringr str_replace
#' @importFrom terra crs nlyr plet rast subset trim varnames writeRaster zonal
#' @importFrom tidyr unnest pivot_longer
#' @importFrom utils download.file
#'
#' @export
#'
#' @concept read
#'
#' @examples
#' # setup output directory and table
#' dir_tif   <- here::here("inst/prism")
#' zonal_csv <- file.path(dir_tif, "_zones.csv")
#'
#' # run function for Tampa Bay watersheds for first 3 days and 4 variables
#' d <- read_importprism(
#'   vars      = c("tmin", "tmax", "tdmean", "ppt"),
#'   date_beg  = as.Date("1981-01-01"),
#'   date_end  = as.Date("1981-01-03"),
#'   dir_tif   = dir_tif,
#'   sf_zones  = tbsegshed,
#'   fld_zones = "bay_segment",
#'   zonal_csv = zonal_csv)
#'
#' # show raster files, layers and plot
#' tifs <- list.files(dir_tif, pattern = ".tif$", full.names = T)
#' basename(tifs)
#' r <- terra::rast(tifs[1])
#' r
#' names(r)
#' terra::plet(
#'   r[[3]],
#'   main  = names(r)[3],
#'   col   = "Spectral",
#'   tiles = "CartoDB.DarkMatter")
#'
#' # show summary by zone
#' d
read_importprism <- function(
    vars       = c("tmin", "tmax", "tdmean", "ppt"),
    date_beg   = as.Date("1981-01-01"),
    date_end   = Sys.Date(),
    bbox       = sf::st_bbox(sf_zones),
    dir_tif    = fs::path_ext_remove(zonal_csv),
    sf_zones,
    fld_zones,
    zonal_fun  = "mean",
    zonal_csv,
    redo_zonal = F,
    verbose    = F ){

  # TODO: consider reading zonal_csv without fetching missing PRISM rasters

  # check input arguments ----

  stopifnot("sf" %in% class(sf_zones))
  stopifnot(fld_zones %in% names(sf_zones))
  stopifnot(class(c(date_beg, date_end)) == "Date")
  stopifnot(class(bbox) %in% c("bbox", "numeric"))
  stopifnot(zonal_fun %in% c("mean", "min", "max", "sum", "isNA", "notNA"))

  if (!dir.exists(dir_tif))
    dir.create(dir_tif, recursive = T)

  # helper functions ----
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

  get_done <- function(){
    read_prism_rasters(dir_tif)
  }

  get_todo <- function(){
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
    d_todo
  }

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

  prism_get_var_date <- function(
    var, date, version, date_updated){

    u <- sprintf("https://services.nacse.org/prism/data/public/4km/%s/%s", var, format(date, "%Y%m%d"))

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
      terra::rast() |>
      terra::crop(ply_bb, mask = T, touches = T) |>
      terra::trim()
    terra::crs(r_new) <- crs_prism

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

  get_zonal <- function(){
    d_z <- terra::zonal(
      x     = r,
      z     = terra::vect(
        sf_zones |>
          dplyr::select(dplyr::all_of(fld_zones)) ),
      fun   = zonal_fun,
      exact = T,
      na.rm = T,
      as.polygons = T) |>
      sf::st_as_sf() |>
      sf::st_drop_geometry() |>
      tidyr::pivot_longer(
        cols      = -dplyr::any_of(fld_zones),
        names_to  = "lyr",
        values_to = zonal_fun)  |>
      dplyr::mutate(
        date         = stringr::str_replace(lyr, rx_lyr, "\\1") |>
          as.Date(),
        variable     = stringr::str_replace(lyr, rx_lyr, "\\2"),
        version      = stringr::str_replace(lyr, rx_lyr, "\\3") |>
          as.integer(),
        date_updated = stringr::str_replace(lyr, rx_lyr, "\\4") |>
          as.Date()) |>
      dplyr::select(-lyr)

    readr::write_csv(d_z, zonal_csv)

    readr::read_csv(zonal_csv, show_col_types = F)
  }

  # variables ----
  crs_prism  = "+proj=longlat +datum=NAD83 +no_defs"

  # * bounding box for PRISM daily data trimming
  if (class(bbox) == "numeric"){
    ply_bb <- sf::st_bbox(bbox, crs = "epsg:4326")
  } else {
    ply_bb <- bbox
  }
  ply_bb <- ply_bb |>
    sf::st_as_sfc() |>
    sf::st_as_sf() |>
    st_transform(crs_prism)

  # * regular expressions ----
  rx_tif    <- "prism_daily_([0-9]{2})-([0-9]{2}).tif"
  rx_lyr    <- "([-0-9]{10})_([A-z]+)_v([1-8]{1})-([-0-9]{10})"

  # evaluate requested, updated, done and todo PRISM rasters ----
  d_req <- dplyr::tibble(
    date = as.Date(date_beg:date_end) ) |>
    dplyr::cross_join(
      dplyr::tibble(
        variable = vars))
  d_updates <- get_updates()
  d_done    <- get_done()
  d_todo    <- get_todo()

  if (verbose){
    msg <- ifelse(
      nrow(d_todo) > 0,
      glue::glue(
        "Of {nrow(d_req)} variable-dates requested, {nrow(d_todo)} are newer or
           missing so will be downloaded and cropped to the bounding box."),
      glue::glue(
        "All {nrow(d_req)} variable-dates requested already exist in `dir_tif`
           and are up-to-date."))
    message(msg)
  }

  # * iterate over variable-dates, fetching and cropping PRISM rasters ----
  d_todo |>
    select(var = variable, date, version, date_updated) |>
    pwalk(prism_get_var_date)

  # summarize rasters by zone ----
  tifs <- list.files(dir_tif, ".*\\.tif$", full.names = T)
  r <- rast(tifs)

  # TODO: skip zonal stats on already done if redo_zonal = F
  # TODO: consider parquet format (with duckdb) or compressed since 24 MB
  if (verbose)
    message(glue::glue("Summarizing rasters by zone to csv"))

  d_z <- get_zonal()
  d_z
}


