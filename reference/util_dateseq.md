# Generate a two-column data frame of dates

Generate a two-column data frame of dates

## Usage

``` r
util_dateseq(start_date, end_date)
```

## Arguments

- start_date:

  character for the starting date in "YYYY-MM-DD" format

- end_date:

  character for the ending date in "YYYY-MM-DD" format

## Value

A data frame with two columns: `start` and `end`, containing dates.

## Details

A sequence of dates is generated from the start to end date that
includes monthly breaks, such that the first and last day of each month
between the start and end dates is returned. This function is used
within
[`read_importwqwin`](https://tbep-tech.github.io/tbeptools/reference/read_importwqwin.md)
to create separate API requests in approximate monthly breaks.

## Examples

``` r
util_dateseq('2023-01-15', '2023-05-04')
#>        start        end
#> 1 2023-01-15 2023-01-31
#> 2 2023-02-01 2023-02-28
#> 3 2023-03-01 2023-03-31
#> 4 2023-04-01 2023-04-30
#> 5 2023-05-01 2023-05-04
```
