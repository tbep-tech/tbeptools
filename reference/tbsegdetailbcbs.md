# Spatial data object of detailed Tampa Bay segments, Boca Ciega Bay as southern portion

Note that these boundaries are not used for formal analysis and are only
used as visual aids in mapping. The data object differs from
[`tbseg`](https://tbep-tech.github.io/tbeptools/reference/tbseg.md) by
including Boca Ciega Bay South, Terra Ceia Bay, and Manatee River. The
boundaries are also more detailed. This is the same data as
[`tbsegdetail`](https://tbep-tech.github.io/tbeptools/reference/tbsegdetail.md)
but with Boca Ciega Bay shown only as the southern portion.

## Usage

``` r
tbsegdetailbcbs
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

## Details

Spatial data object of detailed Tampa Bay segments, Boca Ciega Bay as
southern portion

## Examples

``` r
library(sf)
plot(st_geometry(tbsegdetailbcbs))
```
