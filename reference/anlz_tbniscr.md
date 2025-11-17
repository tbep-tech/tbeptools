# Get Tampa Bay Nekton Index scores

Get Tampa Bay Nekton Index scores

## Usage

``` r
anlz_tbniscr(fimdata, raw = TRUE)
```

## Arguments

- fimdata:

  `data.frame` formatted from
  [`read_importfim`](https://tbep-tech.github.io/tbeptools/reference/read_importfim.md)

- raw:

  logical indicating if raw metric values are also returned

## Value

A data frame of metrics and TBNI scores in wide format.

## Details

This function calculates raw and scored metrics for the TBNI, including
`NumTaxa`, `BenthicTaxa`, `TaxaSelect`, `NumGuilds`, and `Shannon`. The
total TBNI score is returned as `TBNI_Score`.

## See also

[`anlz_tbnimet`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbnimet.md)

## Examples

``` r
anlz_tbniscr(fimdata)
#> # A tibble: 8,094 × 16
#>    Reference      Year Month Season bay_segment TBNI_Score NumTaxa ScoreNumTaxa
#>    <chr>         <dbl> <dbl> <chr>  <chr>            <dbl>   <dbl>        <dbl>
#>  1 TBM1998010906  1998     1 Winter OTB                 18       2            2
#>  2 TBM1998010910  1998     1 Winter OTB                 14       1            1
#>  3 TBM1998010912  1998     1 Winter OTB                  0       0            0
#>  4 TBM1998010914  1998     1 Winter OTB                 20       2            2
#>  5 TBM1998010915  1998     1 Winter MTB                 46       4            4
#>  6 TBM1998010917  1998     1 Winter MTB                 24       2            2
#>  7 TBM1998010920  1998     1 Winter MTB                 50       5            5
#>  8 TBM1998010922  1998     1 Winter OTB                  0       0            0
#>  9 TBM1998010926  1998     1 Winter HB                  48       4            4
#> 10 TBM1998010928  1998     1 Winter HB                   8       1            1
#> # ℹ 8,084 more rows
#> # ℹ 8 more variables: BenthicTaxa <dbl>, ScoreBenthicTaxa <dbl>,
#> #   TaxaSelect <dbl>, ScoreTaxaSelect <dbl>, NumGuilds <dbl>,
#> #   ScoreNumGuilds <dbl>, Shannon <dbl>, ScoreShannon <dbl>
```
