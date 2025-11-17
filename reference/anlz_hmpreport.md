# Evaluate Habitat Master Plan progress for report card

Evaluate Habitat Master Plan progress for report card

## Usage

``` r
anlz_hmpreport(acres, subtacres, hmptrgs)
```

## Arguments

- acres:

  `data.frame` for intertidal and supratidal land use and cover of
  habitat types for each year of data

- subtacres:

  `data.frame` for subtidal cover of habitat types for each year of data

- hmptrgs:

  `data.frame` of Habitat Master Plan targets and goals

## Value

A summarized `data.frame` appropriate for creating a report card

## Details

The relevant output columns are `targeteval` and `goaleval` that
indicate numeric values as -1 (target not met, trending below), 0
(target met, trending below), 0.5 (target not met, trending above), and
1 (target met, trending above).

Columns in the output are as follows:

- year:

  Year of the assessment

- metric:

  Habitat type assessed

- Acres:

  Coverage estimate for the year

- lacres:

  Coverage estimate for the previous set of available data

- lyr:

  Year for the previous set of available data

- category:

  Strata for the habitat type

- Target:

  2030 target for the habitat type from the Habitat Master Plan

- Goal:

  2050 goal for the habitat type from the Habitat Master Plan

- acresdiff:

  Difference in acres for the current year and the previous set of
  available data

- yeardiff:

  Difference in years for the current year and the previous set of
  available data

- changerate:

  Acreage change per year for the current year relative to the previous
  set of available data

- targetrate:

  Annual rate required to achieve the 2030 target

- goalrate:

  Annual rate required to achieve the 2050 goal

- targetprop:

  Proportion of target met for the current year

- goalprop:

  Proportion of goal met for the current year

- targeteval:

  A number indicating target status of the current year for the report
  card

- goaleval:

  A number indicating goal status of the current year for the report
  card

The numbers in `targeteval` and `goaleval` are one of four values as -1,
0, 0.5, and 1. These numbers define the status for the assessment year:

- -1:

  target or goal not met, trending below

- 0:

  target or goal met, trending below

- 0.5:

  target or goal not met, trending above

- 1:

  target or goal met, trending above

## Examples

``` r
# view summarized data for report card
anlz_hmpreport(acres, subtacres, hmptrgs)
#> # A tibble: 165 × 17
#>     year metric      Acres lacres   lyr category Target  Goal acresdiff yeardiff
#>    <dbl> <chr>       <dbl>  <dbl> <dbl> <fct>     <dbl> <dbl>     <dbl>    <dbl>
#>  1  1990 Seagrasses 25218. 23279.  1988 Subtidal  40000 40000     1939.        2
#>  2  1990 Tidal Fla… 20433. 21686.  1988 Subtidal  16220 16220    -1253.        2
#>  3  1992 Seagrasses 25746. 25218.  1990 Subtidal  40000 40000      528.        2
#>  4  1992 Tidal Fla… 20594. 20433.  1990 Subtidal  16220 16220      161.        2
#>  5  1994 Seagrasses 26524. 25746.  1992 Subtidal  40000 40000      778.        2
#>  6  1994 Tidal Fla… 20244. 20594.  1992 Subtidal  16220 16220     -349.        2
#>  7  1996 Seagrasses 26924. 26524.  1994 Subtidal  40000 40000      400.        2
#>  8  1996 Tidal Fla… 20443. 20244.  1994 Subtidal  16220 16220      199.        2
#>  9  1999 Seagrasses 24840. 26924.  1996 Subtidal  40000 40000    -2083.        3
#> 10  1999 Tidal Fla… 27085. 20443.  1996 Subtidal  16220 16220     6642.        3
#> # ℹ 155 more rows
#> # ℹ 7 more variables: changerate <dbl>, targetrate <dbl>, goalrate <dbl>,
#> #   targetprop <dbl>, goalprop <dbl>, targeteval <dbl>, goaleval <dbl>
```
