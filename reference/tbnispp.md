# Reference table for Tampa Bay Nekton Index species classifications

Reference table for Tampa Bay Nekton Index species classifications

## Usage

``` r
tbnispp
```

## Format

A data frame with 196 rows and 10 variables:

- TSN:

  int

- NODCCODE:

  chr

- ScientificName:

  chr

- Include_TB_Index:

  chr

- Hab_Cat:

  chr

- Est_Cat:

  chr

- Est_Use:

  chr

- Feeding_Cat:

  chr

- Feeding_Guild:

  chr

- Selected_Taxa:

  chr

## Examples

``` r
if (FALSE) { # \dontrun{
library(dplyr)

# import and clean
tbnispp <- read.csv('../tbni-proc/data/TBIndex_spp_codes.csv',
    header = TRUE, stringsAsFactors = FALSE) %>%
  mutate(
    NODCCODE = as.character(NODCCODE),
    NODCCODE = case_when(NODCCODE == "9.998e+09" ~ "9998000000",
                             TRUE ~ NODCCODE)
  )

save(tbnispp, file = 'data/tbnispp.RData', compress = 'xz')
} # }
```
