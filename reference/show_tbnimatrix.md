# Plot a matrix of Tampa Bay Nekton Index scores over time by bay segment

Plot a matrix of Tampa Bay Nekton Index scores over time by bay segment

## Usage

``` r
show_tbnimatrix(
  tbniscr,
  bay_segment = c("OTB", "HB", "MTB", "LTB"),
  perc = c(32, 46),
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

- tbniscr:

  input data frame as returned by
  [`anlz_tbniscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniscr.md)

- bay_segment:

  chr string for the bay segment, one to many of "OTB", "HB", "MTB",
  "LTB"

- perc:

  numeric values indicating break points for score categories

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
showing trends over time in TBNI scores for each bay segment

## Examples

``` r
tbniscr <- anlz_tbniscr(fimdata)
show_tbnimatrix(tbniscr)
```
