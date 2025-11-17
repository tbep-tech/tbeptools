# Get average concentrations for a sediment parameter by bay segment

Get average concentrations for a sediment parameter by bay segment

## Usage

``` r
anlz_sedimentave(
  sedimentdata,
  param,
  yrrng = c(1993, 2023),
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"),
  funding_proj = "TBEP"
)
```

## Arguments

- sedimentdata:

  input sediment `data.frame` as returned by
  [`read_importsediment`](https://tbep-tech.github.io/tbeptools/reference/read_importsediment.md)

- param:

  chr string for which parameter to plot

- yrrng:

  numeric vector indicating min, max years to include, use single year
  for one year of data

- bay_segment:

  chr string for the bay segment, one to many of "HB", "OTB", "MTB",
  "LTB", "TCB", "MR", "BCB"

- funding_proj:

  chr string for the funding project, one to many of "TBEP" (default),
  "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal
  Streams"

## Value

A `data.frame` object with average sediment concentrations for the
selected parameter by bay segment

## Details

Summaries for all bay segments are returned by default. The averages and
confidence intervals are specific to the year ranges in `yrrng`.

## See also

[`show_sedimentave`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentave.md)

## Examples

``` r
anlz_sedimentave(sedimentdata, param = 'Arsenic')
#> # A tibble: 7 × 8
#>   AreaAbbr   TEL   PEL Units   ave   lov   hiv grandave
#>   <fct>    <dbl> <dbl> <chr> <dbl> <dbl> <dbl>    <dbl>
#> 1 BCB       7.24  41.6 mg/kg  2.63 2.33   2.92     2.56
#> 2 HB        7.24  41.6 mg/kg  2.90 0.681  5.13     2.56
#> 3 LTB       7.24  41.6 mg/kg  2.92 2.46   3.38     2.56
#> 4 MR        7.24  41.6 mg/kg  1.68 1.40   1.97     2.56
#> 5 MTB       7.24  41.6 mg/kg  2.15 1.85   2.46     2.56
#> 6 OTB       7.24  41.6 mg/kg  3.19 0.702  5.68     2.56
#> 7 TCB       7.24  41.6 mg/kg  2.43 1.94   2.91     2.56
```
