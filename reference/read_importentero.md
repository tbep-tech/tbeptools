# Download Enterococcus data from the Water Quality Portal

Download Enterococcus data from the Water Quality Portal

## Usage

``` r
read_importentero(stas = NULL, startDate, endDate)
```

## Arguments

- stas:

  character, a vector of stations. If `NULL`, defaults to all stations
  in
  [`catchprecip`](https://tbep-tech.github.io/tbeptools/reference/catchprecip.md).

- startDate:

  character, starting date of observations as YYYY-MM-DD

- endDate:

  character, ending date of observations as YYYY-MM-DD

## Value

a data frame containing one row for each sample. Columns returned are:

- `date`:

  date, sample date

- `yr`:

  numeric, year of sample date

- `mo`:

  numeric, month of sample date

- `time`:

  character, sample time

- `time_zone`:

  character, sample time zone

- `long_name`:

  character, long name of bay segment subwatershed

- `bay_segment`:

  character, short name of bay segment subwatershed

- `station`:

  character, sample station

- `entero`:

  numeric, Enterococcus concentration

- `entero_censored`:

  logical, whether `entero` value was below the laboratory `MDL`,
  minimum detection limit

- `MDL`:

  numeric, minimum detection limit at the time of processing

- `entero_units`:

  character, units of measurement for `entero`

- `qualifier`:

  qualifier codes associated with sample

- `LabComments`:

  lab comments on sample

- `Latitude`:

  numeric, latitude in decimal degrees

- `Longitude`:

  numeric, longitude in decimal degrees

## Details

Retrieves Enterococcus sample data from selected stations and date range
from the Water Quality Portal, <https://www.waterqualitydata.us>

## Examples

``` r
if (FALSE) { # \dontrun{
# stations to download
stas <- c('21FLHILL_WQX-101',
'21FLHILL_WQX-102',
'21FLHILL_WQX-103')

# download and read the data
entero_in <- read_importentero(stas = stas, startDate = '2023-01-01', endDate = '2023-02-01')

head(entero_in)

} # }
```
