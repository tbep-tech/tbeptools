# Format data and station metadata from the Water Quality Portal

Format data and station metadata from the Water Quality Portal

## Usage

``` r
read_formwqp(res, sta, org, type, trace = F)
```

## Arguments

- res:

  A data frame containing results obtained from the API

- sta:

  A data frame containing station metadata obtained from the API

- org:

  chr string indicating the organization identifier

- type:

  chr string indicating data type to download, one of `"wq"` or `"fib"`

- trace:

  Logical indicating whether to display progress messages, default is
  `FALSE`

## Value

A data frame containing formatted water quality and station metadata

## Details

This function is used by
[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md)
to combine, format, and process data (`res`) and station metadata
(`sta`) obtained from the Water Quality Portal for the selected county
and data type. The resulting data frame includes the date, time, station
identifier, latitude, longitude, variable name, value, unit, and quality
flag. Manatee County FIB data (21FLMANA_WQX) will also include an `area`
column indicating the waterbody name as used by the USF Water Atlas,
with some area aggregations. Other county-level FIB data will have a
similar column.

## See also

[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md)

## Examples

``` r
if (FALSE) { # \dontrun{
url <- list(
  Result = "https://www.waterqualitydata.us/data/Result/search?mimeType=csv&zip=no",
  Station = "https://www.waterqualitydata.us/data/Station/search?mimeType=csv&zip=no"
)

headers <- c(
  "Content-Type" = "application/json",
  "Accept" = "application/zip"
)

body <- list(
  organization = c("21FLMANA_WQX"),
  sampleMedia = c("Water"),
  characteristicType = c("Information", "Nutrient", "Biological, Algae, Phytoplankton,
    Photosynthetic Pigments"),
  providers = c("STORET"),
  siteType = c("Estuary")
)

res <- url[['Result']] %>%
  httr::POST(httr::add_headers(headers), body = jsonlite::toJSON(body)) %>%
  httr::content('text') %>%
  read.csv(text = .)

sta <- url[['Station']] %>%
  httr::POST(httr::add_headers(headers), body = jsonlite::toJSON(body)) %>%
  httr::content('text') %>%
  read.csv(text = .)

# combine and format
read_formwqp(res, sta, '21FLMANA_WQX', type = 'wq')
} # }
```
