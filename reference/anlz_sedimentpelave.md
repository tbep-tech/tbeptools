# Get average concentrations for a sediment parameter by bay segment

Get average concentrations for a sediment parameter by bay segment

## Usage

``` r
anlz_sedimentpelave(
  sedimentdata,
  yrrng = c(1993, 2024),
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
#> 1 BCB      0.0521 0.0435 0.0606   0.0513
#> 2 HB       0.115  0.0654 0.164    0.0513
#> 3 LTB      0.0279 0.0246 0.0312   0.0513
#> 4 MR       0.0447 0.0380 0.0514   0.0513
#> 5 MTB      0.0368 0.0322 0.0414   0.0513
#> 6 OTB      0.0494 0.0363 0.0625   0.0513
#> 7 TCB      0.0334 0.0264 0.0404   0.0513
```
