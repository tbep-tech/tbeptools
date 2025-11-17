# Spatial data object of SWFWMD Tampa Bay segments, 2024

Spatial data object of SWFWMD Tampa Bay segments, 2024

## Usage

``` r
swfwmdtbseg2024
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
(MULTIPOLYGON) with 7 features and 1 fields, +proj=longlat +ellps=WGS84
+datum=WGS84 +no_defs

## Details

2024 segments are slightly different from
[`swfwmdtbseg`](https://tbep-tech.github.io/tbeptools/reference/swfwmdtbseg.md).

## Examples

``` r
if (FALSE) { # \dontrun{
library(sf)
library(dplyr)

labs <- c('Old Tampa Bay', 'Hillsborough Bay', 'Middle Tampa Bay',
  'Lower Tampa Bay', 'Boca Ciega Bay', 'Terra Ceia Bay', 'Manatee River')
levs <- labs

swfwmdtbseg2024 <- st_read(
    dsn = 'T:/05_GIS/SWFWMD/Seagrass/2024_Seagrass/'
  ) %>%
  rename(waterbodyName = waterbodyN) %>%
  filter(waterbodyName %in% levs) %>%
  mutate(
    waterbodyName = factor(waterbodyName, levels = levs, labels = labs)
  ) %>%
  select(segment = waterbodyName) %>%
  st_transform(crs = 4326)

save(swfwmdtbseg2024, file = 'data/swfwmdtbseg2024.RData', compress = 'xz')
} # }
```
