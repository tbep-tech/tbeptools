# Format a Vector of Years into a Concise Range

Takes a vector of years and formats it into a concise string
representation. For consecutive years within the same century, the end
year is shortened (e.g., "2010-14"). For years spanning different
centuries or non-consecutive years, full years are used (e.g.,
"1998-2001"). Optional prefix and suffix can be added to the formatted
range.

## Usage

``` r
util_frmyrrng(years, prefix = "", suffix = "")
```

## Arguments

- years:

  Numeric vector of years (integers). Can be a single year or multiple
  years.

- prefix:

  Character string to prepend to the formatted range. Default is empty
  string.

- suffix:

  Character string to append to the formatted range. Default is empty
  string.

## Value

A character string representing the year range in a concise format, with
optional prefix and suffix. Returns an empty character vector if input
is NULL or empty.

## Examples

``` r
# Basic usage
util_frmyrrng(2023)  # Returns "2023"
#> [1] "2023"
util_frmyrrng(2020:2024)  # Returns "2020-24"
#> [1] "2020-24"

# Using prefix and suffix
util_frmyrrng(2023, prefix = "FY ")  # Returns "FY 2023"
#> [1] "FY 2023"
util_frmyrrng(2020:2024, suffix = " AD")  # Returns "2020-24 AD"
#> [1] "2020-24 AD"
util_frmyrrng(2020:2024, prefix = "Years ", suffix = " CE")  # Returns "Years 2020-24 CE"
#> [1] "Years 2020-24 CE"

# Other examples
util_frmyrrng(1998:2001)  # Returns "1998-2001"
#> [1] "1998-2001"
util_frmyrrng(c(2020, 2022))  # Returns "2020-2022"
#> [1] "2020-2022"
util_frmyrrng(c(2010, 2011, 2012), prefix = "c. ")  # Returns "c. 2010-12"
#> [1] "c. 2010-12"

# Empty input
util_frmyrrng(numeric(0))  # Returns character(0)
#> character(0)
```
