# Get all raw metrics for Tampa Bay Nekton Index

Get all raw metrics for Tampa Bay Nekton Index

## Usage

``` r
anlz_tbnimet(fimdata, all = FALSE)
```

## Arguments

- fimdata:

  `data.frame` formatted from `read_importfim`

- all:

  logical indicating if only TBNI metrics are returned (default),
  otherwise all are calcualted

## Value

A data frame of raw metrics in wide fomat. If `all = TRUE`, all metrics
are returned, otherwise only `NumTaxa`, `BenthicTaxa`, `TaxaSelect`,
`NumGuilds`, and `Shannon` are returned.

## Details

All raw metrics are returned in addition to those required for the TBNI.
Each row shows metric values for a station, year, and month where fish
catch data were available.

## Examples

``` r
anlz_tbnimet(fimdata)
#> # A tibble: 8,094 × 10
#>    Reference  Year Month Season bay_segment NumTaxa Shannon TaxaSelect NumGuilds
#>    <chr>     <dbl> <dbl> <chr>  <chr>         <dbl>   <dbl>      <dbl>     <dbl>
#>  1 TBM19980…  1998     1 Winter OTB               2   0.362          0         2
#>  2 TBM19980…  1998     1 Winter OTB               1   0              1         1
#>  3 TBM19980…  1998     1 Winter OTB               0   0              0         0
#>  4 TBM19980…  1998     1 Winter OTB               2   0.693          0         1
#>  5 TBM19980…  1998     1 Winter MTB               4   1.16           1         2
#>  6 TBM19980…  1998     1 Winter MTB               2   0.500          1         1
#>  7 TBM19980…  1998     1 Winter MTB               5   0.426          2         3
#>  8 TBM19980…  1998     1 Winter OTB               0   0              0         0
#>  9 TBM19980…  1998     1 Winter HB                4   0.794          1         4
#> 10 TBM19980…  1998     1 Winter HB                1   0              0         1
#> # ℹ 8,084 more rows
#> # ℹ 1 more variable: BenthicTaxa <dbl>
```
