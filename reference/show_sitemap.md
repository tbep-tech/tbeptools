# Map site attainment categories for a selected year

Map site attainment categories for a selected year

## Usage

``` r
show_sitemap(
  epcdata,
  yrsel,
  mosel = c(1, 12),
  param = c("chla", "la"),
  trgs = NULL,
  thrs = FALSE,
  showseg = TRUE,
  partialyr = FALSE
)
```

## Arguments

- epcdata:

  data frame of epc data returned by
  [`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

- yrsel:

  numeric for year to plot

- mosel:

  optional numeric of length one or two for mapping results for a
  specific month or month range in a given year, default full year

- param:

  chr string for which parameter to plot, one of `"chla"` for
  chlorophyll or `"la"` for light attenuation

- trgs:

  optional `data.frame` for annual bay segment water quality targets,
  defaults to
  [`targets`](https://tbep-tech.github.io/tbeptools/reference/targets.md),
  only applies if `mosel = c(1, 12)`

- thrs:

  logical indicating if attainment category is relative to targets
  (default) or thresholds, passed to
  [`anlz_attainsite`](https://tbep-tech.github.io/tbeptools/reference/anlz_attainsite.md),
  only applies if `mosel = c(1, 12)`

- showseg:

  logical indicating of bay segment labels are included

- partialyr:

  logical indicating if incomplete annual data for the most recent year
  are approximated by five year monthly averages for each parameter,
  only applies if `mosel = c(1, 12)`

## Value

A static `ggplot` object is returned

## Examples

``` r
show_sitemap(epcdata, yrsel = 2025)
#> Coordinate system already present.
#> ℹ Adding new coordinate system, which will replace the existing one.
```
