# Spatial data object of FIM stations including Tampa Bay segments

Spatial data object of FIM stations including Tampa Bay segments

## Usage

``` r
fimstations
```

## Format

A simple features
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) object (POINT)
with 8099 features and 2 fields, +proj=longlat +ellps=WGS84 +datum=WGS84
+no_defs

- Reference:

  num

- bay_segment:

  chr

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
csv <- '~/Desktop/fimraw.csv'

# load and assign to object
fimstations <- read_importfim(csv, download_latest = FALSE, locs = TRUE)
save(fimstations, file = 'data/fimstations.RData', compress = 'xz')
} # }
```
