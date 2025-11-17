# Get seagrass average abundance and occurrence across transects

Get seagrass average abundance and occurrence across transects

## Usage

``` r
anlz_transectocc(transect)
```

## Arguments

- transect:

  data frame returned by
  [`read_transect`](https://tbep-tech.github.io/tbeptools/reference/read_transect.md)

## Value

A data frame with abundance and frequency occurrence estimates
aggregated by species, transect, and date. The nsites column is the
total number of placements that were sampled along a transect for a
particular date.

## Details

Abundance and frequency occurrence are estimated as in Sherwood et al.
2017, equations 1 and 2. In short, frequency occurrence is estimated as
the number of instances a species was observed along a transect divided
by the number of placements along a transect and average abundance was
estimated as the sum of species-specific Braun-Blanquet scores divided
by the number of placements along a transect. The estimates are obtained
for all seagrass species including Caulerpa (attached macroalgae), Dapis
(cyanobacteria), and Chaetomorpha (drift green algea), whereas all other
attached and drift algae species are aggregated. Drift or attached
macroalgae and cyanobacteria (Dapis) estimates may not be accurate prior
to 2021. Values for `total` include total frequency occurrence only for
seagrass species (Halodule, Syringodium, Thalassia, Ruppia, Halophila).

## References

Sherwood, E.T., Greening, H.S., Johansson, J.O.R., Kaufman, K.,
Raulerson, G.E. 2017. Tampa Bay (Florida, USA): Documenting seagrass
recovery since the 1980's and reviewing the benefits. Southeastern
Geographer. 57(3):294-319.

## Examples

``` r
if (FALSE) { # \dontrun{
transect <- read_transect()
} # }
anlz_transectocc(transect)
#> # A tibble: 45,360 × 6
#> # Groups:   Date, Transect [1,620]
#>    Date       Transect Savspecies                  nsites foest bbest
#>    <date>     <chr>    <chr>                        <int> <dbl> <dbl>
#>  1 1997-10-11 S2T3     "AA"                            41     0     0
#>  2 1997-10-11 S2T3     "Caulerpa"                      41     0     0
#>  3 1997-10-11 S2T3     "Chaetomorpha"                  41     0     0
#>  4 1997-10-11 S2T3     "DA"                            41     0     0
#>  5 1997-10-11 S2T3     "DB: Dictyota\r\n"              41     0     0
#>  6 1997-10-11 S2T3     "DB: Drift Brown\r\n"           41     0     0
#>  7 1997-10-11 S2T3     "DG: Drift Green"               41     0     0
#>  8 1997-10-11 S2T3     "DG: Ulva"                      41     0     0
#>  9 1997-10-11 S2T3     "DG: Ulva fasciata\r\n"         41     0     0
#> 10 1997-10-11 S2T3     "DG: Ulva intestinales\r\n"     41     0     0
#> # ℹ 45,350 more rows
```
