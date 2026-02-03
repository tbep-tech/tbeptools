# Estimate annual means

Estimate annual means for chlorophyll and secchi data

## Usage

``` r
anlz_avedat(epcdata, partialyr = FALSE)
```

## Arguments

- epcdata:

  `data.frame` formatted from `read_importwq`

- partialyr:

  logical indicating if incomplete annual data for the most recent year
  are approximated by five year monthly averages for each parameter

## Value

Mean estimates for chlorophyll and secchi

## Examples

``` r
# view average estimates
anlz_avedat(epcdata)
#> $ann
#> # A tibble: 632 × 4
#>       yr bay_segment var         val
#>    <dbl> <chr>       <chr>     <dbl>
#>  1  1974 HB          mean_chla 22.4 
#>  2  1974 LTB         mean_chla  4.24
#>  3  1974 MTB         mean_chla  9.66
#>  4  1974 OTB         mean_chla 10.2 
#>  5  1975 HB          mean_chla 27.9 
#>  6  1975 LTB         mean_chla  4.93
#>  7  1975 MTB         mean_chla 11.4 
#>  8  1975 OTB         mean_chla 13.2 
#>  9  1976 HB          mean_chla 29.5 
#> 10  1976 LTB         mean_chla  5.08
#> # ℹ 622 more rows
#> 
#> $mos
#> # A tibble: 4,916 × 5
#>    bay_segment    yr    mo var         val
#>    <chr>       <dbl> <dbl> <chr>     <dbl>
#>  1 HB           1974     1 mean_chla 36.2 
#>  2 LTB          1974     1 mean_chla  1.75
#>  3 MTB          1974     1 mean_chla 11.5 
#>  4 OTB          1974     1 mean_chla  4.4 
#>  5 HB           1974     2 mean_chla 42.4 
#>  6 LTB          1974     2 mean_chla  5.5 
#>  7 MTB          1974     2 mean_chla  9.35
#>  8 OTB          1974     2 mean_chla  4.07
#>  9 HB           1974     3 mean_chla 14.9 
#> 10 LTB          1974     3 mean_chla  5.88
#> # ℹ 4,906 more rows
#> 
```
