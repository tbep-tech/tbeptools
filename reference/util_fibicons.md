# Return leaflet icon set for FIB maps

Return leaflet icon set for FIB maps

## Usage

``` r
util_fibicons(indic)
```

## Arguments

- indic:

  character indicating `"entero"`, `"entero&ecoli"`, or `"fibmat"` for
  *Enterococcus*, Fecal *Enterococcus* and *E. coli*, or FIB matrix
  maps, respectively

## Value

A leaflet icon set as returned by
[`iconList`](https://rstudio.github.io/leaflet/reference/iconList.html).

## Details

Used internally with
[`show_enteromap`](https://tbep-tech.github.io/tbeptools/reference/show_enteromap.md)
for wet/dry icons for *Enterococcus*, with
[`show_fibmap`](https://tbep-tech.github.io/tbeptools/reference/show_fibmap.md)
for *E. Coli*/*Enterococcus* icons (EPCHC data), and with
[`show_fibmatmap`](https://tbep-tech.github.io/tbeptools/reference/show_fibmatmap.md)
for matrix annual score category icons for EPCHC and non-EPCHC data.

## Examples

``` r
util_fibicons(indic = 'entero')
#> $entero_green_wet
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/ecoli_green.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_yellow_wet
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/ecoli_yellow.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_orange_wet
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/ecoli_orange.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_red_wet
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/ecoli_red.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_green_dry
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/entero_green.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_yellow_dry
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/entero_yellow.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_orange_dry
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/entero_orange.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_red_dry
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/entero_red.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> attr(,"class")
#> [1] "leaflet_icon_set"
util_fibicons(indic = 'entero&ecoli')
#> $ecoli_green
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/ecoli_green.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $ecoli_yellow
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/ecoli_yellow.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $ecoli_orange
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/ecoli_orange.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $ecoli_red
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/ecoli_red.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_green
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/entero_green.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_yellow
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/entero_yellow.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_orange
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/entero_orange.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $entero_red
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/entero_red.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> attr(,"class")
#> [1] "leaflet_icon_set"
util_fibicons(indic = 'fibmat')
#> $fibmat_green
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/fibmat_green.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $fibmat_yellow
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/fibmat_yellow.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $fibmat_orange
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/fibmat_orange.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $fibmat_red
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/fibmat_red.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> $fibmat_purple
#> $iconUrl
#> [1] "/home/runner/work/_temp/Library/tbeptools/fibmat_purple.png"
#> 
#> $iconWidth
#> [1] 18
#> 
#> $iconHeight
#> [1] 18
#> 
#> attr(,"class")
#> [1] "leaflet_icon"
#> 
#> attr(,"class")
#> [1] "leaflet_icon_set"
```
