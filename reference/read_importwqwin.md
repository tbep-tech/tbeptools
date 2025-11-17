# Retrieve water quality data from the Florida Department of Environmental Protection's Watershed Information Network (WIN)

Retrieve water quality data from the Florida Department of Environmental
Protection's Watershed Information Network (WIN)

## Usage

``` r
read_importwqwin(
  start_date,
  end_date,
  org_id,
  verbose = FALSE,
  max_retries = 5
)
```

## Arguments

- start_date:

  character string for the start date in the format "YYYY-MM-DD"

- end_date:

  character string for the end date in the format "YYYY-MM-DD"

- org_id:

  character string for the organization ID

- verbose:

  logical indicating whether to print verbose output

- max_retries:

  integer indicating maximum number of retries for timeout errors
  (default = 5)

## Value

A data frame containing the water quality data

## Details

This function implements
[`util_importwqwin`](https://tbep-tech.github.io/tbeptools/reference/util_importwqwin.md)
iteratively to retrieve water quality results for the specified
organization ID and start date. Data are retrieved using the API at
<https://prodapps.dep.state.fl.us/dear-watershed/swagger-ui/index.html>.

## Examples

``` r
if (FALSE) { # \dontrun{
dat <- read_importwqwin("2025-01-15", "2025-02-15", "21FLMANA", verbose = TRUE)
head(dat)
} # }
```
