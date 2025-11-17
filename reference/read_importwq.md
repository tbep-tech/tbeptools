# Load local water quality file

Load local water quality file

## Usage

``` r
read_importwq(xlsx, download_latest = FALSE, na = c("", "NULL"), all = FALSE)
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

- all:

  logical indicating if all water quality parameters are returned, see
  details

## Value

A `data.frame` of formatted water quality data.

## Details

Loads the "RWMDataSpreadsheet" worksheet from the file located at
`xlsx`. The file is downloaded from
<https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1>.
The files can be viewed at
<https://epcbocc.sharepoint.com/:f:/s/Share/EiypSSYdsEFCi84Sv_6-t7kBUYaXiIqN0B1n2w57Z_V3kQ?e=NdZQcU>.

Water quality parameters returned by default are total nitrogen (`tn`),
Secchi depth (`sd`), chlorophyll-a (`chla`), salinity (top, mid, and
bottom depths, `Sal_` prefix), water temperature (top, mid, and bottom
depths, `Temp_Water_` prefix), turbidity (`Turbidity_JTU-NTU`), and
water color (`Color_345_F45`). Additional qualifier columns for each
that include the `_Q` suffix are also returned, excluding salinity and
water temperature. All other water quality parameters and qualifiers can
be returned by setting `all = T`.

## See also

[`read_formwq`](https://tbep-tech.github.io/tbeptools/reference/read_formwq.md),
[`read_importphyto`](https://tbep-tech.github.io/tbeptools/reference/read_importphyto.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'

# load and assign to object
epcdata <- read_importwq(xlsx, download_latest = T)

# get all water quality parameters
epcdataall <- read_importwq(xlsx, download_latest = T, all = T)
} # }
```
