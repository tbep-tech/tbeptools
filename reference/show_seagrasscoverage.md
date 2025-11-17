# Create a barplot of seagrass coverage over time in Tampa Bay

Create a barplot of seagrass coverage over time in Tampa Bay

## Usage

``` r
show_seagrasscoverage(
  seagrass,
  maxyr = 2024,
  family = "sans",
  lastlab = T,
  axsbrk = c(0.08, 0.1)
)
```

## Arguments

- seagrass:

  input `data.frame` included with the package as
  [`seagrass`](https://tbep-tech.github.io/tbeptools/reference/seagrass.md)

- maxyr:

  numeric for maximum year to plot

- family:

  optional chr string indicating font family for text labels

- lastlab:

  logical indicating if text label on `maxyr` should be included

- axsbrk:

  numeric vector of length two indicating where the x-axis break occurs

## Value

A grid object showing acres of total seagrass coverage in Tampa Bay over
time.

## Details

This function creates the flagship seagrass coverage graphic to report
on coverage changes over time. All data were pre-processed and included
in the package as the
[`seagrass`](https://tbep-tech.github.io/tbeptools/reference/seagrass.md)
dataset. Original data are from the Southwest Florida Water Management
District and available online at
https://data-swfwmd.opendata.arcgis.com/. This function and the data
used to create the plot are distinct from those used for the transect
monitoring program.

## Examples

``` r
show_seagrasscoverage(seagrass)
```
