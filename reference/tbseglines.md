# Spatial data object of lines defining major Tampa Bay segments

Spatial data object of lines defining major Tampa Bay segments

## Usage

``` r
tbseglines
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
(LINESTRING) with 3 features and 1 field, +proj=longlat +ellps=WGS84
+datum=WGS84 +no_defs

## Examples

``` r
library(sf)
plot(st_geometry(tbseglines))
```
