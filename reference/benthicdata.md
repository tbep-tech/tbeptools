# Benthic data for the Tampa Bay Benthic Index current as of 20241212

Benthic data for the Tampa Bay Benthic Index current as of 20241212

## Usage

``` r
benthicdata
```

## Format

A nested [`tibble`](https://tibble.tidyverse.org/reference/tibble.html)
with 3 rows and 2 variables:

- name:

  chr identifying the dataset as stations, fieldsamples, or taxacounts

- value:

  list of dataframes for each dataset

## Details

Index the corresponding list element in the `value` column to view each
dataset. For example, the stations data in the first row can be viewed
as `benthicdata$value[[1]]`.

## Examples

``` r
if (FALSE) { # \dontrun{
# location to download data
path <- '~/Desktop/benthic.zip'

# load and assign to object
benthicdata <- read_importbenthic(path, download_latest = TRUE, remove = TRUE)

save(benthicdata, file = 'data/benthicdata.RData', compress = 'xz')

} # }
```
