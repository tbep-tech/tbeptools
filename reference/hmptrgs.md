# Habitat Master Plan targets and goals

Habitat Master Plan targets and goals

## Usage

``` r
hmptrgs
```

## Format

A data frame showing 2030 targets and 2050 goals

## Examples

``` r
if (FALSE) { # \dontrun{
library(dplyr)

load(url("https://github.com/tbep-tech/hmpu-workflow/raw/master/data/trgs.RData"))

hmptrgs <- trgs %>%
   rename(Goal2050 = Target2050)

save(hmptrgs, file = 'data/hmptrgs.RData', compress = 'xz')
} # }
```
