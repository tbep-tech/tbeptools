# Download daily precip data and summarise by station catchment

Download daily precip data and summarise by station catchment

## Usage

``` r
read_importrain(curyr, catchpixels, mos = 1:12, quiet = T)
```

## Arguments

- curyr:

  numeric for year

- catchpixels:

  data.frame with columns named 'station' and 'pixel'. A data frame has
  been created for key Enterococcus stations, associating each station
  with all pixels in that station's catchment layer. This is the
  tbeptools object 'catchpixels'.

- mos:

  numeric vector for months to download

- quiet:

  logical for messages

## Value

data.frame with station, date, rain columns as a daily average (inches)
for all pixels in a catchment

## Details

Data from the Southwest Florida Water Management District's (SWFWMD) ftp
site: ftp://ftp.swfwmd.state.fl.us/pub/radar_rainfall/Daily_Data/

## Examples

``` r
if (FALSE) { # \dontrun{
read_importrain(2021, catchpixels, quiet = F)
} # }
```
