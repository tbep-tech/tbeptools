# Utility function to retrieve data from the Water Quality Portal with retry

Utility function to retrieve data from the Water Quality Portal with
retry

## Usage

``` r
util_importwqp(url, headers, body, max_retries = 5, trace = TRUE)
```

## Arguments

- url:

  chr string for the Water Quality Portal API endpoint to query

- headers:

  named chr vector of HTTP headers to pass to
  [`httr::POST`](https://httr.r-lib.org/reference/POST.html)

- body:

  named list of the JSON request body to pass to
  [`httr::POST`](https://httr.r-lib.org/reference/POST.html)

- max_retries:

  integer indicating maximum number of retries on request failure
  (default = 5)

- trace:

  logical indicating whether to print retry messages, default `TRUE`

## Value

A data frame parsed from the CSV response

## Details

Used internally with
[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md).
Retries with exponential backoff on any request or parsing failure
(e.g., an empty or malformed response from an intermittent API failure),
since such failures are not reliably identifiable by error message
alone.
