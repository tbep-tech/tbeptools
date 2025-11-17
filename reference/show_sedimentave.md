# Plot sediment concentration averages by bay segment

Plot sediment concentration averages by bay segment

## Usage

``` r
show_sedimentave(
  sedimentdata,
  param,
  yrrng = c(1993, 2023),
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"),
  funding_proj = "TBEP",
  lnsz = 1,
  base_size = 12,
  plotly = FALSE,
  family = "sans",
  width = NULL,
  height = NULL
)
```

## Arguments

- sedimentdata:

  input sediment `data.frame` as returned by
  [`read_importsediment`](https://tbep-tech.github.io/tbeptools/reference/read_importsediment.md)

- param:

  chr string for which parameter to plot

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

- lnsz:

  numeric for line size

- base_size:

  numeric indicating text scaling size for plot

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
or a [`plotly`](https://rdrr.io/pkg/plotly/man/plotly.html) object if
`plotly = TRUE` showing sediment averages and 95% confidence intervals
of the selected parameter concentrations for each bay segment

## Details

Lines for the Threshold Effect Level (TEL) and Potential Effect Level
(PEL) are shown for the parameter, if available. Confidence intervals
may not be shown for segments with insufficient data.

## Examples

``` r
show_sedimentave(sedimentdata, param = 'Arsenic')
```
