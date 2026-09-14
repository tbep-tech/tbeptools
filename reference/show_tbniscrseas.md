# Plot seasonal Tampa Bay Nekton Index results by month and bay segment

Plot seasonal Tampa Bay Nekton Index results by month and bay segment

## Usage

``` r
show_tbniscrseas(
  tbniscr,
  bay_segment = c("OTB", "HB", "MTB", "LTB"),
  yr,
  metric = NULL,
  perc = c(32, 46),
  alph = 1,
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

  chr string for the bay segment to plot, one of "OTB", "HB", "MTB",
  "LTB"

- yr:

  numeric for the year to plot

- metric:

  chr string for the column in `tbniscr` to plot on the y-axis, defaults
  to `NULL` to plot `"TBNI_Score"`, otherwise an individual TBNI metric
  can be specified, one of "TBNI_Score", "NumTaxa", "BenthicTaxa",
  "TaxaSelect", "NumGuilds", or "Shannon"

- perc:

  numeric values indicating break points for score categories, only used
  if `metric` is `NULL`

- alph:

  numeric indicating alpha value for the score category background
  colors and the boxplot fill, only used if `metric` is `NULL`

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
showing monthly results for `yr` in `bay_segment` for the selected
metric, or a [`plotly`](https://rdrr.io/pkg/plotly/man/plotly.html)
object if `plotly = TRUE`

## Details

Boxplots show the distribution of site-level results by month for `yr`
in `bay_segment`, with individual site values overlaid as jittered
points. If `metric` is `NULL`, the TBNI score is plotted with the same
red/yellow/green score category background and break lines from `perc`
as in
[`show_tbniscr`](https://tbep-tech.github.io/tbeptools/reference/show_tbniscr.md).
If `metric` is specified, the selected metric is plotted as raw values
(note that scored metrics cannot be shown). Metric options include
`"TBNI_Score"` or `NULL` (default), `"NumTaxa"`, `"BenthicTaxa"`,
`"TaxaSelect"`, `"NumGuilds"`, and `"Shannon"`.

## Examples

``` r
tbniscr <- anlz_tbniscr(fimdata)
show_tbniscrseas(tbniscr, yr = 2018)
```
