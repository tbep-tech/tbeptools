# Plot a matrix of Tampa Bay Benthic Index scores over time by bay segment

Plot a matrix of Tampa Bay Benthic Index scores over time by bay segment

## Usage

``` r
show_tbbimatrix(
  tbbiscr,
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB", "All", "All (wt)"),
  yrrng = c(1993, 2024),
  alph = 1,
  txtsz = 3,
  family = "sans",
  rev = FALSE,
  position = "top",
  plotly = FALSE,
  width = NULL,
  height = NULL
)
```

## Arguments

- tbbiscr:

  input data frame as returned by
  [`anlz_tbbiscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbbiscr.md)

- bay_segment:

  chr string for the bay segment, one to many of "HB", "OTB", "MTB",
  "LTB", "TCB", "MR", "BCB", "All", "All (wt)"

- yrrng:

  numeric indicating year ranges to evaluate

- alph:

  numeric indicating alpha value for score category colors

- txtsz:

  numeric for size of text in the plot

- family:

  optional chr string indicating font family for text labels

- rev:

  logical if factor levels for bay segments are reversed

- position:

  chr string of location for bay segment labels, default on top, passed
  to
  [`scale_x_discrete`](https://ggplot2.tidyverse.org/reference/scale_discrete.html)

- plotly:

  logical if matrix is created using plotly

- width:

  numeric for width of the plot in pixels, only applies of
  `plotly = TRUE`

- height:

  numeric for height of the plot in pixels, only applies of
  `plotly = TRUE`

## Value

A [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object
showing trends over time in TBBI scores for each bay segment if
`plotly = FALSE`, otherwise a
[`plotly`](https://rdrr.io/pkg/plotly/man/plotly.html) object

## Details

Additional summaries are provided for the entire bay, as a summary
across categories ("All") and a summary weighted across the relative
sizes of each bay segment ("All (wt)").

## Examples

``` r
tbbiscr <- anlz_tbbiscr(benthicdata)
show_tbbimatrix(tbbiscr)
```
