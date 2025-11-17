# Format seagrass transect data from Water Atlas

Format seagrass transect data from Water Atlas

## Usage

``` r
read_formtransect(jsn, training = FALSE, raw = FALSE)
```

## Arguments

- jsn:

  A data frame returned from
  [`fromJSON`](https://jeroen.r-universe.dev/jsonlite/reference/fromJSON.html)

- training:

  logical if input are transect training data or complete database

- raw:

  logical indicating if raw, unformatted data are returned, see details

## Value

data frame in long format

## Details

Shoot density is reported as number of shoots per square meter and is
corrected for the quadrat size entered in the raw data. Shoot density
and blade height (cm) are based on averages across random observations
at each transect point that are entered separately in the data form.
Abundance is reported as a numeric value from 0 - 5 for Braun-Blanquet
coverage estimates.

If `raw = TRUE`, the unformatted data are returned. The default is to
use formatting that allows the raw data to be used with the downstream
functions. The raw data may have extra information that may be of use
outside of the plotting functions in this package.

## Examples

``` r
library(jsonlite)

if (FALSE) { # \dontrun{
# all transect data
url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/all__use-with-care'
jsn <- fromJSON(url)
trndat <- read_formtransect(jsn)
} # }

# training transect data
url <- 'http://dev.seagrass.wateratlas.usf.edu/api/assessments/training'
jsn <- fromJSON(url)
trndat <- read_formtransect(jsn, training = TRUE)
```
