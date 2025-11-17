# Plot a matrix of Fecal Indicator Bacteria categories over time by station or bay segment

Plot a matrix of Fecal Indicator Bacteria categories over time by
station or bay segment

## Usage

``` r
show_fibmatrix(
  fibdata,
  yrrng = NULL,
  stas = NULL,
  bay_segment = NULL,
  lagyr = 3,
  subset_wetdry = c("all", "wet", "dry"),
  precipdata = NULL,
  temporal_window = NULL,
  wet_threshold = NULL,
  txtsz = 3,
  asreact = FALSE,
  nrows = 10,
  family = "sans",
  angle = 90,
  size = 10,
  hjust = 0,
  plotly = FALSE,
  width = NULL,
  height = NULL,
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

- txtsz:

  numeric for size of text in the plot, applies only if `tab = FALSE`.
  Use `txtsz = NULL` to suppress.

- asreact:

  logical indicating if a
  [`reactable`](https://glin.github.io/reactable/reference/reactable.html)
  object is returned

- nrows:

  if `asreact = TRUE`, a numeric specifying number of rows in the table

- family:

  optional chr string indicating font family for text labels

- angle:

  numeric for angle of x-axis text labels

- size:

  numeric for size of the x-axis text labels

- hjust:

  numeric for horizontal justification of x-axis text labels

- plotly:

  logical if matrix is created using plotly

- width:

  numeric for width of the plot in pixels, only applies of
  `plotly = TRUE`

- height:

  numeric for height of the plot in pixels, only applies of
  `plotly = TRUE`

- warn:

  logical to print warnings about stations with insufficient data,
  default `TRUE`

## Value

A static [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object is returned by default. A
[`reactable`](https://glin.github.io/reactable/reference/reactable.html)
table is returned if `asreact = TRUE`. An interactive
[`plotly`](https://rdrr.io/pkg/plotly/man/plotly.html) object is
returned if `plotly = TRUE`.

## Details

The matrix color codes years and stations based on the likelihood of
fecal indicator bacteria concentrations exceeding 410 CFU / 100 mL for
E. coli (fresh) or 130 CFU / 100 mL for Enterococcus (marine). Bay
segments are used instead of stations if `bay_segment` is not `NULL` and
the input data are from
[`read_importentero`](https://tbep-tech.github.io/tbeptools/reference/read_importentero.md).
The likelihoods are categorized as A, B, C, D, or E (Microbial Water
Quality Assessment or MWQA categories) with corresponding colors, where
the breakpoints for each category are \<10%, 10-30%, 30-50%, 50-75%, and
\>75% (right-closed). By default, the results for each year are based on
a right-centered window that uses the previous two years and the current
year to calculate probabilities from the monthly samples (`lagyr = 3`).
Methods and rationale for this categorization scheme are provided by the
Florida Department of Environmental Protection, Figure 8 in the document
at
<http://publicfiles.dep.state.fl.us/DEAR/BMAP/Tampa/MST%20Report/Fecal%20BMAP%20DST%20Final%20Report%20--%20June%202008.pdf>
and Morrison et al. 2009 in the [BASIS 5
proceedings](https://drive.google.com/file/d/1vaoAKkwSLlIS2RzeBeCTjQST1dUmo0rr/view).

See
[`anlz_fibmatrix`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibmatrix.md)
for additional details on the arguments.

## See also

[`anlz_fibmatrix`](https://tbep-tech.github.io/tbeptools/reference/anlz_fibmatrix.md)

## Examples

``` r
show_fibmatrix(fibdata)


# show matrix for only dry samples
show_fibmatrix(enterodata, lagyr = 1, subset_wetdry = "dry",
               temporal_window = 2, wet_threshold = 0.5)
#> Warning: Stations with insufficient data for lagyr: 21FLPDEM_WQX-05-06
```
