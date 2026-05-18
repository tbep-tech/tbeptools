# Get annual medians of AMBI scores by bay segment

Get annual medians of AMBI scores by bay segment

## Usage

``` r
anlz_ambimed(
  ambiscr,
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB", "All"),
  rev = FALSE,
  yrrng = c(1993, 2024),
  window = TRUE
)
```

## Arguments

- ambiscr:

  input data frame as returned by
  [`anlz_ambiscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_ambiscr.md);
  the AMBI variant (conventional or Tampa Bay-specific) is detected
  automatically from the column names

- bay_segment:

  chr string for the bay segment, one to many of "HB", "OTB", "MTB",
  "LTB", "TCB", "MR", "BCB", "All"

- rev:

  logical if factor levels for bay segments are reversed

- yrrng:

  numeric indicating year ranges to evaluate

- window:

  logical indicating whether to use a rolling 5-year window (default
  TRUE) or single year values (FALSE) for the bay segment categories,
  see details

## Value

A data frame of annual percent composition by AMBI category and bay
segment

## Details

An additional summary is provided for the entire bay as an unweighted
summary across categories ("All").

Only sampling funded by TBEP and as part of the routine EPC benthic
monitoring program are included in the final categories.

The default behavior is to use a rolling five-year window to calculate
the percent of sites in each AMBI category by bay segment. This applies
only to years 2005 and later, where the counts from the current year and
the prior four years are summed to calculate the percentages. This is
intended to help smooth out inter-annual variability due to reduced
sampling effort from 2005 to present. If `window = FALSE`, then only
single year values are used.

The AMBI category column (`AMBICat` or `TBAMBICat`) is based on the
adjusted AMBI score (0-10 scale) using the classification thresholds
defined in
[`anlz_ambiscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_ambiscr.md).

## Examples

``` r
ambiscr <- anlz_ambiscr(benthicdata)
anlz_ambimed(ambiscr)
#> # A tibble: 254 × 6
#>    bay_segment    yr `Heavily Polluted` `Meanly Polluted` `Slightly Polluted`
#>    <fct>       <dbl>              <dbl>             <dbl>               <dbl>
#>  1 All          1993             0                0                     0.901
#>  2 All          1994             0                0.0449                0.921
#>  3 All          1995             0                0.00781               0.891
#>  4 All          1996             0                0.00769               0.885
#>  5 All          1997             0                0.00820               0.926
#>  6 All          1998             0                0.0169                0.898
#>  7 All          1999             0                0.0163                0.902
#>  8 All          2000             0                0.0233                0.907
#>  9 All          2001             0.0128           0.0128                0.885
#> 10 All          2002             0.0122           0.0366                0.866
#> # ℹ 244 more rows
#> # ℹ 1 more variable: Unpolluted <dbl>
```
