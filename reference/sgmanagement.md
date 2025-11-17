# Seagrass management areas for Tampa Bay

Seagrass management areas for Tampa Bay

## Usage

``` r
sgmanagement
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
(MULTIPOLYGON) with 30 features and 1 field, +proj=longlat +ellps=WGS84
+datum=WGS84 +no_defs

- areas:

  int

## Details

These polygons are seagrass management areas for Tampa Bay that provide
a finer division of areas within major segments
([`tbseg`](https://tbep-tech.github.io/tbeptools/reference/tbseg.md))
having relevance for locations of seagrass beds.

## Examples

``` r
if (FALSE) { # \dontrun{
library(sf)
library(dplyr)
library(tools)

# NAD83(HARN) / Florida West (ftUS)
# same as sgseg
prj <- 2882

# create sf object of boundaries
sgmanagement <- st_read(
  dsn = '~/Desktop/TBEP/GISboundaries/Seagrass_Management_Areas/TBEP_SG_MA_FINAL_Projectfix.shp',
  drivers = 'ESRI Shapefile'
  ) %>%
  select(areas = TBEP_SG_MA) %>%
  st_zm() %>%
  st_transform(prj)

# save
save(sgmanagement, file = 'data/sgmanagement.RData', compress = 'xz')

} # }
```
