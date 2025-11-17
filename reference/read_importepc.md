# Download and/or import local water quality file for internal use

Download and/or import local water quality file for internal use

## Usage

``` r
read_importepc(xlsx, download_latest = FALSE, na = c("", "NULL"))
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

An unformatted `data.frame` from EPC

## Details

Loads the "RWMDataSpreadsheet" worksheet from the file located at
`xlsx`. The file is downloaded from
<https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1>.
The files can be viewed at
<https://epcbocc.sharepoint.com/:f:/s/Share/EiypSSYdsEFCi84Sv_6-t7kBUYaXiIqN0B1n2w57Z_V3kQ?e=NdZQcU>.

This function is used internally by
[`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)
and
[`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md)
because both use the same source data from the Environmental Protection
Commission of Hillsborough County.

## See also

[`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md),
[`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'

# load and assign to object
epcall <- read_importepc(xlsx, download_latest = T)
} # }
```
