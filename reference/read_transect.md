# Import JSON seagrass transect data from Water Atlas

Import JSON seagrass transect data from Water Atlas

## Usage

``` r
read_transect(training = FALSE, raw = FALSE, retry = 5)
```

## Arguments

- training:

  logical if training data are imported or the complete database

- raw:

  logical indicating if raw, unformatted data are returned, see details

- retry:

  integer indicating maximum number of retries on request failure,
  default 5

## Value

data frame

## Details

The function imports a JSON file from the USF Water Atlas. If
`training = TRUE`, a dataset from the TBEP training survey is imported
from
<https://tampabay.wateratlas.usf.edu/seagrass-transect-data-portal/api/assessments/training>.
If `training = FALSE`, the entire transect survey database is imported
from
<https://tampabay.wateratlas.usf.edu/seagrass-transect-data-portal/api/assessments/all__use-with-care>.

Abundance is reported as a numeric value from 0 -5 for Braun-Blanquet
coverage estimates, blade length is in cm, and short shoot density is
number of shoots per square meter. The short density is corrected for
quadrat size included in the raw data.

If `raw = TRUE`, the unformatted data are returned. The default is to
use formatting that allows the raw data to be used with the downstream
functions. The raw data may have extra information that may be of use
outside of the plotting functions in this package.

The request is retried with exponential backoff up to `retry` times if
the JSON request fails, since the Water Atlas API intermittently fails.

## Examples

``` r
if (FALSE) { # \dontrun{
# get training data
transect <- read_transect(training = TRUE)

# import all transect data
transect <- read_transect()
} # }
```
