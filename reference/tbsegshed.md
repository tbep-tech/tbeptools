# Spatial data object of Tampa Bay segments plus watersheds

Spatial data object of Tampa Bay segments plus waterhseds

## Usage

``` r
tbsegshed
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
(POLYGON) with 7 features and 2 fields, +proj=longlat +ellps=WGS84
+datum=WGS84 +no_defs

- long_name:

  chr

- bay_segment:

  chr

## Examples

``` r
library(sf)
plot(st_geometry(tbsegshed))
```
