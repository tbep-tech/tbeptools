# Get AMBI scores for benthic stations

Get AMBI scores for benthic stations

## Usage

``` r
anlz_ambiscr(benthicdata, type = c("AMBI", "AMBI-TB"))
```

## Arguments

- benthicdata:

  nested [`tibble`](https://tibble.tidyverse.org/reference/tibble.html)
  formatted from
  [`read_importbenthic`](https://tbep-tech.github.io/tbeptools/reference/read_importbenthic.md)

- type:

  chr string indicating which AMBI variant to calculate, one of `"AMBI"`
  (conventional, based on Gillett et al. 2015) or `"AMBI-TB"` (Tampa
  Bay-specific group assignments)

## Value

A data frame of AMBI scores for each station, with columns from
[`benthicdata`](https://tbep-tech.github.io/tbeptools/reference/benthicdata.md)
stations joined to:

- TotalGroupCount:

  int, total number of classified taxa records used in the calculation

- PercentG1 - PercentG5:

  num, percentage of taxa records in each ecological group

- BC:

  num, Biotic Coefficient (0-6 scale, or 7 for azoic)

- AMBI or TBAMBI:

  num, adjusted AMBI score (0-10 scale)

- SitePollutionClassification:

  chr, pollution category based on BC

- BioticIndex:

  chr, biotic index value (0-6 or Azoic)

- DominatingEcologicalGroup:

  chr, dominating ecological group based on BC

- BenthicCommunityHealth:

  chr, community health descriptor based on BC

- AMBICat or TBAMBICat:

  chr, adjusted AMBI category based on the 0-10 scale

## Details

This function calculates the AZTI Marine Biotic Index (AMBI) for benthic
stations in Tampa Bay. The index assigns each taxon to one of five
ecological groups (I = most sensitive, V = most tolerant to pollution)
and computes a Biotic Coefficient (BC) from the proportion of taxa in
each group.

The Biotic Coefficient is calculated as:

\$\$BC = (0 \times \\G1 + 1.5 \times \\G2 + 3 \times \\G3 + 4.5 \times
\\G4 + 6 \times \\G5) / 100\$\$

where \\

An adjusted AMBI score on a 0-10 scale is also returned:

\$\$Adjusted AMBI = (7 - BC) \times (10 / 7)\$\$

Higher adjusted scores indicate healthier benthic conditions. Azoic
stations (empty samples, TaxaListID == 1942 in
[`benthicdata`](https://tbep-tech.github.io/tbeptools/reference/benthicdata.md))
receive BC = 7 and adjusted score = 0.

Two variants are supported via the `type` argument. `"AMBI"` uses
ecological group assignments from published literature (`AMBIGroupID` in
[`ambispp`](https://tbep-tech.github.io/tbeptools/reference/ambispp.md)).
`"AMBI-TB"` uses Tampa Bay-specific assignments (`TBAMBIGroupID` in
[`ambispp`](https://tbep-tech.github.io/tbeptools/reference/ambispp.md)).
The calculation is identical, only the group assignment column differs.

## References

Gillett, D.J., Weisberg, S.B., Grayson, T., Hamilton, A., Hansen, V.,
Leppo, E.W., Pelletier, M.C., et al. (2015). Effect of ecological group
classification schemes on performance of the AMBI benthic index in US
coastal waters. Ecological Indicators, 50, 99-107.
[doi:10.1016/j.ecolind.2014.11.005](https://doi.org/10.1016/j.ecolind.2014.11.005)

## Examples

``` r
anlz_ambiscr(benthicdata)
#> # A tibble: 4,915 × 23
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
#> # ℹ 17 more variables: Latitude <dbl>, Longitude <dbl>, date <date>, yr <dbl>,
#> #   TotalGroupCount <int>, PercentG1 <dbl>, PercentG2 <dbl>, PercentG3 <dbl>,
#> #   PercentG4 <dbl>, PercentG5 <dbl>, BC <dbl>, AMBI <dbl>,
#> #   SitePollutionClassification <chr>, BioticIndex <chr>,
#> #   DominatingEcologicalGroup <chr>, BenthicCommunityHealth <chr>,
#> #   AMBICat <chr>
anlz_ambiscr(benthicdata, type = 'AMBI-TB')
#> # A tibble: 4,915 × 23
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
#> # ℹ 17 more variables: Latitude <dbl>, Longitude <dbl>, date <date>, yr <dbl>,
#> #   TotalGroupCount <int>, PercentG1 <dbl>, PercentG2 <dbl>, PercentG3 <dbl>,
#> #   PercentG4 <dbl>, PercentG5 <dbl>, BC <dbl>, TBAMBI <dbl>,
#> #   SitePollutionClassification <chr>, BioticIndex <chr>,
#> #   DominatingEcologicalGroup <chr>, BenthicCommunityHealth <chr>,
#> #   TBAMBICat <chr>
```
