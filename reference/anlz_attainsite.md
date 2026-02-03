# Get site attainments

Get site attainment categories for chlorophyll or light attenuation

## Usage

``` r
anlz_attainsite(
  avedatsite,
  thr = c("chla", "la"),
  trgs = NULL,
  yrrng = NULL,
  thrs = FALSE
)
```

## Arguments

- avedatsite:

  result returned from
  [`anlz_avedatsite`](https://tbep-tech.github.io/tbeptools/reference/anlz_avedatsite.md)

- thr:

  chr string indicating with water quality value and appropriate
  threshold to to plot, one of "chl" for chlorophyll and "la" for light
  availability

- trgs:

  optional `data.frame` for annual bay segment water quality targets,
  defaults to
  [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.md)

- yrrng:

  optional numeric value for year to return, defaults to all

- thrs:

  logical indicating if attainment category is relative to targets
  (default) or thresholds

## Value

a `data.frame` for each year and site showing the attainment category

## Details

This function is a simplication of the attainment categories returned by
[`anlz_attain`](https://tbep-tech.github.io/tbeptools/reference/anlz_attain.md).
Sites are only compared to the targets/thresholds that apply separately
for chlorophyll or light attenuation.

## Examples

``` r
avedatsite <- anlz_avedatsite(epcdata)
anlz_attainsite(avedatsite)
#> # A tibble: 2,340 × 9
#>       yr bay_segment epchc_station var     val target smallex thresh met  
#>    <dbl> <chr>               <dbl> <chr> <dbl>  <dbl>   <dbl>  <dbl> <chr>
#>  1  1974 HB                      6 chla   25.6   13.2    14.1     15 no   
#>  2  1974 HB                      7 chla   21.6   13.2    14.1     15 no   
#>  3  1974 HB                      8 chla   22.6   13.2    14.1     15 no   
#>  4  1974 HB                     44 chla   23.4   13.2    14.1     15 no   
#>  5  1974 HB                     52 chla   23.5   13.2    14.1     15 no   
#>  6  1974 HB                     55 chla   20.2   13.2    14.1     15 no   
#>  7  1974 HB                     70 chla   33.1   13.2    14.1     15 no   
#>  8  1974 HB                     71 chla   25.8   13.2    14.1     15 no   
#>  9  1974 HB                     73 chla   17.6   13.2    14.1     15 no   
#> 10  1974 HB                     80 chla   10.5   13.2    14.1     15 yes  
#> # ℹ 2,330 more rows
```
