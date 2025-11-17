# Identify Fecal Indicator Bacteria samples as coming from a 'wet' or 'dry' time period

Identify Fecal Indicator Bacteria samples as coming from a 'wet' or
'dry' time period

## Usage

``` r
anlz_fibwetdry(fibdata, precipdata, temporal_window = 2, wet_threshold = 0.5)
```

## Arguments

- fibdata:

  input data frame

- precipdata:

  input data frame as returned by
  [`read_importrain`](https://tbep-tech.github.io/tbeptools/reference/read_importrain.md).
  columns should be: station, date (yyyy-mm-dd), rain (in inches). The
  object
  [`catchprecip`](https://tbep-tech.github.io/tbeptools/reference/catchprecip.md)
  has this data from 1995-2023 for select stations.

- temporal_window:

  numeric, number of days precipitation should be summed over (1 = day
  of sample only; 2 = day of sample + day before; etc.)

- wet_threshold:

  numeric, inches accumulated through the defined temporal window, above
  which a sample should be defined as being from a 'wet' time period

## Value

a data frame; the original fibdata data frame with three additional
columns. `rain_sampleDay` is the total rain (inches) on the day of
sampling, `rain_total` is the total rain (inches) for the period of time
defined by `temporal_window`, and `wet_sample` is logical, indicating
whether the rainfall for that station's catchment exceeded the amount
over the time period specified in args.

## Details

This function allows the user to specify a threshold for declaring a
sample to be taken after an important amount of rain over an important
amount of days, and declaring it to be 'wet'. This is of interest
because samples taken after significant precipitation (definitions of
this vary, which is why the user can specify desired thresholds) are
more likely to exceed relevant bacterial thresholds. Identifying samples
as 'wet' or not allows for calculation of further indices for wet and
dry subsets of samples.

## Examples

``` r
entero_wetdry <- anlz_fibwetdry(enterodata, catchprecip)
head(entero_wetdry)
#> # A tibble: 6 × 19
#>   date          yr    mo time  time_zone long_name    bay_segment station entero
#>   <date>     <dbl> <dbl> <chr> <chr>     <chr>        <chr>       <chr>    <dbl>
#> 1 2001-01-16  2001     1 ""    ""        Old Tampa B… OTB         21FLHI…     80
#> 2 2001-02-20  2001     2 ""    ""        Old Tampa B… OTB         21FLHI…    360
#> 3 2001-03-20  2001     3 ""    ""        Old Tampa B… OTB         21FLHI…   3900
#> 4 2001-04-17  2001     4 ""    ""        Old Tampa B… OTB         21FLHI…     20
#> 5 2001-05-15  2001     5 ""    ""        Old Tampa B… OTB         21FLHI…     NA
#> 6 2001-06-19  2001     6 ""    ""        Old Tampa B… OTB         21FLHI…     NA
#> # ℹ 10 more variables: entero_censored <lgl>, MDL <int>, entero_units <chr>,
#> #   qualifier <lgl>, LabComments <lgl>, Latitude <dbl>, Longitude <dbl>,
#> #   rain_sampleDay <dbl>, rain_total <dbl>, wet_sample <lgl>
```
