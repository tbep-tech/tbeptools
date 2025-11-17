# Assign threshold categories to Fecal Indicator Bacteria (FIB) data

Assign threshold categories to Fecal Indicator Bacteria (FIB) data

## Usage

``` r
anlz_fibmap(fibdata, yrsel = NULL, mosel = NULL, areasel = NULL, assf = FALSE)
```

## Arguments

- fibdata:

  input FIB `data.frame` as returned by
  [`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md)
  or
  [`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md),
  see details

- yrsel:

  optional numeric value to filter output by years in `fibdata`

- mosel:

  optional numeric value to filter output by month in `fibdata`

- areasel:

  optional character string to filter output by stations in the `area`
  column of `fibdata`, see details

- assf:

  logical indicating if the data are further processed as a simple
  features object with additional columns for
  [`show_fibmap`](https://tbep-tech.github.io/tbeptools/reference/show_fibmap.md)

## Value

A `data.frame` similar to the input if `assf = FALSE` with additional
columns describing station categories and optionally filtered by
arguments passed to the function. A `sf` object if `assf = TRUE` with
additional columns for
[`show_fibmap`](https://tbep-tech.github.io/tbeptools/reference/show_fibmap.md).

## Details

This function is used to create FIB categories for mapping using
[`show_fibmap`](https://tbep-tech.github.io/tbeptools/reference/show_fibmap.md).
Categories based on relevant thresholds are assigned to each
observation. The categories are specific to E. coli or Enterococcus and
are assigned based on the station class as freshwater (`class` as 1 or
3F) or marine (`class` as 2 or 3M), respectively. A station is
categorized into one of four ranges defined by the thresholds as noted
in the `cat` column of the output, with corresponding colors appropriate
for each range as noted in the `col` column of the output.

The input `fibdata` object can be one returned by either
[`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md)
or
[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md).

The `areasel` argument can indicate valid entries in the `area` column
of `fibdata` from
[`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md)
or
[`mancofibdata`](https://tbep-tech.github.io/tbeptools/reference/mancofibdata.md),
[`pascofibdata`](https://tbep-tech.github.io/tbeptools/reference/pascofibdata.md),
[`polcofibdata`](https://tbep-tech.github.io/tbeptools/reference/polcofibdata.md),
or
[`hcesdfibdata`](https://tbep-tech.github.io/tbeptools/reference/hcesdfibdata.md)
from
[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md).
For example, use either `"Alafia River"` or `"Hillsborough River"` to
show stations for the corresponding river basins, where rows in
`fibdata` are filtered based on the the selection. All valid options for
`areasel` for `fibdata` include `"Alafia River"`,
`"Hillsborough River"`, `"Cockroach Bay"`, `"East Lake Outfall"`,
`"Hillsborough Bay"`, `"Little Manatee"`, `"Lower Tampa Bay"`,
`"McKay Bay"`, `"Middle Tampa Bay"`, `"Old Tampa Bay"`, `"Palm River"`,
`"Tampa Bypass Canal"`, or `"Valrico Lake"`. Valid options for `areasel`
if the input data are from
[`read_importwqp`](https://tbep-tech.github.io/tbeptools/reference/read_importwqp.md)
are any that are present in the `area` column for the respective input
datasets
([`mancofibdata`](https://tbep-tech.github.io/tbeptools/reference/mancofibdata.md),
[`pascofibdata`](https://tbep-tech.github.io/tbeptools/reference/pascofibdata.md),
[`polcofibdata`](https://tbep-tech.github.io/tbeptools/reference/polcofibdata.md),
or
[`polcofibdata`](https://tbep-tech.github.io/tbeptools/reference/polcofibdata.md)).
One to any of the options can be used.All stations are returned if this
argument is set as `NULL` (default). Not all areas may be present based
on the year/month selection.

## Examples

``` r
# assign categories to all
anlz_fibmap(fibdata)
#> # A tibble: 29,175 × 12
#>    area    station class    yr    mo Latitude Longitude ecoli entero ind   cat  
#>    <chr>     <dbl> <chr> <dbl> <dbl>    <dbl>     <dbl> <dbl>  <dbl> <chr> <fct>
#>  1 Hillsb…       2 3M     2024    12     27.9     -82.5    NA     28 Ente… < 35 
#>  2 Hillsb…       6 3M     2024    12     27.9     -82.5    NA      2 Ente… < 35 
#>  3 Hillsb…       7 3M     2024    12     27.9     -82.5    NA      2 Ente… < 35 
#>  4 Hillsb…       8 3M     2024    12     27.9     -82.4    NA      2 Ente… < 35 
#>  5 Middle…       9 2      2024    12     27.8     -82.4    NA      4 Ente… < 35 
#>  6 Middle…      11 2      2024    12     27.8     -82.5    NA      2 Ente… < 35 
#>  7 Middle…      13 2      2024    12     27.8     -82.5    NA      2 Ente… < 35 
#>  8 Middle…      14 2      2024    12     27.8     -82.5    NA      2 Ente… < 35 
#>  9 Middle…      16 2      2024    12     27.7     -82.5    NA      2 Ente… < 35 
#> 10 Middle…      19 2      2024    12     27.7     -82.6    NA      2 Ente… < 35 
#> # ℹ 29,165 more rows
#> # ℹ 1 more variable: col <chr>

# filter by year, month, and area
anlz_fibmap(fibdata, yrsel = 2020, mosel = 7, areasel = 'Alafia River')
#> # A tibble: 13 × 12
#>    area    station class    yr    mo Latitude Longitude ecoli entero ind   cat  
#>    <chr>     <dbl> <chr> <dbl> <dbl>    <dbl>     <dbl> <dbl>  <dbl> <chr> <fct>
#>  1 Alafia…      74 3M     2020     7     27.9     -82.4    NA    168 Ente… 130 …
#>  2 Alafia…     111 3F     2020     7     27.9     -82.2    50   7000 E. c… < 126
#>  3 Alafia…     114 3F     2020     7     27.9     -82.3   447   1560 E. c… 410 …
#>  4 Alafia…     115 3F     2020     7     27.9     -82.1    80    260 E. c… < 126
#>  5 Alafia…     116 3F     2020     7     27.9     -82.1    30    367 E. c… < 126
#>  6 Alafia…     139 3F     2020     7     27.7     -82.1    47    100 E. c… < 126
#>  7 Alafia…     151 3F     2020     7     27.9     -82.2    90     25 E. c… < 126
#>  8 Alafia…     153 3M     2020     7     27.9     -82.3    NA   4000 Ente… > 999
#>  9 Alafia…     154 3F     2020     7     27.9     -82.1   433   1367 E. c… 410 …
#> 10 Alafia…     155 3F     2020     7     27.9     -82.2   170    233 E. c… 126 …
#> 11 Alafia…     166 3F     2020     7     27.9     -82.2   310    480 E. c… 126 …
#> 12 Alafia…     178 3M     2020     7     27.9     -82.4    NA    650 Ente… 130 …
#> 13 Alafia…     179 3M     2020     7     27.9     -82.3    NA   1010 Ente… > 999
#> # ℹ 1 more variable: col <chr>

# as sf object
anlz_fibmap(fibdata, assf = TRUE)
#> Simple feature collection with 29175 features and 16 fields
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -82.7832 ymin: 27.53248 xmax: -82.05604 ymax: 28.16544
#> Geodetic CRS:  WGS 84
#> # A tibble: 29,175 × 17
#>    area    station class    yr    mo Latitude Longitude ecoli entero ind   cat  
#>    <chr>     <dbl> <chr> <dbl> <dbl>    <dbl>     <dbl> <dbl>  <dbl> <chr> <fct>
#>  1 Hillsb…       2 3M     2024    12     27.9     -82.5    NA     28 Ente… < 35 
#>  2 Hillsb…       6 3M     2024    12     27.9     -82.5    NA      2 Ente… < 35 
#>  3 Hillsb…       7 3M     2024    12     27.9     -82.5    NA      2 Ente… < 35 
#>  4 Hillsb…       8 3M     2024    12     27.9     -82.4    NA      2 Ente… < 35 
#>  5 Middle…       9 2      2024    12     27.8     -82.4    NA      4 Ente… < 35 
#>  6 Middle…      11 2      2024    12     27.8     -82.5    NA      2 Ente… < 35 
#>  7 Middle…      13 2      2024    12     27.8     -82.5    NA      2 Ente… < 35 
#>  8 Middle…      14 2      2024    12     27.8     -82.5    NA      2 Ente… < 35 
#>  9 Middle…      16 2      2024    12     27.7     -82.5    NA      2 Ente… < 35 
#> 10 Middle…      19 2      2024    12     27.7     -82.6    NA      2 Ente… < 35 
#> # ℹ 29,165 more rows
#> # ℹ 6 more variables: col <chr>, geometry <POINT [°]>, grp <fct>, conc <dbl>,
#> #   cls <chr>, lab <chr>
```
