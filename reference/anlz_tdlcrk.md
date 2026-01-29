# Estimate tidal creek report card scores

Estimate tidal creek report card scores

## Usage

``` r
anlz_tdlcrk(tidalcreeks, iwrraw, tidtrgs = NULL, yr = 2025)
```

## Arguments

- tidalcreeks:

  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object for
  population of tidal creeks

- iwrraw:

  FDEP impaired waters data base as
  [`data.frame`](https://rdrr.io/r/base/data.frame.html)

- tidtrgs:

  optional `data.frame` for tidal creek nitrogen targets, defaults to
  [`tidaltargets`](https://tbep-tech.github.io/tbeptools/reference/tidaltargets.md)

- yr:

  numeric for reference year to evaluate, scores are based on the
  planning period beginning ten years prior to this date

## Value

A [`data.frame`](https://rdrr.io/r/base/data.frame.html) with the report
card scores for each creek, as prioritize, investigate, caution,
monitor, or no data

## Examples

``` r
anlz_tdlcrk(tidalcreeks, iwrraw, yr = 2025)
#> # A tibble: 623 × 10
#>       id wbid  JEI   name     class monitor caution investigate prioritize score
#>    <int> <chr> <chr> <chr>    <chr>   <dbl>   <dbl>       <dbl>      <dbl> <chr>
#>  1     1 1983B CC01  Rock Cr… 2           1      NA          NA         NA Moni…
#>  2     2 2052  CC01  Rock Cr… 3M         10      NA          NA         NA Moni…
#>  3     3 1983B CC02  Oyster … 2          NA      NA          NA         NA No D…
#>  4     4 2067  CC02  Oyster … 3M         10      NA          NA         NA Moni…
#>  5     5 1983B CC03  Buck Cr… 2          NA      NA          NA         NA No D…
#>  6     6 2068A CC03  Buck Cr… 3M          9       1          NA         NA Moni…
#>  7     7 2078A CC04  Buck Cr… 2          NA      NA           1         NA Inve…
#>  8     8 2078A CC05  Coral C… 2          NA      NA          NA         NA No D…
#>  9     9 2078B CC05  Coral C… 2           7      NA          NA         NA Moni…
#> 10    10 2065C CC06  Catfish… 2           3      NA          NA         NA Moni…
#> # ℹ 613 more rows
```
