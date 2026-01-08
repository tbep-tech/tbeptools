# Hillsborough County Environmental Services Division (ESD) FIB data as of 20260108

Hillsborough County Environmental Services Division (ESD) FIB data as of
20260108

## Usage

``` r
hcesdfibdata
```

## Format

A data frame with 1264 rows and 13 variables:

- hcesd_station:

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

  chr, Location name

## Details

This dataset includes FIB data from Hillsborough County Environmental
Services Division (21FLHESD_WQX) where station class is marine (estuary)
and Enterococcus data is present or the station class is freshwater
(stream/river, reservoir) and E. coli data is present. The data is
formatted from the raw data loaded from
[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md).

## Examples

``` r
if (FALSE) { # \dontrun{
hcesdfibdata <- read_importwqp('21FLHESD_WQX', type = 'fib')

nrow(hcesdfibdata)
ncol(hcesdfibdata)

save(hcesdfibdata, file = 'data/hcesdfibdata.RData')
} # }
```
