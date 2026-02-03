# Get attainment categories for a chosen year

Get attainment categories for a chosen year

## Usage

``` r
anlz_yrattain(epcdata, yrsel, partialyr = FALSE)
```

## Arguments

- epcdata:

  data frame of epc data returned by
  [`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

- yrsel:

  numeric indicating chosen year

- partialyr:

  logical indicating if incomplete annual data for the most recent year
  are approximated by five year monthly averages for each parameter

## Value

A `data.frame` for the chosen year and all bay segments showing the bay
segment averages for chloropyll concentration, light attenuations,
segment targets, and attainment categories.

## Examples

``` r
# defaults to current year
anlz_yrattain(epcdata, yrsel = 2025)
#> # A tibble: 4 × 6
#>   bay_segment chla_val chla_target la_val la_target outcome
#>   <fct>          <dbl>       <dbl>  <dbl>     <dbl> <chr>  
#> 1 OTB             6.56         8.5  0.711      0.83 green  
#> 2 HB              9.96        13.2  0.881      1.58 green  
#> 3 MTB             5.46         7.4  0.563      0.83 green  
#> 4 LTB             2.95         4.6  0.603      0.63 green  
```
