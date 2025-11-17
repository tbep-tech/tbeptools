# Run `read_importrain` for multiple years

Run `read_importrain` for multiple years

## Usage

``` r
read_importrainmany(yrs, quiet = FALSE, sleep = 5)
```

## Arguments

- yrs:

  numeric vector of years to download (do not need to be in order)

- quiet:

  logical passed to
  [`read_importrain`](https://tbep-tech.github.io/tbeptools/reference/read_importrain.md)
  to suppress messages (default)

- sleep:

  numeric number of seconds to pause between years

## Value

A data frame identical to that returned by
[`read_importrain`](https://tbep-tech.github.io/tbeptools/reference/read_importrain.md)
with the years requested

## Details

This function is a simple wrapper for
[`read_importrain`](https://tbep-tech.github.io/tbeptools/reference/read_importrain.md)
to download multiple years of rainfall data from the Southwest Florida
Water Management District's (SWFWMD) ftp site:
ftp://ftp.swfwmd.state.fl.us/pub/radar_rainfall/Daily_Data/. The
function will pause for `sleep` seconds between years to avoid
overloading the server.

## Examples

``` r
if (FALSE) { # \dontrun{
read_importrainmany(c(2021, 2022), quiet = F)
} # }
```
