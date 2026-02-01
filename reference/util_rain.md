# Get rainfall data at NOAA NCDC sites

Get rainfall data at NOAA NCDC sites

## Usage

``` r
util_rain(station = NULL, start, end, token, ntry = 5, quiet = FALSE)
```

## Arguments

- station:

  character for the station id to retrieve

- start:

  character for start of time period as YYYY-MM-DD

- end:

  character for end of time period as YYYY-MM-DD

- token:

  character for the NOAA API key

- ntry:

  numeric for the number of times to try to download the data

- quiet:

  logical to print progress in the console

## Value

a single value data frame with the rainfall sum in inches

## Details

This function is used to retrieve a long-term record of rainfall for the
requested station. A NOAA API key is required to use the function.

## See also

[`anlz_hydroload`](https://tbep-tech.github.io/tbeptools/reference/anlz_hydroload.md)

## Examples

``` r
if (FALSE) { # \dontrun{
noaa_key <- Sys.getenv('NOAA_KEY')
util_rain('GHCND:USW00092806', start = '2021-01-01', end = '2021-12-31', noaa_key)
} # }
```
