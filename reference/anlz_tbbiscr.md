# Get Tampa Bay Benthic Index scores

Get Tampa Bay Benthic Index scores

## Usage

``` r
anlz_tbbiscr(benthicdata)
```

## Arguments

- benthicdata:

  nested [`tibble`](https://tibble.tidyverse.org/reference/tibble.html)
  formatted from
  [`read_importbenthic`](https://tbep-tech.github.io/tbeptools/reference/read_importbenthic.md)

## Value

A single data frame of TBBI scores for each site.

## Details

This function calculates scores for the TBBI based on station, taxa, and
field sample data. The total TBBI scores are returned as `TBBI` and
`TBBICat`, where the latter is a categorical description of the scores.

## Examples

``` r
anlz_tbbiscr(benthicdata)
#> # A tibble: 4,915 × 15
#>    StationID StationNumber AreaAbbr FundingProject ProgramID ProgramName       
#>        <int> <chr>         <chr>    <chr>              <int> <chr>             
#>  1       448 02BBs301      MTB      Apollo Beach           4 Benthic Monitoring
#>  2       449 02BBs305      MTB      Apollo Beach           4 Benthic Monitoring
#>  3       450 02BBs307      MTB      Apollo Beach           4 Benthic Monitoring
#>  4       451 02BBs364      MTB      Apollo Beach           4 Benthic Monitoring
#>  5       452 02BBs369      MTB      Apollo Beach           4 Benthic Monitoring
#>  6       453 02BBs395      MTB      Apollo Beach           4 Benthic Monitoring
#>  7       454 02BBs397      MTB      Apollo Beach           4 Benthic Monitoring
#>  8       455 02BBs398      MTB      Apollo Beach           4 Benthic Monitoring
#>  9       456 02BBs401      MTB      Apollo Beach           4 Benthic Monitoring
#> 10       457 02BBs402      MTB      Apollo Beach           4 Benthic Monitoring
#> # ℹ 4,905 more rows
#> # ℹ 9 more variables: Latitude <dbl>, Longitude <dbl>, date <date>, yr <dbl>,
#> #   TotalAbundance <dbl>, SpeciesRichness <dbl>, TBBI <dbl>, TBBICat <chr>,
#> #   Salinity <dbl>
```
