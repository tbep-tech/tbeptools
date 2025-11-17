# Analyze Fecal Indicator Bacteria categories over time by station or bay segment

Analyze Fecal Indicator Bacteria categories over time by station or bay
segment

## Usage

``` r
anlz_fibmatrix(
  fibdata,
  yrrng = NULL,
  stas = NULL,
  bay_segment = NULL,
  lagyr = 3,
  subset_wetdry = c("all", "wet", "dry"),
  precipdata = NULL,
  temporal_window = NULL,
  wet_threshold = NULL,
  warn = TRUE
)
```

## Arguments

- fibdata:

  input data frame as returned by
  [`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md),
  [`read_importentero`](https://tbep-tech.github.io/tbeptools/reference/read_importentero.md),
  or
  [`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md),
  see details

- yrrng:

  numeric vector indicating min, max years to include, defaults to range
  of years in data, see details

- stas:

  optional vector of stations to include, see details

- bay_segment:

  optional vector of bay segment names to include, supercedes `stas` if
  provided, see details

- lagyr:

  numeric for year lag to calculate categories, see details

- subset_wetdry:

  character, subset data frame to only wet or dry samples as defined by
  `wet_threshold` and `temporal_window`? Defaults to `"all"`, which will
  not subset. If `"wet"` or `"dry"` is specified,
  [`anlz_fibwetdry`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibwetdry.md)
  is called using the further specified parameters, and the data frame
  is subsetted accordingly.

- precipdata:

  input data frame as returned by
  [`read_importrain`](https://tbep-tech.github.io/tbeptools/reference/read_importrain.md).
  columns should be: station, date (yyyy-mm-dd), rain (in inches). The
  object
  [`catchprecip`](https://tbep-tech.github.io/tbeptools/reference/catchprecip.md)
  has this data from 1995-2023 for select Enterococcus stations. If
  `NULL`, defaults to
  [`catchprecip`](https://tbep-tech.github.io/tbeptools/reference/catchprecip.md).

- temporal_window:

  numeric; required if `subset_wetdry` is not `"all"`. number of days
  precipitation should be summed over (1 = day of sample only; 2 = day
  of sample + day before; etc.)

- wet_threshold:

  numeric; required if `subset_wetdry` is not `"all"`. inches
  accumulated through the defined temporal window, above which a sample
  should be defined as being from a 'wet' time period

- warn:

  logical to print warnings about stations with insufficient data,
  default `TRUE`

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) object
with FIB summaries by year and station including columns for the
estimated geometric mean of Enterococcus (marine) or E. coli (fresh)
concentrations (`gmean`), the proportion of samples exceeding 130 CFU /
100 mL (Enterococcus) or 410 CFU / 100 mL (`exced`), the count of
samples (`cnt`), and a category indicating a letter outcome based on the
proportion of exceedences (`cat`). Results can be summarized by bay
segment if `bay_segment` is not `NULL` and the input data is from
[`read_importentero`](https://tbep-tech.github.io/tbeptools/reference/read_importentero.md).

## Details

This function is used to create output for plotting a matrix stoplight
graphic for FIB categories by station. Each station (or bay segment) and
year combination is categorized based on the likelihood of fecal
indicator bacteria concentrations exceeding some threshold in a given
year. For Enterococcus (marine), the default threshold is 130 CFU / 100
mL in a given year. For E. coli (fresh), the default threshold is 410
CFU / 100 mL. The proportions are categorized as A, B, C, D, or E
(Microbial Water Quality Assessment or MWQA categories) with
corresponding colors, where the breakpoints for each category are \<10\\

If the input data are from
[`read_importentero`](https://tbep-tech.github.io/tbeptools/reference/read_importentero.md)
(baywide assessment), the results can be summarized by bay segment if
`bay_segment` is not `NULL`. The `stas` argument is ignored and all
stations within each bay segment watershed are used to evaluate the FIB
categories.

`yrrng` can be specified several ways. If `yrrng = NULL`, the year range
of the data for the selected changes is chosen. User-defined values for
the minimum and maximum years can also be used, or only a minimum or
maximum can be specified, e.g., `yrrng = c(2000, 2010)` or
`yrrng = c(2000, NA)`. In the latter case, the maximum year will be
defined by the data.

The default stations if the input is from
[`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md)
(EPC data) and if `bay_segment` is `NULL` are those used in TBEP report
\#05-13
(<https://drive.google.com/file/d/1MZnK3cMzV7LRg6dTbCKX8AOZU0GNurJJ/view>)
for the Hillsborough River Basin Management Action Plan (BMAP)
subbasins. These include Blackwater Creek (WBID 1482, EPC stations 143,
108), Baker Creek (WBID 1522C, EPC station 107), Lake Thonotosassa (WBID
1522B, EPC stations 135, 118), Flint Creek (WBID 1522A, EPC station
148), and the Lower Hillsborough River (WBID 1443E, EPC stations 105,
152, 137). Other stations can be plotted using the `stas` argument.

Input from
[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md)
for Manatee County (21FLMANA_WQX), Pasco County (21FLPASC_WQX), or Polk
County (21FLPOLK_WQX) FIB data can also be used. The function has not
been tested for other organizations.

## See also

[`show_fibmatrix`](https://tbep-tech.github.io/tbeptools/reference/show_fibmatrix.md)

## Examples

``` r
anlz_fibmatrix(fibdata)
#> # A tibble: 102 × 7
#>       yr grp   class  gmean Latitude Longitude cat  
#>    <dbl> <fct> <chr>  <dbl>    <dbl>     <dbl> <chr>
#>  1  2003 105   Marine  97.1     28.0     -82.4 C    
#>  2  2003 152   Marine 266.      28.0     -82.5 D    
#>  3  2003 137   Marine 342.      28.0     -82.5 D    
#>  4  2004 105   Marine 216.      28.0     -82.4 C    
#>  5  2004 152   Marine 246.      28.0     -82.5 C    
#>  6  2004 137   Marine 302.      28.0     -82.5 D    
#>  7  2005 105   Marine 117.      28.0     -82.4 C    
#>  8  2005 152   Marine  91.7     28.0     -82.5 C    
#>  9  2005 137   Marine  66.6     28.0     -82.5 C    
#> 10  2006 105   Marine  90.7     28.0     -82.4 C    
#> # ℹ 92 more rows

# use different dataset
anlz_fibmatrix(enterodata, lagyr = 1)
#> Warning: Stations with insufficient data for lagyr: 21FLPDEM_WQX-05-06
#> # A tibble: 684 × 7
#>       yr grp                    class  gmean Latitude Longitude cat  
#>    <dbl> <fct>                  <chr>  <dbl>    <dbl>     <dbl> <chr>
#>  1  2000 21FLDOH_WQX-MANATEE152 Marine  10.7     27.5     -82.7 A    
#>  2  2001 21FLDOH_WQX-MANATEE152 Marine  16.0     27.5     -82.7 A    
#>  3  2001 21FLHILL_WQX-101       Marine 284.      28.0     -82.6 C    
#>  4  2001 21FLHILL_WQX-102       Marine  55.7     28.0     -82.6 A    
#>  5  2001 21FLHILL_WQX-103       Marine 214.      28.0     -82.6 B    
#>  6  2001 21FLHILL_WQX-104       Marine 408.      28.0     -82.6 D    
#>  7  2001 21FLHILL_WQX-109       Marine  97.8     27.9     -82.4 B    
#>  8  2001 21FLHILL_WQX-112       Marine  48.3     27.7     -82.4 A    
#>  9  2001 21FLHILL_WQX-133       Marine 747.      27.9     -82.4 D    
#> 10  2001 21FLHILL_WQX-136       Marine  26.1     27.7     -82.5 A    
#> # ℹ 674 more rows

# subset to only wet samples
anlz_fibmatrix(enterodata, lagyr = 1, subset_wetdry = "wet",
               temporal_window = 2, wet_threshold = 0.5)
#> # A tibble: 500 × 7
#>       yr grp                    class   gmean Latitude Longitude cat  
#>    <dbl> <fct>                  <chr>   <dbl>    <dbl>     <dbl> <chr>
#>  1  2001 21FLDOH_WQX-MANATEE152 Marine   31.6     27.5     -82.7 A    
#>  2  2001 21FLHILL_WQX-101       Marine 2252.      28.0     -82.6 C    
#>  3  2001 21FLHILL_WQX-102       Marine   66.0     28.0     -82.6 A    
#>  4  2001 21FLHILL_WQX-103       Marine  472.      28.0     -82.6 B    
#>  5  2001 21FLHILL_WQX-104       Marine 3284.      28.0     -82.6 C    
#>  6  2001 21FLHILL_WQX-109       Marine  133.      27.9     -82.4 A    
#>  7  2001 21FLHILL_WQX-112       Marine   40       27.7     -82.4 A    
#>  8  2001 21FLHILL_WQX-133       Marine 3286.      27.9     -82.4 C    
#>  9  2002 21FLDOH_WQX-MANATEE152 Marine   13.7     27.5     -82.7 A    
#> 10  2002 21FLHILL_WQX-101       Marine  531.      28.0     -82.6 C    
#> # ℹ 490 more rows

# Manatee County data
anlz_fibmatrix(mancofibdata, lagyr = 1)
#> # A tibble: 200 × 7
#>       yr grp   class   gmean Latitude Longitude cat  
#>    <dbl> <fct> <chr>   <dbl>    <dbl>     <dbl> <chr>
#>  1  2013 LM4   Marine  771.      27.5     -82.5 C    
#>  2  2014 LM3   Marine  161       27.5     -82.5 A    
#>  3  2014 LM4   Marine  387       27.5     -82.5 A    
#>  4  2015 LM3   Marine  259.      27.5     -82.5 C    
#>  5  2015 LM4   Marine  222.      27.5     -82.5 C    
#>  6  2016 LM4   Marine 2419       27.5     -82.5 A    
#>  7  2017 LM3   Marine 1553       27.5     -82.5 A    
#>  8  2018 BC1   Fresh  1591.      27.4     -82.6 C    
#>  9  2018 BC2   Fresh   674.      27.4     -82.6 C    
#> 10  2018 BR1   Fresh    16.6     27.4     -82.5 A    
#> # ℹ 190 more rows
```
