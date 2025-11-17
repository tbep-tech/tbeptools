# Radar plots for tidal creek indicators

Radar plots for tidal creek indicators

## Usage

``` r
show_tdlcrkradar(
  id,
  cntdat,
  col = "#338080E6",
  ptsz = 1,
  lbsz = 0.8,
  valsz = 1,
  brdwd = 5
)
```

## Arguments

- id:

  numeric indicating the `id` number of the tidal creek to plot

- cntdat:

  output from
  [`anlz_tdlcrkindic`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrkindic.md)

- col:

  color input for polygon and line portions

- ptsz:

  numeric size of points

- lbsz:

  numeric for size of text labels

- valsz:

  numeric for size of numeric value labels

- brdwd:

  numeric for polygon border width

## Value

A radar plot

## Details

See details in
[`anlz_tdlcrkindic`](https://tbep-tech.github.io/tbeptools/reference/anlz_tdlcrkindic.md)
for an explanation of the indicators

Internal code borrowed heavily from the radarchart function in the fmsb
package.

## Examples

``` r
cntdat <- anlz_tdlcrkindic(tidalcreeks, iwrraw, yr = 2024, radar = TRUE)

set.seed(123)
id <- sample(unique(cntdat$id), 1)
show_tdlcrkradar(id, cntdat)
```
