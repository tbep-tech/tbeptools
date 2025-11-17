# Plot Tampa Bay Nekton Index scores over time as average across bay segments

Plot Tampa Bay Nekton Index scores over time as average across bay
segments

## Usage

``` r
show_tbniscrall(
  tbniscr,
  perc = c(32, 46),
  alph = 1,
  ylim = c(22, 58),
  rev = FALSE,
  plotly = FALSE
)
```

## Arguments

- tbniscr:

  input dat frame as returned by
  [`anlz_tbniscr`](https://tbep-tech.github.io/tbeptools/reference/anlz_tbniscr.md)

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

## Value

A [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object
showing trends over time in TBNI scores for each bay segment or a
[`plotly`](https://rdrr.io/pkg/plotly/man/plotly.html) object if
`plotly = TRUE`

## Examples

``` r
tbniscr <- anlz_tbniscr(fimdata)
show_tbniscrall(tbniscr)
```
