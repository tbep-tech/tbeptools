# Import data from the Water Quality Portal

Import data from the Water Quality Portal

## Usage

``` r
read_importwqp(org, type, trace = F)
```

## Arguments

- org:

  chr string indicating the organization identifier, see details

- type:

  chr string indicating data type to download, one of `"wq"` or `"fib"`

- trace:

  logical indicating whether to display progress messages, default
  `FALSE`

## Value

A data frame containing the imported data for the selected county

## Details

This function retrieves data from the Water Quality Portal API
(<https://www.waterqualitydata.us/>) for selected counties in or around
the Tampa Bay watershed. The type of data returned are defined by the
`type` argument as either `"wq"` or `"fib"` for water quality of Fecal
Indicator Bacteria data, respectively.

The `org` argument retrieves data for the specific organization. Valid
entries for `org` include `"21FLCOSP_WQX"` (City of St. Petersburg),
`"21FLDOH_WQX"` (Florida Department of Health), `"21FLHILL_WQX"`
(Hillsborough County), `"21FLMANA_WQX"` (Manatee County),
`"21FLPASC_WQX"` (Pasco County), `"21FLPDEM_WQX"` (Pinellas County),
`"21FLPOLK_WQX"` (Polk County), `"21FLTPA_WQX"` (Florida Department of
Environmental Protection, Southwest District), or `"21FLHESD_WQX"`
(Hillsborough County Environmental Services Division). The naming
convention follows the Organization ID in the Water Quality Portal.

The function fetches results and station metadata, combines and formats
them using the `read_formwqp` function, and returns the processed data
as a data frame. Parameters are specific to the `type` argument.

## See also

[`read_formwqp`](https://tbep-tech.github.io/tbeptools/reference/read_formwqp.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# get Manatee County water quality data
mancodata <- read_importwqp(org = '21FLMANA_WQX', type = 'wq', trace = T)

# get Pinellas County FIB data
pincodata <- read_importwqp(org = '21FLPDEM_WQX', type = 'fib', trace = T)
} # }
```
