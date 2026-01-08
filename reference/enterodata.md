# Enterococcus data from 53 key Enterococcus stations since 1995

Enterococcus data from 53 key Enterococcus stations since 1995

## Usage

``` r
enterodata
```

## Format

A data frame with 6622 rows and 16 columns:

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

## Source

Water Quality Portal, <https://waterqualitydata.us>

## Details

A dataset containing Enterococcus from 53 stations in the TBEP watershed
since 1995.

## Examples

``` r
if (FALSE) { # \dontrun{
enterodata <- read_importentero(startDate = '1995-01-01', endDate = '2025-12-31')

save(enterodata, file = 'data/enterodata.RData')
} # }
```
