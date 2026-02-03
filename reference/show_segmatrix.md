# Create a colorized table for water quality outcomes and exceedances by segment

Create a colorized table for water quality outcomes by segment that
includes the management action and chlorophyll, and light attenuation
exceedances

## Usage

``` r
show_segmatrix(
  epcdata,
  txtsz = 3,
  trgs = NULL,
  yrrng = c(1975, 2025),
  bay_segment = c("OTB", "HB", "MTB", "LTB"),
  abbrev = FALSE,
  family = "sans",
  historic = TRUE,
  plotly = FALSE,
  partialyr = FALSE,
  width = NULL,
  height = NULL
)
```

## Arguments

- epcdata:

  data frame of epc data returned by
  [`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

- txtsz:

  numeric for size of text in the plot, applies only if `tab = FALSE`

- trgs:

  optional `data.frame` for annual bay segment water quality targets,
  defaults to
  [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.md)

- yrrng:

  numeric vector indicating min, max years to include

- bay_segment:

  chr string for bay segments to include, only one of "OTB", "HB",
  "MTB", "LTB"

- abbrev:

  logical indicating if text labels in the plot are abbreviated as the
  first letter

- family:

  optional chr string indicating font family for text labels

- historic:

  logical if historic data are used from 2005 and earlier

- plotly:

  logical if matrix is created using plotly

- partialyr:

  logical indicating if incomplete annual data for the most recent year
  are approximated by five year monthly averages for each parameter

- width:

  numeric for width of the plot in pixels, only applies of
  `plotly = TRUE`

- height:

  numeric for height of the plot in pixels, only applies of
  `plotly = TRUE`

## Value

A static [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html)
object is returned

## Details

This function provides a combined output for the
[`show_wqmatrix`](https://tbep-tech.github.io/tbeptools/reference/show_wqmatrix.md)
and
[`show_matrix`](https://tbep-tech.github.io/tbeptools/reference/show_matrix.md)
functions. Only one bay segment can be plotted for each function call.

## See also

[`show_wqmatrix`](https://tbep-tech.github.io/tbeptools/reference/show_wqmatrix.md),
[`show_matrix`](https://tbep-tech.github.io/tbeptools/reference/show_matrix.md)

## Examples

``` r
show_segmatrix(epcdata, bay_segment = 'OTB')
```
