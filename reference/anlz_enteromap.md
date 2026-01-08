# Assign threshold categories to Enterococcus data

Assign threshold categories to Enterococcus data

## Usage

``` r
anlz_enteromap(
  fibdata,
  yrsel = NULL,
  mosel = NULL,
  areasel = NULL,
  wetdry = FALSE,
  precipdata = NULL,
  temporal_window = NULL,
  wet_threshold = NULL,
  assf = FALSE
)
```

## Arguments

- fibdata:

  data frame of Enterococcus sample data as returned by
  [`enterodata`](https://tbep-tech.github.io/tbeptools/reference/enterodata.md)
  or
  [`anlz_fibwetdry`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibwetdry.md)

- yrsel:

  optional numeric to filter data by year

- mosel:

  optional numeric to filter data by month

- areasel:

  optional character string to filter output by stations in the
  `long_name` column of `enterodata`, see details

- wetdry:

  logical; if `TRUE`, incorporate wet/dry differences (this will result
  in a call to
  [`anlz_fibwetdry`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibwetdry.md),
  in which case `temporal_window` and `wet_threshold` are required). If
  `FALSE` (default), do not differentiate between wet and dry samples.

- precipdata:

  input data frame as returned by
  [`read_importrain`](https://tbep-tech.github.io/tbeptools/reference/read_importrain.md).
  columns should be: station, date (yyyy-mm-dd), rain (in inches). The
  object
  [`catchprecip`](https://tbep-tech.github.io/tbeptools/reference/catchprecip.md)
  has this data from 1995-2023 for select Enterococcus stations. If
  `NULL`, defaults to
  [`catchprecip`](https://tbep-tech.github.io/tbeptools/reference/catchprecip.md).

- temporal_window:

  numeric; required if `wetdry` is `TRUE`. number of days precipitation
  should be summed over (1 = day of sample only; 2 = day of sample + day
  before; etc.)

- wet_threshold:

  numeric; required if `wetdry` is `TRUE`. inches accumulated through
  the defined temporal window, above which a sample should be defined as
  being from a 'wet' time period

- assf:

  logical indicating if the data are further processed as a simple
  features object with additional columns for
  [`show_enteromap`](https://tbep-tech.github.io/tbeptools/reference/show_enteromap.md)

## Value

A `data.frame` similar to `fibdata` if `assf = FALSE` with additional
columns describing station categories and optionally filtered by
arguments passed to the function. A `sf` object if `assf = TRUE` with
additional columns for
[`show_enteromap`](https://tbep-tech.github.io/tbeptools/reference/show_enteromap.md).

## Details

This function is based on
[`anlz_fibmap`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibmap.md),
but is specific to Enterococcus data downloaded via
[`read_importentero`](https://tbep-tech.github.io/tbeptools/reference/read_importentero.md).
It creates categories for mapping using
[`show_enteromap`](https://tbep-tech.github.io/tbeptools/reference/show_enteromap.md).
Optionally, if samples have been defined as 'wet' or not via
[`anlz_fibwetdry`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibwetdry.md),
this can be represented via symbols on the map. Categories based on
relevant thresholds are assigned to each observation. The categories are
specific to Enterococcus in marine waters (`class` of 2 or 3M). A
station is categorized into one of four ranges defined by the thresholds
as noted in the `cat` column of the output, with corresponding colors
appropriate for each range as noted in the `col` column of the output.

The `areasel` argument can indicate valid entries in the `long_name`
column of `enterodata`. For example, use `"Old Tampa Bay"` for stations
in the subwatershed of Old Tampa Bay, where rows in `enterodata` are
filtered based on the the selection. All stations are returned if this
argument is set as `NULL` (default). All valid options for `areasel`
include `"Old Tampa Bay"`, `"Hillsborough Bay"`, `"Middle Tampa Bay"`,
`"Lower Tampa Bay"`, `"Boca Ciega Bay"`, or `"Manatee River"`. One to
any of the options can be used.

## Examples

``` r
anlz_enteromap(enterodata, yrsel = 2020, mosel = 9)
#> # A tibble: 39 × 12
#>    station     long_name    yr    mo Latitude Longitude entero cat   col   ind  
#>    <chr>       <chr>     <dbl> <dbl>    <dbl>     <dbl>  <dbl> <fct> <chr> <chr>
#>  1 21FLHILL_W… Old Tamp…  2020     9     28.0     -82.6    380 130 … #EE7… Ente…
#>  2 21FLHILL_W… Old Tamp…  2020     9     28.0     -82.6    380 130 … #EE7… Ente…
#>  3 21FLHILL_W… Old Tamp…  2020     9     28.0     -82.6    490 130 … #EE7… Ente…
#>  4 21FLHILL_W… Old Tamp…  2020     9     28.0     -82.6    725 130 … #EE7… Ente…
#>  5 21FLPDEM_W… Old Tamp…  2020     9     28.0     -82.7    703 130 … #EE7… Ente…
#>  6 21FLPDEM_W… Old Tamp…  2020     9     27.9     -82.7     10 < 35  #2DC… Ente…
#>  7 21FLPDEM_W… Old Tamp…  2020     9     27.9     -82.7   1990 > 999 #CC3… Ente…
#>  8 21FLPDEM_W… Old Tamp…  2020     9     27.9     -82.7    171 130 … #EE7… Ente…
#>  9 21FLTPA_WQ… Old Tamp…  2020     9     27.9     -82.6    908 130 … #EE7… Ente…
#> 10 21FLHILL_W… Hillsbor…  2020     9     27.9     -82.4      1 < 35  #2DC… Ente…
#> # ℹ 29 more rows
#> # ℹ 2 more variables: indnm <chr>, conc <dbl>

# differentiate wet/dry samples in that time frame
anlz_enteromap(enterodata, yrsel = 2020, mosel = 9, wetdry = TRUE,
               temporal_window = 2, wet_threshold = 0.5)
#> # A tibble: 39 × 13
#>    station     long_name    yr    mo Latitude Longitude entero cat   col   ind  
#>    <chr>       <chr>     <dbl> <dbl>    <dbl>     <dbl>  <dbl> <fct> <chr> <chr>
#>  1 21FLHILL_W… Old Tamp…  2020     9     28.0     -82.6    380 130 … #EE7… Ente…
#>  2 21FLHILL_W… Old Tamp…  2020     9     28.0     -82.6    380 130 … #EE7… Ente…
#>  3 21FLHILL_W… Old Tamp…  2020     9     28.0     -82.6    490 130 … #EE7… Ente…
#>  4 21FLHILL_W… Old Tamp…  2020     9     28.0     -82.6    725 130 … #EE7… Ente…
#>  5 21FLPDEM_W… Old Tamp…  2020     9     28.0     -82.7    703 130 … #EE7… Ente…
#>  6 21FLPDEM_W… Old Tamp…  2020     9     27.9     -82.7     10 < 35  #2DC… Ente…
#>  7 21FLPDEM_W… Old Tamp…  2020     9     27.9     -82.7   1990 > 999 #CC3… Ente…
#>  8 21FLPDEM_W… Old Tamp…  2020     9     27.9     -82.7    171 130 … #EE7… Ente…
#>  9 21FLTPA_WQ… Old Tamp…  2020     9     27.9     -82.6    908 130 … #EE7… Ente…
#> 10 21FLHILL_W… Hillsbor…  2020     9     27.9     -82.4      1 < 35  #2DC… Ente…
#> # ℹ 29 more rows
#> # ℹ 3 more variables: indnm <chr>, conc <dbl>, wet_sample <lgl>

# as sf object
anlz_enteromap(enterodata, assf = TRUE)
#> Simple feature collection with 6195 features and 14 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -82.74598 ymin: 27.49433 xmax: -82.38168 ymax: 28.02571
#> Geodetic CRS:  WGS 84
#> # A tibble: 6,195 × 15
#>    station     long_name    yr    mo Latitude Longitude entero cat   col   ind  
#>    <chr>       <chr>     <dbl> <dbl>    <dbl>     <dbl>  <dbl> <fct> <chr> <chr>
#>  1 21FLHILL_W… Old Tamp…  2001     1     28.0     -82.6     80 35 -… #E9C… Ente…
#>  2 21FLHILL_W… Old Tamp…  2001     2     28.0     -82.6    360 130 … #EE7… Ente…
#>  3 21FLHILL_W… Old Tamp…  2001     3     28.0     -82.6   3900 > 999 #CC3… Ente…
#>  4 21FLHILL_W… Old Tamp…  2001     4     28.0     -82.6     20 < 35  #2DC… Ente…
#>  5 21FLHILL_W… Old Tamp…  2001     7     28.0     -82.6   1300 > 999 #CC3… Ente…
#>  6 21FLHILL_W… Old Tamp…  2001     8     28.0     -82.6    260 130 … #EE7… Ente…
#>  7 21FLHILL_W… Old Tamp…  2001     9     28.0     -82.6    420 130 … #EE7… Ente…
#>  8 21FLHILL_W… Old Tamp…  2001    10     28.0     -82.6    520 130 … #EE7… Ente…
#>  9 21FLHILL_W… Old Tamp…  2001    11     28.0     -82.6     60 35 -… #E9C… Ente…
#> 10 21FLHILL_W… Old Tamp…  2001    12     28.0     -82.6    340 130 … #EE7… Ente…
#> # ℹ 6,185 more rows
#> # ℹ 5 more variables: grp <fct>, conc <dbl>, wet_sample <fct>,
#> #   geometry <POINT [°]>, lab <chr>
```
