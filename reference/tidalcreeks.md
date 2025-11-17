# Spatial data object of tidal creeks in Impaired Waters Rule, Run 66

Spatial data object of tidal creeks in Impaired Waters Rule, Run 66

## Usage

``` r
tidalcreeks
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
(MULTILINESTRING) with 620 features and 6 fields, +proj=longlat
+ellps=WGS84 +datum=WGS84 +no_defs

- id:

  num

- wbid:

  chr

- JEI:

  chr

- class:

  chr

- name:

  chr

- Creek_Length_m:

  num

## Details

File was created using workflow at
<https://tbep-tech.github.io/tidalcreek-stats/Creek_select_tbeptools>,
example below is old and for Run 61.

## Examples

``` r
if (FALSE) { # \dontrun{
library(sf)
library(dplyr)

prj <- 4326

# create sf object of creek population, join with creek length data
tidalcreeks <- st_read(
  dsn = '../../02_DOCUMENTS/tidal_creeks/TidalCreek_ALL_Line_WBID61.shp',
  drivers = 'ESRI Shapefile'
  ) %>%
  st_transform(crs = prj) %>%
  mutate(
    id = 1:nrow(.)
  ) %>%
  select(id, name = Name, JEI = CreekID, wbid = WBID, class = CLASS, Creek_Length_m = Total_m)

# save
save(tidalcreeks, file = 'data/tidalcreeks.RData', compress = 'xz')

} # }
```
