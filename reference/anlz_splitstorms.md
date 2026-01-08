# Analyze storm data split by date within years

Analyze storm data split by date within years

## Usage

``` r
anlz_splitstorms(
  df_hurricane,
  date_split,
  stats = list(sum = sum, avg = mean, n = length)
)
```

## Arguments

- df_hurricane:

  data frame containing date_beg and scale columns for hurricanes

- date_split:

  date to split analysis into annual periods

- stats:

  list of functions to apply to scale values, default: sum, average and
  count. Functions should accept numeric vector input and return single
  value

## Value

A tibble summarizing hurricanes for annual periods "before" and "after"
the split date, with requested statistics computed for the scale values

## Examples

``` r
# Create sample hurricane data
hurricanes <- data.frame(
  date_beg = as.Date(c(
    "1980-07-31", "1980-09-04", "1980-11-07",
    "1981-05-06", "1981-08-07", "1981-11-12")),
  scale = c(6, 1, 3, 1, 2, 1))

# Basic analysis with default statistics (sum, average and count)
split_date <- Sys.Date() - lubridate::years(1)
anlz_splitstorms(hurricanes, split_date)
#> # A tibble: 2 × 5
#>    year period   sum   avg     n
#>   <dbl> <ord>  <dbl> <dbl> <int>
#> 1  1981 before    10  3.33     3
#> 2  1982 before     4  1.33     3

# Analysis with custom statistics
anlz_splitstorms(hurricanes, split_date,
                     stats = list(
                       max = max,
                       min = min))
#> # A tibble: 2 × 4
#>    year period   max   min
#>   <dbl> <ord>  <dbl> <dbl>
#> 1  1981 before     6     1
#> 2  1982 before     2     1
```
