# A list of Fecal Indicator Bacteria (FIB) factor levels and labels

A list of Fecal Indicator Bacteria (FIB) factor levels and labels

## Usage

``` r
util_fiblevs()
```

## Value

A `list` with levels (often cutpoints) and labels for FIB categories

## Examples

``` r
util_fiblevs()
#> $ecolilev
#> [1] -Inf  126  410 1000  Inf
#> 
#> $ecolilbs
#> [1] "< 126"     "126 - 409" "410 - 999" "> 999"    
#> 
#> $enterolev
#> [1] -Inf   35  130 1000  Inf
#> 
#> $enterolbs
#> [1] "< 35"      "35 - 129"  "130 - 999" "> 999"    
#> 
#> $fibmatlev
#> [1] "A" "B" "C" "D" "E"
#> 
#> $fibmatlbs
#> [1] "A" "B" "C" "D" "E"
#> 
```
