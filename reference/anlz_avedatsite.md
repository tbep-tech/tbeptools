# Estimate annual means by site

Estimate annual means by site for chlorophyll and secchi data

## Usage

``` r
anlz_avedatsite(epcdata, partialyr = FALSE)
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
anlz_avedatsite(epcdata)
#> $ann
#> # A tibble: 6,973 × 5
#>       yr bay_segment epchc_station var         val
#>    <dbl> <chr>               <dbl> <chr>     <dbl>
#>  1  1974 HB                      6 mean_chla  25.6
#>  2  1974 HB                      7 mean_chla  21.6
#>  3  1974 HB                      8 mean_chla  22.6
#>  4  1974 HB                     44 mean_chla  23.4
#>  5  1974 HB                     52 mean_chla  23.5
#>  6  1974 HB                     55 mean_chla  20.2
#>  7  1974 HB                     70 mean_chla  33.1
#>  8  1974 HB                     71 mean_chla  25.8
#>  9  1974 HB                     73 mean_chla  17.6
#> 10  1974 HB                     80 mean_chla  10.5
#> # ℹ 6,963 more rows
#> 
#> $mos
#> # A tibble: 49,702 × 6
#>    bay_segment epchc_station    yr    mo var         val
#>    <chr>               <dbl> <dbl> <dbl> <chr>     <dbl>
#>  1 HB                      6  1974     1 mean_chla    53
#>  2 HB                      7  1974     1 mean_chla    19
#>  3 HB                      8  1974     1 mean_chla    46
#>  4 HB                     44  1974     1 mean_chla    24
#>  5 HB                     52  1974     1 mean_chla    28
#>  6 HB                     55  1974     1 mean_chla    33
#>  7 HB                     70  1974     1 mean_chla    58
#>  8 HB                     71  1974     1 mean_chla    73
#>  9 HB                     73  1974     1 mean_chla    17
#> 10 HB                     80  1974     1 mean_chla    11
#> # ℹ 49,692 more rows
#> 
```
