# Daily precip by catchment for selected Enterococcus stations

Daily precip by catchment for selected Enterococcus stations

## Usage

``` r
catchprecip
```

## Format

A data frame with three columns:

- station:

  a character string of the Water Quality Portal station name

- date:

  a date

- rain:

  a number; inches of rain for that date, averaged across all pixels in
  the station's catchment

## Source

Southwest Florida Management District radar-estimated daily rainfall
data, <ftp://ftp.swfwmd.state.fl.us/pub/radar_rainfall/Daily_Data/>

## Details

Daily precipitation data for multiple years, provided by the Southwest
Florida Water Management District, were downloaded at the pixel level
and averaged to the catchment level for key Enterococcus sampling
stations. Created using
[`read_importrainmany`](https://tbep-tech.github.io/tbeptools/reference/read_importrainmany.md).

## Examples

``` r
if (FALSE) { # \dontrun{
catchprecip <- read_importrainmany(1995:2025, quiet = F)

save(catchprecip, file = 'data/catchprecip.RData')
} # }
```
