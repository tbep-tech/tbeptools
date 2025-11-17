# Import PRISM daily weather data

Download and crop the latest weather rasters from Parameter-elevation
Relationship on Independent Slopes Model (PRISM). Summarize by zone and
save as CSV.

## Usage

``` r
read_importprism(
  vars = c("tmin", "tmax", "tdmean", "ppt"),
  vars_ytd = c("ppt"),
  date_beg = as.Date("1981-01-01"),
  date_end = Sys.Date(),
  bbox = sf::st_bbox(sf_zones),
  dir_tif = sub("\\.[^.]*$", "", zonal_csv),
  pfx_tif = "prism_daily_",
  sf_zones,
  fld_zones,
  zonal_fun = "mean",
  zonal_csv,
  redo_zonal = F,
  verbose = F
)
```

## Arguments

- vars:

  character vector of PRISM variables to download and crop. The default
  is `c("tmin", "tmax", "tdmean", "ppt")`. See Details for more.

- vars_ytd:

  character vector of PRISM variables to be summed for the year to date,
  which gets recorded as a new layer with the suffix `"ytd"`. The
  default is for precipitation `c("ppt")`, so a layer `"pptytd"` gets
  added to PRISM daily rasters.

- date_beg:

  defaults to the start of PRISM daily availability 1981-01-01.

- date_end:

  defaults to today's date, but will be adjusted to the most recently
  available data, per [update
  schedule](https://prism.oregonstate.edu/calendar/list.php). CAUTION:
  If you try to request the same date-variable in a given day, you will
  get an error from the PRISM service with a message like "You have
  tried to download the file PRISM_tdmean_stable_4kmD2_19810101_bil.zip
  more than twice in one day (Pacific local time). Note that repeated
  offenses may result in your IP address being blocked."

- bbox:

  bounding box of the spatial extent to crop PRISM daily rasters, which
  could be bigger than `st_bbox(sf_zones)`.

- dir_tif:

  directory path to store downloaded and cropped PRISM daily rasters (as
  GeoTIFF) across years with file name of format
  `prism_daily_{month}-{day}.tif`. The default path is
  `sub("\\.[^.]*$", "", zonal_csv)`. Date and version in the raster
  layers will be compared with the [update
  schedule](https://prism.oregonstate.edu/calendar/list.php) to
  determine if it should be updated, otherwise will be skipped.

- pfx_tif:

  prefix for the PRISM daily raster files, appended by the month-day.
  Defaults to `"prism_daily_"`.

- sf_zones:

  spatial feature object
  ([`sf`](https://r-spatial.github.io/sf/reference/sf.html)) with zones
  to extract zonal statistics from PRISM daily weather data

- fld_zones:

  character vector of unique field name(s) in `sf_zones` to include in
  extracted zonal statistics

- zonal_fun:

  function to apply to the
  [`terra::zonal()`](https://rspatial.github.io/terra/reference/zonal.html)
  function. Defaults to `"mean"`. Other options are `"min"`, `"max"`,
  `"sum"`, `"isNA"`, and `"notNA"`.

- zonal_csv:

  path to output of zonal statistics
  ([`terra::zonal()`](https://rspatial.github.io/terra/reference/zonal.html))
  as table in CSV format

- redo_zonal:

  logical whether to recalculate the zonal statistics. Defaults to
  False.

- verbose:

  logical whether to show informative messages on processing

## Value

data frame with the following columns:

- `{fld_zones}` column(s) specified from input `sf_zones`

- `{zonal_fun}`: value of input function (e.g. `"mean"`) summarizing
  raster to zone

- `date`: date of PRISM daily raster

- `variable`: PRISM variable

- `version`: PRISM version

- `date_updated`: date of PRISM daily raster update

## Details

The [Parameter-elevation Relationship on Independent Slopes Model
(PRISM)](https://prism.oregonstate.edu/) is a combined dataset
consisting of ground gauge station and RADAR products, at a 4km grid
resolution covering the contiguous United States from 1981 to present.

### Variables

The available variables (`vars`) are:

- `tmin`: minimum temperature (ºC)

- `tmax`: maximum temperature (ºC)

- `tmean`: mean temperature (ºC; `tmean = mean(tmin, tmax)`)

- `tdmean`: mean dew point temperature (ºC)

- `ppt`: total precipitation (mm; rain and snow)

- `vpdmin`: daily minimum vapor pressure deficit

- `vpdmax`: daily maximum vapor pressure deficit

### Updates

The daily PRISM data is available over three stability levels, or 8
versions given by the [update
schedule](https://prism.oregonstate.edu/calendar/list.php):

- `stable`: data is considered final and will not change (before 6
  months)

- `provisional`: data is considered final but may be updated (previous 6
  months)

- `early`: data is preliminary and may be updated (this month)

### Processing details

1.  The PRISM [update
    schedule](https://prism.oregonstate.edu/calendar/list.php) is
    downloaded and processed in a data frame to understand the latest
    date and variable available, along with version and date updated.

2.  Any existing rasters in `dir_tif` are fetched based on a common
    naming structure for the raster file name
    (`prism_daily_{month}-{day}.tif`) and layer names
    (`{date}_{variable}_v{version}-{date_updated}`) into a data frame.

3.  Based on intersecting above with the requested dates, any missing or
    more recently updated variable-date PRISM rasters are downloaded and
    cropped to the bounding box (`bbox`) and written as GeoTIFFs
    (\*.tif). Layers are renamed to include extra information on
    `{version}` (1-8) and `{date_udpated}`.

4.  Summary statistics (based on `sf_zones` and `zonal_fun`) are
    calculated on the cropped PRISM daily rasters.

### More on PRISM

For more on [Parameter-elevation Relationship on Independent Slopes
Model (PRISM)](https://prism.oregonstate.edu/), see:

- [PRISM model methods (Daly et al.,
  2008)](https://prism.oregonstate.edu/documents/pubs/2008intjclim_physiographicMapping_daly.pdf)

- [PRISM dataset
  descriptions](https://prism.oregonstate.edu/documents/PRISM_datasets.pdf)

- [PRISM download methods](https://prism.oregonstate.edu/downloads)
  information (FTP, web services)

## Examples

``` r
if (FALSE) { # \dontrun{
# setup output directory and table
dir_tif   <- system.file("prism", package = "tbeptools")
zonal_csv <- system.file("prism/_zones.csv", package = "tbeptools")

# run function for Tampa Bay watersheds for first 3 days and 4 variables
d <- read_importprism(
  vars      = c("tdmean", "ppt"),
  date_beg  = as.Date("1981-01-01"),
  date_end  = as.Date("1981-01-02"),
  dir_tif   = dir_tif,
  sf_zones  = tbsegshed,
  fld_zones = "bay_segment",
  zonal_csv = zonal_csv)

# show raster files, layers and plot
tifs <- list.files(dir_tif, pattern = ".tif$", full.names = T)
basename(tifs)
r <- terra::rast(tifs[1])
r
names(r)
terra::plet(
  r[[3]],
  main  = names(r)[3],
  col   = "Spectral",
  tiles = "CartoDB.DarkMatter")

# show summary by zone
d
} # }
```
