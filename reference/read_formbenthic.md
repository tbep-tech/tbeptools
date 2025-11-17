# Format benthic data for the Tampa Bay Benthic Index

Format benthic data for the Tampa Bay Benthic Index

## Usage

``` r
read_formbenthic(pathin)
```

## Arguments

- pathin:

  A path to unzipped csv files with base tables used to calculate
  benthic index

## Value

A nested [`tibble`](https://tibble.tidyverse.org/reference/tibble.html)
of station, field sample, and taxa data

## Details

Function is used internally within
[`read_importbenthic`](https://tbep-tech.github.io/tbeptools/reference/read_importbenthic.md)

## Examples

``` r
if (FALSE) { # \dontrun{

# location to download data
path <- '~/Desktop/benthic.zip'

# download
urlin1 <- 'https://epcbocc.sharepoint.com/:x:/s/Share/'
urlin2 <- 'EQUCWBuwCNdGuMREYAyAD1gBKC98mYtCHMWX0FYLrbT4KA?e=nDfnnQ'
urlin <- paste0(urlin1, urlin2, '&download=1')
read_dlcurrent(path, download_latest = TRUE, urlin = urlin)

# unzip
tmppth <- tempfile()
utils::unzip(path, exdir = tmppth, overwrite = TRUE)

# format benthic data
read_formbenthic(pathin = tmppth)

# remove temporary path
unlink(tmppth, recursive = TRUE)

} # }
```
