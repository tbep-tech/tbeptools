# FIM data for Tampa Bay Nekton Index current as of 08102026

FIM data for Tampa Bay Nekton Index current as of 08102026

## Usage

``` r
fimdata
```

## Format

A data frame with 55832rows and 19 variables:

- Reference:

  chr

- Sampling_Date:

  Date

- Latitude:

  num

- Longitude:

  num

- Zone:

  chr

- Grid:

  int

- NODCCODE:

  chr

- Year:

  num

- Month:

  num

- Total_N:

  num

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

- bay_segment:

  chr

## Examples

``` r
if (FALSE) { # \dontrun{
csv <- '~/Desktop/TampaBay_NektonIndexData.csv'

fimdata <- read_importfim(csv, download_latest = TRUE)

save(fimdata, file = 'data/fimdata.RData', compress = 'xz')

} # }
```
