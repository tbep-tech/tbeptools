# Get organization name from organization identifier in USEPA Water Quality Portal

Get organization name from organization identifier in USEPA Water
Quality Portal

## Usage

``` r
util_orgin(org, stanm = FALSE)
```

## Arguments

- org:

  chr string indicating the organization identifier, see
  [`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md)
  for valid entries

- stanm:

  logical indicating if a character string for a column name specific to
  the organization is returned

## Value

A character string of the organization name that corresponds to the
organization identifier or a column name for the station identifier
specific to the organization if `stanm = TRUE`

## Examples

``` r
util_orgin('21FLHILL_WQX')
#> [1] "Hillsborough"
util_orgin('21FLPASC_WQX', stanm = TRUE)
#> [1] "pasco_station"
```
