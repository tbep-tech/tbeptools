# Load local water quality file for Fecal Indicator Bacteria (FIB)

Load local water quality file for Fecal Indicator Bacteria (FIB)

## Usage

``` r
read_importfib(xlsx, download_latest = FALSE, na = c("", "NULL"), all = TRUE)
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

  logical indicating if all stations with FIB data are returned, default
  is `TRUE`, see details

## Value

A `data.frame` of formatted FIB data.

## Details

Loads the "RWMDataSpreadsheet" worksheet from the file located at
`xlsx`. The file is downloaded from
<https://epcbocc.sharepoint.com/:x:/s/Share/EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL&download=1>.
The files can be viewed at
<https://epcbocc.sharepoint.com/:f:/s/Share/EiypSSYdsEFCi84Sv_6-t7kBUYaXiIqN0B1n2w57Z_V3kQ?e=NdZQcU>.

Returns FIB data including E. coli, Enterococcus, Fecal Coliform, and
Total Coliform concentrations and waterbody class (freshwater as 1 or
3F, marine as 2 or 3M) for stations and sample dates.

Values are returned for E. coli (`ecoli`), Enterococcus (`entero`),
Fecal Coliform (`fcolif`), and Total Coliform (`totcol`). Values shown
are \# of colonies per 100 mL of water (`#/100mL`). Qualifier columns
for each are also returned with the `_q` suffix. Qualifier codes can be
interpreted from the source spreadsheet.

Concentrations noted with `<` or `>` in the raw data are reported as is,
with only the numeric value shown. Samples with this notation can be
determined from the qualifier columns.

If `all = FALSE`, only stations with AreaName in the source data as
Hillsborough River, Hillsborough River Tributary, Alafia River, Alafia
River Tributary, Lake Thonotosassa, Lake Thonotosassa Tributary, and
Lake Roberta.

## See also

[`read_formfib`](https://tbep-tech.github.io/tbeptools/reference/read_formfib.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'

# load and assign to object
fibdata <- read_importfib(xlsx, download_latest = T)

} # }
```
