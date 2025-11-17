# Spatial data object of Tampa Bay watershed

Spatial data object of Tampa Bay watershed, includes the bay proper

## Usage

``` r
tbshed
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
(POLYGON) with 1 feature and 0 fields, +proj=longlat +ellps=WGS84
+datum=WGS84 +no_defs

## Examples

``` r
library(sf)
if (FALSE) { # \dontrun{
library(dplyr)
tbshed <- st_read('T:/05_GIS/BOUNDARIES/TBEP_Watershed_Correct_Projection.shp') %>%
  select(-Id, -Name, -Area_m, -Hectares) %>%
  st_transform(crs = 4326)

save(tbshed, file = 'data/tbshed.RData', compress = 'xz')
} # }
plot(st_geometry(tbshed))
```
