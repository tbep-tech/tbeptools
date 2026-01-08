# Manatee County FIB data as of 20260108

Manatee County FIB data as of 20260108

## Usage

``` r
mancofibdata
```

## Format

A data frame with 1928 rows and 13 variables:

- manco_station:

  chr, Station name

- SampleTime:

  POSIXct, Date/time of sampling

- class:

  chr, Waterbody class (`Fresh`, `Marine`)

- yr:

  num, Year of sampling

- mo:

  num, Month of sampling

- Latitude:

  num, Latitude, WGS84

- Longitude:

  num, Latitude, WGS84

- Sample_Depth_m:

  num, Depth of sample, meters

- var:

  chr, Variable name (`ecoli`, `entero`

- val:

  num, Value of variable

- uni:

  num, Units of variable

- qual:

  num, Qualifier code

- area:

  chr, Location name based on USF Water Alas waterbody name

## Details

This dataset includes FIB data from Manatee County Department of Natural
Resources where station class is marine (estuary) and Enterococcus data
is present or the station class is freshwater (stream/river, reservoir)
and E. coli data is present. The data is formatted from the raw data
loaded from
[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md).

## Examples

``` r
if (FALSE) { # \dontrun{
mancofibdata <- read_importwqp('21FLMANA_WQX', type = 'fib')

nrow(mancofibdata)
ncol(mancofibdata)

save(mancofibdata, file = 'data/mancofibdata.RData')
} # }
```
