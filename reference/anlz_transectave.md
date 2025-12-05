# Get annual averages of seagrass frequency occurrence by bay segments and year

Get annual averages of seagrass frequency occurrence by bay segments and
year

## Usage

``` r
anlz_transectave(
  transectocc,
  bay_segment = c("OTB", "HB", "MTB", "LTB", "BCB"),
  total = TRUE,
  yrrng = c(1998, 2025),
  rev = FALSE
)
```

## Arguments

- transectocc:

  data frame returned by
  [`anlz_transectocc`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectocc.md)

- bay_segment:

  chr string for the bay segment, one to many of "OTB", "HB", "MTB",
  "LTB", "BCB"

- total:

  logical indicating if average frequency occurrence is calculated for
  the entire bay across segments

- yrrng:

  numeric indicating year ranges to evaluate

- rev:

  logical if factor levels for bay segments are reversed

## Value

A data frame of annual averages by bay segment

## Details

The `focat` column returned in the results shows a color category based
on arbitrary breaks of the frequency occurrence estimates (`foest`) at
25, 50, and 75 percent. These don't necessarily translate to any
ecological breakpoints.

## Examples

``` r
if (FALSE) { # \dontrun{
transect <- read_transect()
} # }
transectocc <- anlz_transectocc(transect)
anlz_transectave(transectocc)
#> # A tibble: 168 × 4
#> # Groups:   bay_segment [6]
#>    bay_segment    yr foest focat  
#>    <fct>       <dbl> <dbl> <fct>  
#>  1 All          1998  58.0 #E9C318
#>  2 OTB          1998  65.5 #E9C318
#>  3 HB           1998  15.0 #CC3231
#>  4 MTB          1998  53.7 #E9C318
#>  5 LTB          1998  80.8 #2DC938
#>  6 BCB          1998  81.0 #2DC938
#>  7 All          1999  51.4 #E9C318
#>  8 OTB          1999  64.7 #E9C318
#>  9 HB           1999  10.1 #CC3231
#> 10 MTB          1999  51.8 #E9C318
#> # ℹ 158 more rows
```
