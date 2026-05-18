# AMBI species group assignments for Tampa Bay benthic taxa

AMBI species group assignments for Tampa Bay benthic taxa

## Usage

``` r
ambispp
```

## Format

A data frame with 1983 rows and 5 variables:

- TaxaListID:

  int, join key to taxacounts in
  [`benthicdata`](https://tbep-tech.github.io/tbeptools/reference/benthicdata.md)

- NAME:

  chr, taxon name

- AMBIGroupID:

  int, ecological group 1-5 for conventional AMBI (Gillett et al. 2015),
  NA if unclassified

- TBAMBIGroupID:

  int, ecological group 1-5 for Tampa Bay-specific AMBI, NA if
  unclassified

- AMBIListSource:

  chr, provenance of the AMBI group assignment (Gulf, National, or
  assumption)

## Details

Ecological groups range from I (most sensitive to pollution) to V (most
tolerant). The conventional AMBI groups (`AMBIGroupID`) follow published
literature (Gillett et al. 2015), with Gulf of Mexico scores preferred
over National scores, and family-level assumptions applied where
species-level scores were unavailable. The Tampa Bay-specific groups
(`TBAMBIGroupID`) are based on local sediment sample assignments.

This table is used as the species lookup in
[`anlz_ambiscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_ambiscr.md)
to join ecological group assignments to observed taxa counts in
[`benthicdata`](https://tbep-tech.github.io/tbeptools/reference/benthicdata.md).

## References

Gillett, D.J., Weisberg, S.B., Grayson, T., Hamilton, A., Hansen, V.,
Leppo, E.W., Pelletier, M.C., et al. (2015). Effect of ecological group
classification schemes on performance of the AMBI benthic index in US
coastal waters. Ecological Indicators, 50, 99-107.
[doi:10.1016/j.ecolind.2014.11.005](https://doi.org/10.1016/j.ecolind.2014.11.005)

## Examples

``` r
if (FALSE) { # \dontrun{
library(readxl)
library(dplyr)

ambispp <- read_excel('data-raw/AMBI_EcoSource_ReportDeliverableToDK.xlsx') |>
  select(TaxaListID, NAME, AMBIGroupID, TBAMBIGroupID = TBAMBIGroupId, AMBIListSource)

save(ambispp, file = 'data/ambispp.RData', compress = 'xz')
} # }
```
