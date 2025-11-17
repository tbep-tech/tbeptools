# Analyze time series data split by date within years

Analyze time series data split by date within years

## Usage

``` r
anlz_splitdata(
  df,
  date_split,
  date_col = "date",
  value_col = "value",
  stats = list(avg = mean)
)
```

## Arguments

- df:

  data frame containing date and value columns

- date_split:

  date to split analysis into annual periods

- date_col:

  name of the date column

- value_col:

  name of the value column

- stats:

  list of functions to apply to values, default: `list(avg = mean)`

## Value

A tibble summarizing data for annual periods "before" and "after" the
split date

## Examples

``` r
# Create sample data
data <- data.frame(
  date = seq.Date(as.Date("2010-01-01"), as.Date("2020-12-31"), by = "month"),
  value = rnorm(132, mean = 10, sd = 2))

# Basic analysis with default statistics
split_date <- as.Date("2015-06-15")
anlz_splitdata(data, split_date, "date", "value")
#> # A tibble: 12 × 3
#>     year period   avg
#>    <dbl> <ord>  <dbl>
#>  1  2010 before  9.96
#>  2  2011 before 10.2 
#>  3  2012 before 10.3 
#>  4  2013 before  9.91
#>  5  2014 before  9.65
#>  6  2015 before 11.4 
#>  7  2016 after  10.4 
#>  8  2017 after   9.17
#>  9  2018 after  10.4 
#> 10  2019 after  10.7 
#> 11  2020 after   9.96
#> 12  2021 after  10.6 
```
