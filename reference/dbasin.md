# Spatial data object of minor subbasins (dbasins) in the Tampa Bay watershed

Spatial data object of minor subbasins (dbasins) in the Tampa Bay
watershed

## Usage

``` r
dbasin
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
(POLYGON) with 436 features and 26 fields, +proj=longlat +ellps=WGS84
+datum=WGS84 +no_defs

## Examples

``` r
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE
plot(st_geometry(dbasin))
```
