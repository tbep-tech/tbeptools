# Add a line or annotation to a plotly graph

Add a line or annotation to a plotly graph for the tidal creek
indicators

## Usage

``` r
show_tdlcrkline(
  varin = c("CHLAC", "TN", "chla_tn_ratio", "DO", "tsi", "no23_ratio"),
  thrsel = FALSE,
  horiz = TRUE,
  annotate = FALSE
)
```

## Arguments

- varin:

  chr string for the indicator

- thrsel:

  logical if something is returned, otherwise NULL, this is a hack for
  working with the plotly output

- horiz:

  logical indicating if output is horizontal or vertical

- annotate:

  logical indicating if output is line or annotation text

## Value

A list object passed to the layout argument of plotly, either shapes or
annotate depending on user input

## Details

This function is used internally within
[`show_tdlcrkindic`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkindic.md)
and
[`show_tdlcrkindiccdf`](https://tbep-tech.github.io/tbeptools/reference/show_tdlcrkindiccdf.md)

## Examples

``` r
# code for vertical line output, chloropyll
show_tdlcrkline('CHLAC', thrsel = TRUE)
#> [[1]]
#> [[1]]$type
#> [1] "line"
#> 
#> [[1]]$x0
#> [1] 0
#> 
#> [[1]]$x1
#> [1] 1
#> 
#> [[1]]$xref
#> [1] "paper"
#> 
#> [[1]]$y0
#> [1] 11
#> 
#> [[1]]$y1
#> [1] 11
#> 
#> [[1]]$line
#> [[1]]$line$color
#> [1] "red"
#> 
#> [[1]]$line$dash
#> [1] 10
#> 
#> 
#> 
```
