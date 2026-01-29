# FDEP IWR run 67

Florida Department of Environmental Protection, Impaired Waters Rule,
Run 67

## Usage

``` r
iwrraw
```

## Format

A data frame 592464 rows and 11 variables

## Details

File was created using workflow at
<https://tbep-tech.github.io/tidalcreek-stats/Creek_select_tbeptools>,
example below is old and for Run 61.

## Examples

``` r
if (FALSE) { # \dontrun{
library(dplyr)

load(file = '../../02_DOCUMENTS/tidal_creeks/iwrraw_run61.RData')
iwrraw <- sf::st_set_geometry(iwrraw, NULL) %>%
  rename(JEI = jei)
save(iwrraw, file = 'data/iwrraw.RData', compress = 'xz')
} # }
```
