# Plot Tampa Bay Nekton Index scores over time by bay segment

Plot Tampa Bay Nekton Index scores over time by bay segment

## Usage

``` r
show_tbniscr(
  tbniscr,
  bay_segment = c("OTB", "HB", "MTB", "LTB"),
  perc = c(32, 46),
  alph = 1,
  ylim = c(22, 58),
  rev = FALSE,
  plotly = FALSE,
  family = "sans",
  width = NULL,
  height = NULL
)
```

## Arguments

- tbniscr:

  input dat frame as returned by
  [`anlz_tbniscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniscr.md)

- bay_segment:

  chr string for the bay segment, one to many of "OTB", "HB", "MTB",
  "LTB"

- perc:

  numeric values indicating break points for score categories

- alph:

  numeric indicating alpha value for score category colors

- ylim:

  numeric for y axis limits

- rev:

  logical if factor levels for bay segments are reversed

- plotly:

  logical if matrix is created using plotly

- family:

  optional chr string indicating font family for text labels

- width:

  numeric for width of the plot in pixels, only applies of
  `plotly = TRUE`

- height:

  numeric for height of the plot in pixels, only applies of
  `plotly = TRUE`

## Value

A [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object
showing trends over time in TBNI scores for each bay segment or a
[`plotly`](https://rdrr.io/pkg/plotly/man/plotly.html) object if
`plotly = TRUE`

## Examples

``` r
tbniscr <- anlz_tbniscr(fimdata)
show_tbniscr(tbniscr)
```
