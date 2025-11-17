# Make a bar plot for transect training group comparisons

Make a bar plot for transect training group comparisons

## Usage

``` r
show_compplot(
  transect,
  yr,
  site,
  species = c("Halodule", "Syringodium", "Thalassia", "Halophila", "Ruppia"),
  varplo = c("Abundance", "Blade Length", "Short Shoot Density"),
  base_size = 18,
  xtxt = 10,
  size = 1
)
```

## Arguments

- transect:

  data frame returned by
  [`read_transect`](https://tbep-tech.github.io/tbeptools/reference/read_transect.md)

- yr:

  numeric for year of training data to plot

- site:

  chr string indicating site results to plot

- species:

  chr string indicating which species to plot

- varplo:

  chr string indicating which variable to plot

- base_size:

  numeric indicating text scaling size for plot

- xtxt:

  numeric indicating text size for x-axis labels

- size:

  numeric indicating line size

## Value

A [`ggplot`](https://ggplot2.tidyverse.org/reference/ggplot.html) object

## Examples

``` r
transect <- read_transect(training = TRUE)
show_compplot(transect, yr = 2025, site = '3', species = 'Halodule', varplo = 'Abundance')
#> Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
#> ℹ Please use `linewidth` instead.
#> ℹ The deprecated feature was likely used in the tbeptools package.
#>   Please report the issue at <https://github.com/tbep-tech/tbeptools/issues>.
```
