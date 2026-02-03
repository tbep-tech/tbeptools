# Create a colorized table for chlorophyll or light attenuation exceedances

Create a colorized table for chlorophyll or light attenuation
exceedances

## Usage

``` r
show_wqmatrix(
  epcdata,
  param = c("chla", "la"),
  txtsz = 3,
  trgs = NULL,
  yrrng = c(1975, 2025),
  bay_segment = c("OTB", "HB", "MTB", "LTB"),
  asreact = FALSE,
  nrows = 10,
  abbrev = FALSE,
  family = "sans",
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

- param:

  chr string for which parameter to plot, one of `"chla"` for
  chlorophyll or `"la"` for light attenuation

- txtsz:

  numeric for size of text in the plot, applies only if `tab = FALSE`

- trgs:

  optional `data.frame` for annual bay segment water quality targets,
  defaults to
  [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.md)

- yrrng:

  numeric vector indicating min, max years to include

- bay_segment:

  chr string for bay segments to include, one to all of "OTB", "HB",
  "MTB", "LTB"

- asreact:

  logical indicating if a
  [`reactable`](https://glin.github.io/reactable/reference/reactable.html)
  object is returned

- nrows:

  if `asreact = TRUE`, a numeric specifying number of rows in the table

- abbrev:

  logical indicating if text labels in the plot are abbreviated as the
  first letter

- family:

  optional chr string indicating font family for text labels

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
object is returned if `asreact = FALSE`, otherwise a
[`reactable`](https://glin.github.io/reactable/reference/reactable.html)
table is returned

## See also

[`show_matrix`](https://tbep-tech.github.io/tbeptools/reference/show_matrix.md),
[`show_segmatrix`](https://tbep-tech.github.io/tbeptools/reference/show_segmatrix.md)

## Examples

``` r
show_wqmatrix(epcdata)
```
