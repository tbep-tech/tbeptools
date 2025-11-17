# Plot annual water quality values, targets, and thresholds for a segment

Plot annual water quality values, targets, and thresholds for a bay
segment

## Usage

``` r
show_thrplot(
  epcdata,
  bay_segment = c("OTB", "HB", "MTB", "LTB"),
  thr = c("chla", "la"),
  trgs = NULL,
  yrrng = c(1975, 2024),
  family = "sans",
  labelexp = TRUE,
  txtlab = TRUE,
  thrs = FALSE,
  partialyr = FALSE
)
```

## Arguments

- epcdata:

  data frame of epc data returned by
  [`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

- bay_segment:

  chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB"

- thr:

  chr string indicating which water quality value and appropriate
  target/threshold to plot, one of "chl" for chlorophyll and "la" for
  light availability

- trgs:

  optional `data.frame` for annual bay segment water quality
  targets/thresholds, defaults to
  [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.md)

- yrrng:

  numeric vector indicating min, max years to include

- family:

  optional chr string indicating font family for text labels

- labelexp:

  logical indicating if y axis and target labels are plotted as
  expressions, default `TRUE`

- txtlab:

  logical indicating if a text label for the target value is shown in
  the plot

- thrs:

  logical indicating if reference lines are shown only for the
  regulatory threshold

- partialyr:

  logical indicating if incomplete annual data for the most recent year
  are approximated by five year monthly averages for each parameter

## Value

A [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object

## Examples

``` r
show_thrplot(epcdata, bay_segment = 'OTB', thr = 'chl')
```
