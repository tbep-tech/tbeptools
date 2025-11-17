# Utility function to retrieve water quality data from the Florida Department of Environmental Protection's Watershed Information Network (WIN)

Utility function to retrieve water quality data from the Florida
Department of Environmental Protection's Watershed Information Network
(WIN)

## Usage

``` r
util_importwqwin(start_date, end_date, org_id, page_num)
```

## Arguments

- start_date:

  character string for the start date in the format "YYYY-MM-DD"

- end_date:

  character string for the end date in the format "YYYY-MM-DD"

- org_id:

  character string for the organization ID

- page_num:

  integer for the page number to retrieve

## Value

A list containing the results from the API request

## Details

Used internally with
[`read_importwqwin`](https://tbep-tech.github.io/tbeptools/reference/read_importwqwin.md).

## Examples

``` r
if (FALSE) { # \dontrun{
onepg <- util_importwqwin("2025-01-15", "2025-02-15", "21FLMANA", 1)
head(onepg)
} # }
```
