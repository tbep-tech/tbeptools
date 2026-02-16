# Spatial data object of Tampa Bay segments

Note that these boundaries are not used for formal analysis and are only
used as visual aids in mapping.

## Usage

``` r
tbseg
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
(POLYGON) with 4 features and 2 fields, +proj=longlat +ellps=WGS84
+datum=WGS84 +no_defs

- long_name:

  chr

- bay_segment:

  chr

## Details

Spatial data object of Tampa Bay segments

## Examples

``` r
library(sf)
plot(st_geometry(tbseg))
```
