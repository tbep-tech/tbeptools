# Import data from the Water Atlas API

Import data from the Water Atlas API

## Usage

``` r
read_importwqwa(
  dataSource,
  parameter,
  start_date = NULL,
  end_date = NULL,
  trace = TRUE
)
```

## Arguments

- dataSource:

  Character for the data source to retrieve, e.g., WIN_21FLHILL

- parameter:

  Character for the parameter to retrieve

- start_date:

  Numeric for the start date in ISO format, optional

- end_date:

  Numeric for the end date in ISO format, optional

- trace:

  Logical indicating whether to display progress messages, default
  `TRUE`

## Value

A data frame containing the imported sampling data

## Details

This function retrieves sampling data from the Water Atlas API
(<https://dev.api.wateratlas.org/redoc/index.html#tag/Sampling-Data/operation/StreamSamplingData>)
using the specified data source and parameter. Optional start and end
dates can be provided to filter the data by date range. The function
processes the NDJSON response stream and returns a data frame of
sampling records.

See
[`util_importwqwa`](https://tbep-tech.github.io/tbeptools/reference/util_importwqwa.md)
for retrieving metadata such as available data sources and parameters.

## Examples

``` r
read_importwqwa('WIN_21FLPDEM', 'Chla_ugl', '2023-01-01', '2023-02-01')
#> Requesting: WIN_21FLPDEM, Chla_ugl, 2023-01-01, 2023-02-01
#> Processing NDJSON stream...
#> # A tibble: 28 × 24
#>    dataSource   stationID actualStationID actualLatitude actualLongitude
#>    <chr>        <chr>     <chr>           <chr>          <chr>          
#>  1 WIN_21FLPDEM 08-03     08-03           28.06884265    -82.76802461   
#>  2 WIN_21FLPDEM 09-02     09-02           28.03412170    -82.77984738   
#>  3 WIN_21FLPDEM 18-06     18-06           27.97196562    -82.78145490   
#>  4 WIN_21FLPDEM 10-06     10-06           28.04126253    -82.75304796   
#>  5 WIN_21FLPDEM 10-02     10-02           28.04694745    -82.75892469   
#>  6 WIN_21FLPDEM 15-04     15-04           27.99051106    -82.78377469   
#>  7 WIN_21FLPDEM 53-06     53-06           28.10642699    -82.77355400   
#>  8 WIN_21FLPDEM 27-08     27-08           27.89148857    -82.82486245   
#>  9 WIN_21FLPDEM 17-03     17-03           27.94098330    -82.80113945   
#> 10 WIN_21FLPDEM 27-10     27-10           27.87980000    -82.80951000   
#> # ℹ 18 more rows
#> # ℹ 19 more variables: activityID <chr>, activityStartDate <date>,
#> #   activityStartTime <chr>, activityType <chr>, relativeDepth <chr>,
#> #   activityDepth <dbl>, activityDepthUnit <chr>, characteristic <chr>,
#> #   medium <chr>, sampleFraction <chr>, resultValue <dbl>, resultUnit <chr>,
#> #   mdl <chr>, mdlUnit <chr>, parameter <chr>, wBodyID <int>,
#> #   waterBodyName <chr>, resultComment <chr>, valueQualifier <chr>
```
