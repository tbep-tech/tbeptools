# Get annual medians of Tampa Bay Benthic Index scores by bay segment

Get annual medians of Tampa Bay Benthic Index scores by bay segment

## Usage

``` r
anlz_tbbimed(
  tbbiscr,
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB", "All", "All (wt)"),
  rev = FALSE,
  yrrng = c(1993, 2023)
)
```

## Arguments

- tbbiscr:

  input data frame as returned by
  [`anlz_tbbiscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbiscr.md)

- bay_segment:

  chr string for the bay segment, one to many of "HB", "OTB", "MTB",
  "LTB", "TCB", "MR", "BCB", "All", "All (wt)"

- rev:

  logical if factor levels for bay segments are reversed

- yrrng:

  numeric indicating year ranges to evaluate

## Value

A data frame of annual medians by bay segment

## Details

Additional summaries are provided for the entire bay, as a summary
across categories ("All") and a summary weighted across the relative
sizes of each bay segment ("All (wt)").

Only sampling funded by TBEP and as part of the routine EPC benthic
monitoring program are included in the final categories.

## Examples

``` r
tbbiscr <- anlz_tbbiscr(benthicdata)
anlz_tbbimed(tbbiscr)
#> # A tibble: 277 × 6
#> # Rowwise: 
#>    bay_segment    yr Degraded Healthy Intermediate TBBICat
#>    <fct>       <dbl>    <dbl>   <dbl>        <dbl> <fct>  
#>  1 All          1993    0.3     0.244        0.456 Poor   
#>  2 All          1994    0.449   0.180        0.371 Poor   
#>  3 All          1995    0.133   0.508        0.359 Fair   
#>  4 All          1996    0.138   0.569        0.292 Fair   
#>  5 All          1997    0.157   0.421        0.421 Fair   
#>  6 All          1998    0.231   0.316        0.453 Poor   
#>  7 All          1999    0.107   0.377        0.516 Fair   
#>  8 All          2000    0.163   0.407        0.430 Fair   
#>  9 All          2001    0.231   0.321        0.449 Poor   
#> 10 All          2002    0.2     0.425        0.375 Poor   
#> # ℹ 267 more rows
```
