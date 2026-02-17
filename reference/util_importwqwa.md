# Retrieve metadata from the Water Atlas API

Retrieve metadata from the Water Atlas API

## Usage

``` r
util_importwqwa(endpoint, pageSize = 10000, waterbodyId = NULL)
```

## Arguments

- endpoint:

  Character indicating which API endpoint to retrieve, see details

- pageSize:

  Numeric indicating the number of records to retrieve

- waterbodyId:

  Optional numeric indicating a specific waterbody ID if requesting
  sampling locations

## Value

A data frame of results for the given endpoint

## Details

Endpoints include `"dataSources"`, `"parameters"`,
`"sampling-locations"`, or `"waterbodies"`.

Data are retrieved in pages if the total number of records exceeds the
page size.

## Examples

``` r
# get available parameters
util_importwqwa('parameters')
#> # A tibble: 928 × 6
#>    parameterID parameter                  units name  precision graphDisplayName
#>          <int> <chr>                      <chr> <chr>     <int> <chr>           
#>  1         413 1112Tetrachloroethane_dis… ug/l  1,1,…         2 1,1,1,2-Tetrach…
#>  2         412 1112Tetrachloroethane_ugl  ug/l  1,1,…         2 1,1,1,2-Tetrach…
#>  3          59 111Trichloroethane_diss_u… ug/l  1,1,…         2 1,1,1-Trichloro…
#>  4          58 111Trichloroethane_ugl     ug/l  1,1,…         2 1,1,1-Trichloro…
#>  5          63 1122Tetrachloroethane_dis… ug/l  1,1,…         2 1,1,2,2-Tetrach…
#>  6          62 1122Tetrachloroethane_ugl  ug/l  1,1,…         2 1,1,2,2-Tetrach…
#>  7          61 112Trichloroethane_diss_u… ug/l  1,1,…         2 1,1,2-Trichloro…
#>  8          60 112Trichloroethane_ugl     ug/l  1,1,…         2 1,1,2-Trichloro…
#>  9         240 11dichlorethylene_diss_ugl ug/l  1,1-…         2 1,1-Dichloroeth…
#> 10         239 11dichlorethylene_ugl      ug/l  1,1-…         2 1,1-Dichloroeth…
#> # ℹ 918 more rows

# get sampling locations for a specific waterbody
waterbodies <- util_importwqwa('waterbodies')
waterbodyid <- waterbodies |> 
  dplyr::filter(grepl('Hillsborough Bay', name)) |>
  dplyr::pull(id)
util_importwqwa('sampling-locations', waterbodyId = waterbodyid)
#> # A tibble: 416 × 8
#>    dataSource       name  stationId latitude longitude waterBodyId waterBodyName
#>    <chr>            <chr> <chr>     <chr>    <chr>           <int> <chr>        
#>  1 USGS_NWIS        MCKA… 02301761  27.9153… -82.4234…       20005 Hillsborough…
#>  2 USGS_NWIS        MCKA… 02301843  27.9330… -82.4303…       20005 Hillsborough…
#>  3 USGS_NWIS        HILL… 02306032  27.8897… -82.4795…       20005 Hillsborough…
#>  4 EPC_ROUTINE_MON… Hill… 1041      27.9220… -82.4241…       20005 Hillsborough…
#>  5 EPC_ROUTINE_MON… Hill… 1150      27.9078… -82.4428…       20005 Hillsborough…
#>  6 EPC_ROUTINE_MON… Hill… 1160      27.9041… -82.4511…       20005 Hillsborough…
#>  7 EPC_ROUTINE_MON… Hill… 1170      27.8904… -82.4628…       20005 Hillsborough…
#>  8 EPC_ROUTINE_MON… Big … 14410     27.7778… -82.4063…       20005 Hillsborough…
#>  9 WIN_21FLHILL     14410 14410     27.7781… -82.4060…       20005 Hillsborough…
#> 10 WIN_21FLHILL     14415 14415     27.7796… -82.4122…       20005 Hillsborough…
#> # ℹ 406 more rows
#> # ℹ 1 more variable: county <chr>
```
