# Load local phytoplankton cell count file

Load local phytoplankton cell count file

## Usage

``` r
read_importphyto(xlsx, download_latest = FALSE, na = c("", "NULL"))
```

## Arguments

- xlsx:

  chr string path for local excel file, to overwrite if not current

- download_latest:

  logical passed to
  [`read_dlcurrent`](https://tbep-tech.github.io/tbeptools/reference/read_dlcurrent.md)
  to download raw data and compare with existing in `xlsx` if available

- na:

  chr vector of strings to interpret as `NA`, passed to
  [`read_xlsx`](https://readxl.tidyverse.org/reference/read_excel.html)

## Value

A `data.frame` of formatted water quality data.

## Details

Phytoplankton cell count data downloaded from
https://epcbocc.sharepoint.com/:x:/s/Share/ETAfRQ5drmRHntDd1O8s3FQB180Fumed4nQ99w-OIVDxrA?e=eSmtxD&download=1

## See also

[`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
xlsx <- '~/Desktop/phyto_data.xlsx'

# load and assign to object
phytodata <- read_importphyto(xlsx, download_latest = T)
} # }
```
