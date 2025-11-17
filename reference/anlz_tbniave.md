# Get annual averages of Tampa Bay Nekton Index scores by bay segment

Get annual averages of Tampa Bay Nekton Index scores by bay segment

## Usage

``` r
anlz_tbniave(
  tbniscr,
  bay_segment = c("OTB", "HB", "MTB", "LTB"),
  rev = FALSE,
  perc = c(32, 46)
)
```

## Arguments

- tbniscr:

  input data frame as returned by
  [`anlz_tbniscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniscr.md)

- bay_segment:

  chr string for the bay segment, one to many of "OTB", "HB", "MTB",
  "LTB"

- rev:

  logical if factor levels for bay segments are reversed

- perc:

  numeric values indicating break points for score categories

## Value

A data frame of annual averages by bay segment

## Examples

``` r
tbniscr <- anlz_tbniscr(fimdata)
anlz_tbniave(tbniscr)
#> # A tibble: 108 × 5
#>    bay_segment  Year Segment_TBNI Action          outcome
#>    <fct>       <dbl>        <dbl> <fct>           <chr>  
#>  1 HB           1998           47 Stay the Course green  
#>  2 HB           1999           47 Stay the Course green  
#>  3 HB           2000           44 Caution         yellow 
#>  4 HB           2001           44 Caution         yellow 
#>  5 HB           2002           39 Caution         yellow 
#>  6 HB           2003           41 Caution         yellow 
#>  7 HB           2004           41 Caution         yellow 
#>  8 HB           2005           32 Caution         yellow 
#>  9 HB           2006           41 Caution         yellow 
#> 10 HB           2007           42 Caution         yellow 
#> # ℹ 98 more rows
```
