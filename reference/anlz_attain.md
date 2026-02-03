# Get attainment categories

Get attainment categories for each year and bay segment using
chlorophyll and light attenuation

## Usage

``` r
anlz_attain(avedat, magdurout = FALSE, trgs = NULL)
```

## Arguments

- avedat:

  result returned from
  [`anlz_avedat`](https://tbep-tech.github.io/tbeptools/reference/anlz_avedat.md)

- magdurout:

  logical indicating if the separate magnitude and duration estimates
  are returned

- trgs:

  optional `data.frame` for annual bay segment water quality targets,
  defaults to
  [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.md)

## Value

A `data.frame` for each year and bay segment showing the attainment
category

## Examples

``` r
avedat <- anlz_avedat(epcdata)
anlz_attain(avedat)
#> # A tibble: 208 × 4
#>    bay_segment    yr chl_la outcome
#>    <chr>       <dbl> <chr>  <chr>  
#>  1 HB           1974 3_0    yellow 
#>  2 HB           1975 3_2    red    
#>  3 HB           1976 3_2    red    
#>  4 HB           1977 3_2    red    
#>  5 HB           1978 3_3    red    
#>  6 HB           1979 3_3    red    
#>  7 HB           1980 3_3    red    
#>  8 HB           1981 3_3    red    
#>  9 HB           1982 3_3    red    
#> 10 HB           1983 3_0    yellow 
#> # ℹ 198 more rows
```
