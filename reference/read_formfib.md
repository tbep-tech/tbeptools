# Format Fecal Indicator Bacteria (FIB) data

Format Fecal Indicator Bacteria (FIB) data

## Usage

``` r
read_formfib(datin, all = FALSE)
```

## Arguments

- datin:

  input `data.frame` loaded from
  [`read_importepc`](https://tbep-tech.github.io/tbeptools/reference/read_importepc.md)

- all:

  logical indicating if all stations with FIB data are returned, default
  is `FALSE`

## Value

A lightly formatted `data.frame` with FIB data

## Details

Formats input data from
[`read_importepc`](https://tbep-tech.github.io/tbeptools/reference/read_importepc.md)
appropriate for FIB results, see the details in
[`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md)
for more more information.

## See also

[`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md),
[`read_importepc`](https://tbep-tech.github.io/tbeptools/reference/read_importepc.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'

# load raw data and assign to object
epcall <- read_importepc(xlsx, download_latest = T)

# final formatting
fibdata <- read_formfib(epcall)
} # }
```
