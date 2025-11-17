# Analyze tidal creek water quality indicators

Estimate tidal creek water quality indicators to support report card
scores

## Usage

``` r
anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2024, radar = FALSE)
```

## Arguments

- tidalcreeks:

  [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object for
  population of tidal creeks

- iwrraw:

  FDEP impaired waters rule data base as
  [`data.frame`](https://rdrr.io/r/base/data.frame.html)

- yr:

  numeric for reference year to evaluate, scores are based on the
  planning period beginning ten years prior to this date

- radar:

  logical indicating if output is for
  [`show_tdlcrkradar`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkradar.md),
  see details

## Value

A [`data.frame`](https://rdrr.io/r/base/data.frame.html) with the
indicator values for each tidal creek

## Details

Annual geometric means for additional water quality data available at
each wbid, JEI combination. Florida trophic state index values are also
estimated where data are available.

Nitrogen ratios are estimated for JEIs that cover source (upstream,
freshwater) and tidal (downstream) WBIDs, defined as the ratio of
concentrations between the two (i.e., ratios \> 1 mean source has higher
concentrations). Nitrogen ratios for a given year reflect the ratio of
the median nitrogen concentrations when they were measured in both a
source and tidal segment during the same day. Note that a ratio of one
can be obtained if both the source and tidal segments are at minimum
detection.

Indicators for years where more than 10\\

If `radar = TRUE`, output is returned in a format for use with
[`show_tdlcrkradar`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkradar.md)
Specifically, results are calculated as the percentage of years where an
indicator exceeds a relevant threshold. This only applies to the marine
WBIDs of the tidal creeks (Florida DEP class 2, 3M). Six indicators are
returned with percentage exceedances based on total nitrogen (`tn_ind`)
greater than 1.1 mg/L, chlorophyll (`chla_ind`) greater than 11 ug/L,
trophic state index (`tsi_ind`) greater than 55 (out of 100),
nitrate/nitrite ratio between marine and upstream segments (`nox_ind`)
greater than one, chlorophyll and total nitrogen ratios \> 15, and
percentage of years more where than ten percent of observations were
below DO percent saturation of 42.

## Examples

``` r
dat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2024)
head(dat)
#>   id       name  JEI  wbid class year    CHLAC    COLOR     COND       DO
#> 1  1 Rock Creek CC01 1983B     2 2022       NA       NA 53297.25 4.159892
#> 2  2 Rock Creek CC01  2052    3M 2015 2.647817 21.91113       NA 4.034172
#> 3  2 Rock Creek CC01  2052    3M 2016 2.265462 19.13080       NA 3.980251
#> 4  2 Rock Creek CC01  2052    3M 2017 2.851726 15.39576       NA 4.157777
#> 5  2 Rock Creek CC01  2052    3M 2018 1.934899 11.65500       NA 4.219790
#> 6  2 Rock Creek CC01  2052    3M 2019 2.071003  7.21425       NA 3.015847
#>      DOSAT        NO23 ORGN    SALIN       TKN        TN         TP  TSS
#> 1 66.54848 0.006000000   NA 35.18500 0.6260000 0.6260000 0.06500000 45.3
#> 2 55.41609 0.009361504   NA 19.10494 0.6465161 0.5678241 0.07602770   NA
#> 3 55.96637 0.008532522   NA 25.84531 0.5813818 0.5408161 0.08330509   NA
#> 4 60.18017 0.007447260   NA 24.86909 0.6255197 0.6326848 0.07566682   NA
#> 5 63.32630 0.006994714   NA 31.32419 0.5668727 0.5734574 0.07432007   NA
#> 6 44.90322 0.007047106   NA 31.63214 0.5053022 0.4577485 0.06300538   NA
#>       TURB chla_tn_ratio tn_tp_ratio chla_tsi   tn_tsi  tn2_tsi   tp_tsi
#> 1 2.300000            NA    9.630769       NA 46.72558 49.53273 59.24360
#> 2 1.814818      4.663093    7.468648 30.82179 44.79432 47.43600 62.15842
#> 3 2.082253      4.188970    6.491994 28.57601 43.82942 46.38844 63.85868
#> 4 1.802161      4.507341    8.361456 31.89011 46.93590 49.76107 62.06992
#> 5 2.454007      3.374095    7.716050 26.30480 44.98978 47.64821 61.73589
#> 6 1.831953      4.524324    7.265229 27.28367 40.52758 42.80384 58.66389
#>    tp2_tsi  nut_tsi      tsi no23_source no23_tidal no23_ratio do_bnml do_prop
#> 1 74.71554 49.53273       NA          NA         NA         NA       0       0
#> 2 78.41391 47.43600 39.12890          NA         NA         NA       0       1
#> 3 80.57123 46.38844 37.48223          NA         NA         NA       0       1
#> 4 78.30162 49.76107 40.82559          NA         NA         NA       0       0
#> 5 77.87779 47.64821 36.97650          NA         NA         NA       0       1
#> 6 73.97999 42.80384 35.04375          NA         NA         NA       1       1
```
