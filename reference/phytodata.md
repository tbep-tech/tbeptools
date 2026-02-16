# Phytoplankton data current as of 20260204

Phytoplankton data current as of 20260204

## Usage

``` r
phytodata
```

## Format

A nested [`tibble`](https://tibble.tidyverse.org/reference/tibble.html)
with 41390 rows and 8 variables:

- epchc_station:

  chr

- Date:

  Date

- name:

  chr

- units:

  chr

- count:

  num

- yrqrt:

  Date

- yr:

  num

- mo:

  Ord.factor

## Examples

``` r
if (FALSE) { # \dontrun{
# location to download data
path <- tempfile(fileext = '.xlsx')

# load and assign to object
phytodata <- read_importphyto(path, download_latest = TRUE)

nrow(phytodata)
ncol(phytodata)

save(phytodata, file = 'data/phytodata.RData', compress = 'xz')

file.remove(path)
} # }
```
