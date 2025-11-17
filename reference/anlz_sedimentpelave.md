# Get average concentrations for a sediment parameter by bay segment

Get average concentrations for a sediment parameter by bay segment

## Usage

``` r
anlz_sedimentpelave(
  sedimentdata,
  yrrng = c(1993, 2023),
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"),
  funding_proj = "TBEP"
)
```

## Arguments

- sedimentdata:

  input sediment `data.frame` as returned by
  [`read_importsediment`](https://tbep-tech.github.io/tbeptools/reference/read_importsediment.md)

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

A `data.frame` of the average of the average PEL ratios for each bay
segment

## Details

Summaries for all bay segments are returned by default. The averages and
confidence intervals are specific to the year ranges in `yrrng`.

## See also

[`show_sedimentpelave`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentpelave.md)

## Examples

``` r
anlz_sedimentpelave(sedimentdata)
#> # A tibble: 7 × 5
#>   AreaAbbr    ave    lov    hiv grandave
#>   <fct>     <dbl>  <dbl>  <dbl>    <dbl>
#> 1 BCB      0.0527 0.0439 0.0615   0.0517
#> 2 HB       0.116  0.0655 0.166    0.0517
#> 3 LTB      0.0280 0.0247 0.0314   0.0517
#> 4 MR       0.0447 0.0378 0.0515   0.0517
#> 5 MTB      0.0370 0.0324 0.0417   0.0517
#> 6 OTB      0.0499 0.0366 0.0632   0.0517
#> 7 TCB      0.0337 0.0265 0.0408   0.0517
```
