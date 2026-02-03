# Map site and bay segment attainment categories for a selected year

Map site and bay segment attainment categories for a selected year

## Usage

``` r
show_sitesegmap(
  epcdata,
  yrsel,
  param = c("chla", "la"),
  trgs = NULL,
  thrs = FALSE,
  partialyr = FALSE,
  showseg = TRUE,
  base_size = 12,
  family = "sans"
)
```

## Arguments

- epcdata:

  data frame of epc data returned by
  [`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

- yrsel:

  numeric for year to plot

- param:

  chr string for which parameter to plot, one of `"chla"` for
  chlorophyll or `"la"` for light attenuation

- trgs:

  optional `data.frame` for annual bay segment water quality targets,
  defaults to
  [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.md)

- thrs:

  logical indicating if attainment category is relative to targets
  (default) or thresholds, passed to
  [`anlz_attainsite`](https://tbep-tech.github.io/tbeptools/reference/anlz_attainsite.md)

- partialyr:

  logical indicating if incomplete annual data for the most recent year
  are approximated by five year monthly averages for each parameter

- showseg:

  logical indicating of bay segment labels are included

- base_size:

  numeric indicating text scaling size for plot

- family:

  optional chr string indicating font family for text labels

## Value

A static `ggplot` object is returned

## Details

The map is similar to that returned by
[`show_sitemap`](https://tbep-tech.github.io/tbeptools/reference/show_sitemap.md)
with the addition of polygons for each bay segment colored by the annual
attainment category and the site points are sized relative to the
selected parameter in `param`.

## Examples

``` r
show_sitesegmap(epcdata, yrsel = 2025)
#> Coordinate system already present.
#> ℹ Adding new coordinate system, which will replace the existing one.
```
