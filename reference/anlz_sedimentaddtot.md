# Add contaminant totals to sediment data

Add contaminant totals to sediment data

## Usage

``` r
anlz_sedimentaddtot(
  sedimentdata,
  yrrng = c(1993, 2023),
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"),
  funding_proj = "TBEP",
  param = NULL,
  pelave = TRUE
)
```

## Arguments

- sedimentdata:

  input sediment `data.frame` as returned by
  [`read_importsediment`](https://tbep-tech.github.io/tbeptools/reference/read_importsediment.md)

- yrrng:

  numeric vector indicating min, max years to include, use single year
  for one year of data

- bay_segment:

  chr string for the bay segment, one to many of "HB", "OTB", "MTB",
  "LTB", "TCB", "MR", "BCB"

- funding_proj:

  chr string for the funding project, one to many of "TBEP" (default),
  "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal
  Streams"

- param:

  optional character string of a parameter to filter the results

- pelave:

  logical indicating if output is used for
  [`anlz_sedimentpel`](https://tbep-tech.github.io/tbeptools/reference/anlz_sedimentpel.md)

## Value

A `data.frame` object similar to the input, but filtered by the
arguments and contaminant totals added. Replicate samples are also
removed.

## Details

This function adds totals to the `sedimentdata` input for total PCBs,
total DDT, total LMW PAH, total HMW PAH, and total PAH. Appropriate
TEL/PEL values for the totals are also added.

## Examples

``` r
anlz_sedimentaddtot(sedimentdata)
#> # A tibble: 64,008 × 24
#>    ProgramId ProgramName   FundingProject    yr AreaAbbr StationID StationNumber
#>        <int> <chr>         <chr>          <int> <chr>        <int> <chr>        
#>  1         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#>  2         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#>  3         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#>  4         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#>  5         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#>  6         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#>  7         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#>  8         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#>  9         4 Benthic Moni… TBEP            1993 HB            2463 93HB15       
#> 10         4 Benthic Moni… TBEP            1993 HB            2464 93HB16       
#> # ℹ 63,998 more rows
#> # ℹ 17 more variables: Latitude <dbl>, Longitude <dbl>, Replicate <chr>,
#> #   SedResultsType <chr>, Parameter <chr>, ValueAdjusted <dbl>, Units <chr>,
#> #   Qualifier <chr>, MDLnum <dbl>, PQLnum <dbl>, TEL <dbl>, PEL <dbl>,
#> #   BetweenTELPEL <chr>, ExceedsPEL <chr>, PELRatio <dbl>,
#> #   PreparationDate <chr>, AnalysisTimeMerge <chr>
```
