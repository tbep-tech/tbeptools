# Format water quality data

Format water quality data

## Usage

``` r
read_formwq(datin, all = FALSE)
```

## Arguments

- datin:

  input `data.frame` loaded from
  [`read_importepc`](https://tbep-tech.github.io/tbeptools/reference/read_importepc.md)

- all:

  logical indicating if all water quality parameters are returned, see
  details

## Value

A lightly formatted `data.frame` with chloropyll and secchi observations

## Details

Secchi data VOB depths or secchis \< 0.5 ft from bottom are assigned
`NA`, function is used internally within
[`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

## See also

[`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md),
[`read_importepc`](https://tbep-tech.github.io/tbeptools/reference/read_importepc.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
xlsx <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'

# load raw data and assign to object
epcall <- read_importepc(xlsx, download_latest = T)

# final formatting
epcdata <- read_formwq(epcall)
} # }
```
