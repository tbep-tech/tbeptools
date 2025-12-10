# Import monthly sea levels by station from NOAA Tides and Currents

Under [NOAA Tides and Currents](https://tidesandcurrents.noaa.gov/),
there is the NOAA Center for Operational Oceanographic Products and
Services (CO-OPS). This function uses the [CO-OPS Data Retrieval
API](https://api.tidesandcurrents.noaa.gov/api/prod/) to extract see
level data by station.

## Usage

``` r
read_importsealevels(
  path_csv,
  download_latest = TRUE,
  df_stations = sealevelstations[, c("station_id", "station_name")],
  api_url = "https://api.tidesandcurrents.noaa.gov/api/prod/datagetter",
  beg_int = 19010101,
  end_int = as.integer(format(lubridate::today(), "%Y%m%d")),
  product = "monthly_mean",
  datum = "stnd",
  time_zone = "lst",
  units = "metric"
)
```

## Arguments

- path_csv:

  chr string path of CSV file to store tabular output. (Overwrites
  existing file.)

- download_latest:

  logical to download latest. (Overwrites existing file.)

- df_stations:

  data frame of stations with column `station_id` (integer). Defaults to
  [sealevelstations](https://tbep-tech.github.io/tbeptools/reference/sealevelstations.md),
  subset to columns `station_id` and `station_name`.

- api_url:

  chr string URL for NOAA Center for Operational Oceanographic Products
  and Services (CO-OPS) API. Defaults to the CO-OPS API for data
  retrieval: https://api.tidesandcurrents.noaa.gov/api/prod/datagetter.

- beg_int:

  int integer of beginning date in YYYYMMDD format. Defaults to
  `19010101`.

- end_int:

  int integer of ending date in YYYYMMDD format. Defaults to
  [`lubridate::today()`](https://lubridate.tidyverse.org/reference/now.html).

- product:

  chr string of product type. For options, see [Data Products \| CO-OPS
  API](https://api.tidesandcurrents.noaa.gov/api/prod/#products).
  Defaults to `"monthly_mean"`: "verified monthly mean water level data
  for the station."

- datum:

  chr string of datum. Defaults to `"stnd"`: "station datum - original
  reference that all data is collected to, uniquely defined for each
  station." For options, see [Datum \| CO-OPS
  API](https://api.tidesandcurrents.noaa.gov/api/prod/#datum)

- time_zone:

  Time zone. Defaults to `"lst"`: "local standard time." However, this
  does not get used with the `monthly_mean` product. For options, see
  [Time Zone \| CO-OPS
  API](https://api.tidesandcurrents.noaa.gov/api/prod/#timezone).

- units:

  chr string of units. Defaults to `"metric"` (i.e., meters). For other
  options (i.e., `"english"`), see [Units \| CO-OPS
  API](https://api.tidesandcurrents.noaa.gov/api/prod/#units).

## Value

Given the default arguments in (and especially
`product = "monthly_mean"`), this function returns a data frame from
reading `path_csv` (updated if `download_latest = TRUE` or newly written
if `path_csv` does not exist) having the following fields:

- `station_id`: integer column from input argument `df_stations`

- `station_name`: character column from input argument `df_stations`

- `date`: first of the month given by `year` and `month` from API output

- `year`: year of the data

- `month`: month of the data

- `mhhw`: Mean Higher-High Water

- `mhw`: Mean High Water

- `msl`: Mean Sea Level

- `mtl`: Mean Tide Level

- `mlw`: Mean Low Water

- `mllw`: Mean Lower-Low Water

- `dtl`: Mean Diurnal Tide Level

- `gt`: Great Diurnal Range

- `mn`: Mean Range of Tide

- `dhq`: Mean Diurnal High Water Inequality

- `dlq`: Mean Diurnal Low Water Inequality

- `hwi`: Greenwich High Water Interval (in Hours)

- `lwi`: Greenwich Low Water Interval (in Hours)

- `highest`: Highest Tide

- `lowest`: Lowest Tide

- `inferred`: A flag that when set to 1 indicates that the water level
  value has been inferred

For more details on these output data columns, see [About Tidal Datums
\| NOAA Tides &
Currents](https://tidesandcurrents.noaa.gov/datum_options.html).

## Examples

``` r
read_importsealevels(tempfile("sealevels", fileext=".csv"))
#>      station_id     station_name       date year month highest  mhhw   mhw
#> 1       8726724 Clearwater Beach 1973-05-01 1973     5   1.554 1.381 1.262
#> 2       8726724 Clearwater Beach 1973-06-01 1973     6   1.606 1.378 1.250
#> 3       8726724 Clearwater Beach 1973-07-01 1973     7   1.579 1.384 1.253
#> 4       8726724 Clearwater Beach 1973-08-01 1973     8   1.573 1.396 1.280
#> 5       8726724 Clearwater Beach 1973-09-01 1973     9   1.539 1.426 1.326
#> 6       8726724 Clearwater Beach 1973-10-01 1973    10   1.664 1.378 1.289
#> 7       8726724 Clearwater Beach 1973-11-01 1973    11   1.640 1.399 1.292
#> 8       8726724 Clearwater Beach 1973-12-01 1973    12   1.530 1.277 1.161
#> 9       8726724 Clearwater Beach 1974-01-01 1974     1   1.533 1.295 1.158
#> 10      8726724 Clearwater Beach 1974-02-01 1974     2   1.612 1.271 1.149
#> 11      8726724 Clearwater Beach 1974-03-01 1974     3      NA 1.289 1.173
#> 12      8726724 Clearwater Beach 1974-04-01 1974     4   1.512 1.283 1.170
#> 13      8726724 Clearwater Beach 1974-05-01 1974     5   1.686 1.350 1.244
#> 14      8726724 Clearwater Beach 1974-06-01 1974     6   1.820 1.454 1.323
#> 15      8726724 Clearwater Beach 1974-07-01 1974     7   1.533 1.372 1.244
#> 16      8726724 Clearwater Beach 1974-08-01 1974     8   1.591 1.375 1.259
#> 17      8726724 Clearwater Beach 1974-09-01 1974     9   1.545 1.436 1.344
#> 18      8726724 Clearwater Beach 1974-10-01 1974    10   1.643 1.359 1.280
#> 19      8726724 Clearwater Beach 1974-11-01 1974    11   1.640 1.292 1.177
#> 20      8726724 Clearwater Beach 1974-12-01 1974    12   1.551 1.268 1.137
#> 21      8726724 Clearwater Beach 1975-01-01 1975     1   1.594 1.247 1.134
#> 22      8726724 Clearwater Beach 1975-02-01 1975     2   1.695 1.311 1.198
#> 23      8726724 Clearwater Beach 1975-03-01 1975     3   1.478 1.259 1.167
#> 24      8726724 Clearwater Beach 1975-04-01 1975     4   1.588 1.274 1.177
#> 25      8726724 Clearwater Beach 1975-05-01 1975     5   1.570 1.344 1.241
#> 26      8726724 Clearwater Beach 1975-06-01 1975     6   1.509 1.353 1.247
#> 27      8726724 Clearwater Beach 1975-07-01 1975     7   1.658 1.445 1.323
#> 28      8726724 Clearwater Beach 1975-08-01 1975     8      NA 1.423 1.314
#> 29      8726724 Clearwater Beach 1975-09-01 1975     9   1.753 1.475 1.387
#> 30      8726724 Clearwater Beach 1975-10-01 1975    10   1.625 1.350 1.280
#> 31      8726724 Clearwater Beach 1975-11-01 1975    11   1.567 1.332 1.237
#> 32      8726724 Clearwater Beach 1975-12-01 1975    12   1.698 1.344 1.225
#> 33      8726724 Clearwater Beach 1976-01-01 1976     1   1.518 1.158 1.024
#> 34      8726724 Clearwater Beach 1976-02-01 1976     2      NA 1.152 1.030
#> 35      8726724 Clearwater Beach 1976-03-01 1976     3      NA 1.213 1.122
#> 36      8726724 Clearwater Beach 1976-04-01 1976     4   1.554 1.289 1.186
#> 37      8726724 Clearwater Beach 1976-05-01 1976     5   1.734 1.390 1.265
#> 38      8726724 Clearwater Beach 1976-06-01 1976     6   1.539 1.375 1.256
#> 39      8726724 Clearwater Beach 1976-07-01 1976     7   1.509 1.335 1.225
#> 40      8726724 Clearwater Beach 1976-08-01 1976     8   1.533 1.344 1.231
#> 41      8726724 Clearwater Beach 1976-09-01 1976     9      NA 1.393 1.301
#> 42      8726724 Clearwater Beach 1976-10-01 1976    10   1.689 1.283 1.207
#> 43      8726724 Clearwater Beach 1976-11-01 1976    11      NA 1.216 1.119
#> 44      8726724 Clearwater Beach 1976-12-01 1976    12   1.957 1.271 1.125
#> 45      8726724 Clearwater Beach 1977-01-01 1977     1   1.527 1.192 1.064
#> 46      8726724 Clearwater Beach 1977-02-01 1977     2   1.362 1.122 1.021
#> 47      8726724 Clearwater Beach 1977-03-01 1977     3   1.420 1.216 1.116
#> 48      8726724 Clearwater Beach 1977-04-01 1977     4   1.442 1.204 1.128
#> 49      8726724 Clearwater Beach 1977-05-01 1977     5   1.500 1.347 1.244
#> 50      8726724 Clearwater Beach 1977-06-01 1977     6   1.686 1.381 1.271
#> 51      8726724 Clearwater Beach 1977-07-01 1977     7   1.551 1.359 1.234
#> 52      8726724 Clearwater Beach 1977-08-01 1977     8   1.597 1.387 1.289
#> 53      8726724 Clearwater Beach 1977-09-01 1977     9   1.600 1.442 1.362
#> 54      8726724 Clearwater Beach 1977-10-01 1977    10   1.490 1.308 1.234
#> 55      8726724 Clearwater Beach 1977-11-01 1977    11   1.512 1.335 1.241
#> 56      8726724 Clearwater Beach 1977-12-01 1977    12      NA 1.265 1.100
#> 57      8726724 Clearwater Beach 1978-01-01 1978     1   2.015 1.195 1.067
#> 58      8726724 Clearwater Beach 1978-02-01 1978     2   1.576 1.231 1.125
#> 59      8726724 Clearwater Beach 1978-03-01 1978     3   1.478 1.207 1.125
#> 60      8726724 Clearwater Beach 1978-04-01 1978     4   1.545 1.271 1.192
#> 61      8726724 Clearwater Beach 1978-05-01 1978     5   1.804 1.323 1.225
#> 62      8726724 Clearwater Beach 1978-06-01 1978     6   1.658 1.353 1.234
#> 63      8726724 Clearwater Beach 1978-07-01 1978     7   1.548 1.417 1.301
#> 64      8726724 Clearwater Beach 1978-08-01 1978     8      NA 1.384 1.286
#> 65      8726724 Clearwater Beach 1978-09-01 1978     9      NA 1.420 1.341
#> 66      8726724 Clearwater Beach 1978-10-01 1978    10   1.643 1.420 1.350
#> 67      8726724 Clearwater Beach 1978-11-01 1978    11   1.698 1.393 1.308
#> 68      8726724 Clearwater Beach 1978-12-01 1978    12   1.570 1.280 1.146
#> 69      8726724 Clearwater Beach 1979-01-01 1979     1   1.704 1.286 1.161
#> 70      8726724 Clearwater Beach 1979-02-01 1979     2   1.643 1.210 1.106
#> 71      8726724 Clearwater Beach 1979-03-01 1979     3   1.600 1.256 1.170
#> 72      8726724 Clearwater Beach 1979-04-01 1979     4   1.567 1.314 1.231
#> 73      8726724 Clearwater Beach 1979-05-01 1979     5   1.503 1.311 1.216
#> 74      8726724 Clearwater Beach 1979-06-01 1979     6   1.570 1.326 1.219
#> 75      8726724 Clearwater Beach 1979-07-01 1979     7   1.695 1.390 1.283
#> 76      8726724 Clearwater Beach 1979-08-01 1979     8   1.655 1.439 1.332
#> 77      8726724 Clearwater Beach 1979-09-01 1979     9   1.841 1.460 1.384
#> 78      8726724 Clearwater Beach 1979-10-01 1979    10   1.542 1.347 1.277
#> 79      8726724 Clearwater Beach 1979-11-01 1979    11   1.521 1.280 1.204
#> 80      8726724 Clearwater Beach 1979-12-01 1979    12   1.570 1.259 1.146
#> 81      8726724 Clearwater Beach 1980-01-01 1980     1      NA 1.301 1.192
#> 82      8726724 Clearwater Beach 1980-02-01 1980     2   1.682 1.244 1.137
#> 83      8726724 Clearwater Beach 1980-03-01 1980     3   1.661 1.225 1.164
#> 84      8726724 Clearwater Beach 1980-04-01 1980     4   1.600 1.262 1.192
#> 85      8726724 Clearwater Beach 1980-05-01 1980     5   1.509 1.332 1.231
#> 86      8726724 Clearwater Beach 1980-06-01 1980     6   1.536 1.362 1.241
#> 87      8726724 Clearwater Beach 1980-07-01 1980     7   1.576 1.362 1.250
#> 88      8726724 Clearwater Beach 1980-08-01 1980     8   1.628 1.350 1.247
#> 89      8726724 Clearwater Beach 1980-09-01 1980     9   1.600 1.375 1.292
#> 90      8726724 Clearwater Beach 1980-10-01 1980    10   1.518 1.277 1.210
#> 91      8726724 Clearwater Beach 1980-11-01 1980    11   1.551 1.314 1.225
#> 92      8726724 Clearwater Beach 1980-12-01 1980    12   1.469 1.241 1.122
#> 93      8726724 Clearwater Beach 1981-01-01 1981     1   1.612 1.180 1.055
#> 94      8726724 Clearwater Beach 1981-02-01 1981     2   1.405 1.186 1.097
#> 95      8726724 Clearwater Beach 1981-03-01 1981     3   1.850 1.234 1.128
#> 96      8726724 Clearwater Beach 1981-04-01 1981     4   1.390 1.234 1.167
#> 97      8726724 Clearwater Beach 1981-05-01 1981     5   1.719 1.314 1.234
#> 98      8726724 Clearwater Beach 1981-06-01 1981     6   1.524 1.344 1.231
#> 99      8726724 Clearwater Beach 1981-07-01 1981     7   1.664 1.408 1.274
#> 100     8726724 Clearwater Beach 1981-08-01 1981     8   1.667 1.381 1.259
#> 101     8726724 Clearwater Beach 1981-09-01 1981     9   1.561 1.366 1.271
#> 102     8726724 Clearwater Beach 1981-10-01 1981    10   1.612 1.292 1.216
#> 103     8726724 Clearwater Beach 1981-11-01 1981    11   1.868 1.356 1.256
#> 104     8726724 Clearwater Beach 1981-12-01 1981    12   1.582 1.250 1.113
#> 105     8726724 Clearwater Beach 1982-01-01 1982     1   1.490 1.195 1.073
#> 106     8726724 Clearwater Beach 1982-02-01 1982     2   1.436 1.210 1.119
#> 107     8726724 Clearwater Beach 1982-03-01 1982     3   1.658 1.253 1.158
#> 108     8726724 Clearwater Beach 1982-04-01 1982     4   1.576 1.250 1.149
#> 109     8726724 Clearwater Beach 1982-05-01 1982     5   1.521 1.280 1.186
#> 110     8726724 Clearwater Beach 1982-06-01 1982     6   2.106 1.369 1.250
#> 111     8726724 Clearwater Beach 1982-07-01 1982     7   1.606 1.332 1.204
#> 112     8726724 Clearwater Beach 1982-08-01 1982     8   1.817 1.366 1.237
#> 113     8726724 Clearwater Beach 1982-09-01 1982     9   1.567 1.396 1.292
#> 114     8726724 Clearwater Beach 1982-10-01 1982    10   1.554 1.369 1.305
#> 115     8726724 Clearwater Beach 1982-11-01 1982    11   1.689 1.369 1.277
#> 116     8726724 Clearwater Beach 1982-12-01 1982    12   1.728 1.369 1.253
#> 117     8726724 Clearwater Beach 1983-01-01 1983     1   1.618 1.317 1.192
#> 118     8726724 Clearwater Beach 1983-02-01 1983     2   1.689 1.301 1.189
#> 119     8726724 Clearwater Beach 1983-03-01 1983     3   1.820 1.359 1.265
#> 120     8726724 Clearwater Beach 1983-04-01 1983     4   1.716 1.305 1.210
#> 121     8726724 Clearwater Beach 1983-05-01 1983     5   1.585 1.356 1.253
#> 122     8726724 Clearwater Beach 1983-06-01 1983     6   1.524 1.366 1.237
#> 123     8726724 Clearwater Beach 1983-07-01 1983     7   1.579 1.369 1.241
#> 124     8726724 Clearwater Beach 1983-08-01 1983     8   1.618 1.378 1.256
#> 125     8726724 Clearwater Beach 1983-09-01 1983     9   1.710 1.390 1.283
#> 126     8726724 Clearwater Beach 1983-10-01 1983    10   1.664 1.426 1.344
#> 127     8726724 Clearwater Beach 1983-11-01 1983    11   1.920 1.426 1.329
#> 128     8726724 Clearwater Beach 1983-12-01 1983    12   1.600 1.259 1.128
#> 129     8726724 Clearwater Beach 1984-01-01 1984     1   1.646 1.277 1.140
#> 130     8726724 Clearwater Beach 1984-02-01 1984     2   1.530 1.234 1.143
#> 131     8726724 Clearwater Beach 1984-03-01 1984     3   1.670 1.250 1.177
#> 132     8726724 Clearwater Beach 1984-04-01 1984     4   1.512 1.298 1.222
#> 133     8726724 Clearwater Beach 1984-05-01 1984     5   1.628 1.317 1.216
#> 134     8726724 Clearwater Beach 1984-06-01 1984     6   1.631 1.426 1.283
#> 135     8726724 Clearwater Beach 1984-07-01 1984     7   1.673 1.448 1.317
#> 136     8726724 Clearwater Beach 1984-08-01 1984     8   1.582 1.399 1.286
#> 137     8726724 Clearwater Beach 1984-09-01 1984     9   1.637 1.423 1.329
#> 138     8726724 Clearwater Beach 1984-10-01 1984    10   1.737 1.436 1.353
#> 139     8726724 Clearwater Beach 1984-11-01 1984    11   1.670 1.347 1.259
#> 140     8726724 Clearwater Beach 1984-12-01 1984    12   1.536 1.332 1.216
#> 141     8726724 Clearwater Beach 1985-01-01 1985     1   1.582 1.314 1.173
#> 142     8726724 Clearwater Beach 1985-02-01 1985     2   1.588 1.244 1.143
#> 143     8726724 Clearwater Beach 1985-03-01 1985     3   1.463 1.244 1.167
#> 144     8726724 Clearwater Beach 1985-04-01 1985     4   1.469 1.271 1.186
#> 145     8726724 Clearwater Beach 1985-05-01 1985     5   1.515 1.341 1.247
#> 146     8726724 Clearwater Beach 1985-06-01 1985     6   1.606 1.378 1.244
#> 147     8726724 Clearwater Beach 1985-07-01 1985     7   1.661 1.390 1.253
#> 148     8726724 Clearwater Beach 1985-08-01 1985     8   2.329 1.487 1.366
#> 149     8726724 Clearwater Beach 1985-09-01 1985     9   1.817 1.411 1.311
#> 150     8726724 Clearwater Beach 1985-10-01 1985    10   2.027 1.518 1.445
#> 151     8726724 Clearwater Beach 1985-11-01 1985    11   1.737 1.411 1.295
#> 152     8726724 Clearwater Beach 1985-12-01 1985    12   1.884 1.298 1.155
#> 153     8726724 Clearwater Beach 1986-01-01 1986     1   1.643 1.228 1.116
#> 154     8726724 Clearwater Beach 1986-02-01 1986     2   1.649 1.280 1.201
#> 155     8726724 Clearwater Beach 1986-03-01 1986     3   1.585 1.228 1.119
#> 156     8726724 Clearwater Beach 1986-04-01 1986     4   1.622 1.347 1.271
#> 157     8726724 Clearwater Beach 1986-05-01 1986     5   1.628 1.442 1.332
#> 158     8726724 Clearwater Beach 1986-06-01 1986     6   1.667 1.436 1.311
#> 159     8726724 Clearwater Beach 1986-07-01 1986     7   1.649 1.387 1.256
#> 160     8726724 Clearwater Beach 1986-08-01 1986     8   1.631 1.393 1.271
#> 161     8726724 Clearwater Beach 1986-09-01 1986     9   1.609 1.475 1.378
#> 162     8726724 Clearwater Beach 1986-10-01 1986    10   1.524 1.430 1.338
#> 163     8726724 Clearwater Beach 1986-11-01 1986    11   1.686 1.417 1.317
#> 164     8726724 Clearwater Beach 1986-12-01 1986    12   2.170 1.369 1.216
#> 165     8726724 Clearwater Beach 1987-01-01 1987     1      NA 1.387 1.219
#> 166     8726724 Clearwater Beach 1987-02-01 1987     2      NA 1.338 1.222
#> 167     8726724 Clearwater Beach 1987-03-01 1987     3   1.725 1.405 1.311
#> 168     8726724 Clearwater Beach 1987-04-01 1987     4   1.582 1.253 1.161
#> 169     8726724 Clearwater Beach 1987-05-01 1987     5   1.567 1.356 1.228
#> 170     8726724 Clearwater Beach 1987-06-01 1987     6   1.704 1.414 1.271
#> 171     8726724 Clearwater Beach 1987-07-01 1987     7   1.725 1.414 1.283
#> 172     8726724 Clearwater Beach 1987-08-01 1987     8   1.603 1.384 1.271
#> 173     8726724 Clearwater Beach 1987-09-01 1987     9   1.591 1.399 1.311
#> 174     8726724 Clearwater Beach 1987-10-01 1987    10   1.545 1.250 1.180
#> 175     8726724 Clearwater Beach 1987-11-01 1987    11   1.597 1.347 1.262
#> 176     8726724 Clearwater Beach 1987-12-01 1987    12   1.588 1.320 1.195
#> 177     8726724 Clearwater Beach 1988-03-01 1988     3   1.408 1.234 1.137
#> 178     8726724 Clearwater Beach 1988-06-01 1988     6   1.576 1.393 1.247
#> 179     8726724 Clearwater Beach 1988-08-01 1988     8   1.554 1.335 1.222
#> 180     8726724 Clearwater Beach 1988-09-01 1988     9   1.719 1.384 1.280
#> 181     8726724 Clearwater Beach 1988-10-01 1988    10   1.548 1.329 1.234
#> 182     8726724 Clearwater Beach 1988-11-01 1988    11   1.585 1.289 1.170
#> 183     8726724 Clearwater Beach 1989-05-01 1989     5   1.594 1.292 1.170
#> 184     8726724 Clearwater Beach 1989-06-01 1989     6   1.853 1.417 1.265
#> 185     8726724 Clearwater Beach 1989-08-01 1989     8   1.558 1.430 1.326
#> 186     8726724 Clearwater Beach 1989-09-01 1989     9   1.603 1.411 1.329
#> 187     8726724 Clearwater Beach 1989-10-01 1989    10   1.588 1.320 1.231
#> 188     8726724 Clearwater Beach 1989-11-01 1989    11   1.728 1.356 1.231
#> 189     8726724 Clearwater Beach 1989-12-01 1989    12   1.780 1.241 1.103
#> 190     8726724 Clearwater Beach 1990-01-01 1990     1   1.539 1.207 1.079
#> 191     8726724 Clearwater Beach 1990-02-01 1990     2   1.509 1.241 1.122
#> 192     8726724 Clearwater Beach 1990-03-01 1990     3   1.652 1.381 1.286
#> 193     8726724 Clearwater Beach 1990-04-01 1990     4   1.698 1.344 1.234
#> 194     8726724 Clearwater Beach 1990-05-01 1990     5   1.725 1.420 1.295
#> 195     8726724 Clearwater Beach 1990-06-01 1990     6   1.673 1.390 1.259
#> 196     8726724 Clearwater Beach 1990-07-01 1990     7   1.631 1.396 1.271
#> 197     8726724 Clearwater Beach 1990-08-01 1990     8   1.689 1.460 1.353
#> 198     8726724 Clearwater Beach 1990-09-01 1990     9   1.539 1.417 1.323
#> 199     8726724 Clearwater Beach 1990-10-01 1990    10   1.573 1.402 1.329
#> 200     8726724 Clearwater Beach 1990-11-01 1990    11   1.753 1.420 1.317
#> 201     8726724 Clearwater Beach 1990-12-01 1990    12   1.817 1.359 1.219
#> 202     8726724 Clearwater Beach 1991-01-01 1991     1   2.009 1.408 1.274
#> 203     8726724 Clearwater Beach 1991-02-01 1991     2   1.649 1.265 1.173
#> 204     8726724 Clearwater Beach 1991-03-01 1991     3   1.756 1.366 1.265
#> 205     8726724 Clearwater Beach 1991-04-01 1991     4   1.682 1.417 1.326
#> 206     8726724 Clearwater Beach 1991-05-01 1991     5   1.747 1.515 1.384
#> 207     8726724 Clearwater Beach 1991-06-01 1991     6   1.750 1.487 1.344
#> 208     8726724 Clearwater Beach 1991-07-01 1991     7   1.725 1.509 1.381
#> 209     8726724 Clearwater Beach 1991-08-01 1991     8   1.725 1.530 1.411
#> 210     8726724 Clearwater Beach 1991-09-01 1991     9   1.719 1.518 1.420
#> 211     8726724 Clearwater Beach 1991-10-01 1991    10   1.618 1.460 1.359
#> 212     8726724 Clearwater Beach 1991-11-01 1991    11   1.655 1.390 1.286
#> 213     8726724 Clearwater Beach 1991-12-01 1991    12   1.618 1.289 1.164
#> 214     8726724 Clearwater Beach 1992-01-01 1992     1   1.682 1.338 1.216
#> 215     8726724 Clearwater Beach 1992-02-01 1992     2   1.725 1.378 1.253
#> 216     8726724 Clearwater Beach 1992-03-01 1992     3   1.524 1.253 1.183
#> 217     8726724 Clearwater Beach 1992-04-01 1992     4   1.750 1.387 1.283
#> 218     8726724 Clearwater Beach 1992-05-01 1992     5   1.567 1.405 1.283
#> 219     8726724 Clearwater Beach 1992-06-01 1992     6      NA 1.558 1.423
#> 220     8726724 Clearwater Beach 1992-07-01 1992     7      NA 1.487 1.369
#> 221     8726724 Clearwater Beach 1992-08-01 1992     8   1.844 1.481 1.362
#> 222     8726724 Clearwater Beach 1992-09-01 1992     9   1.603 1.481 1.396
#> 223     8726724 Clearwater Beach 1992-10-01 1992    10   1.984 1.521 1.411
#> 224     8726724 Clearwater Beach 1992-11-01 1992    11   1.750 1.402 1.298
#> 225     8726724 Clearwater Beach 1992-12-01 1992    12   1.594 1.353 1.228
#> 226     8726724 Clearwater Beach 1993-01-01 1993     1   1.625 1.399 1.271
#> 227     8726724 Clearwater Beach 1993-02-01 1993     2   1.823 1.396 1.277
#> 228     8726724 Clearwater Beach 1993-03-01 1993     3   2.588 1.253 1.177
#> 229     8726724 Clearwater Beach 1996-01-01 1996     1   1.616 1.266 1.139
#> 230     8726724 Clearwater Beach 1996-02-01 1996     2   1.499 1.204 1.104
#> 231     8726724 Clearwater Beach 1996-03-01 1996     3   1.587 1.193 1.104
#> 232     8726724 Clearwater Beach 1996-04-01 1996     4   1.444 1.266 1.179
#> 233     8726724 Clearwater Beach 1996-05-01 1996     5   1.447 1.294 1.192
#> 234     8726724 Clearwater Beach 1996-06-01 1996     6   1.543 1.325 1.195
#> 235     8726724 Clearwater Beach 1996-07-01 1996     7   1.665 1.378 1.248
#> 236     8726724 Clearwater Beach 1996-08-01 1996     8   1.560 1.405 1.304
#> 237     8726724 Clearwater Beach 1996-09-01 1996     9   1.615 1.419 1.334
#> 238     8726724 Clearwater Beach 1996-10-01 1996    10   2.319 1.449 1.358
#> 239     8726724 Clearwater Beach 1996-11-01 1996    11   1.656 1.366 1.277
#> 240     8726724 Clearwater Beach 1996-12-01 1996    12   1.540 1.279 1.171
#> 241     8726724 Clearwater Beach 1997-01-01 1997     1   1.757 1.266 1.158
#> 242     8726724 Clearwater Beach 1997-02-01 1997     2   1.559 1.252 1.152
#> 243     8726724 Clearwater Beach 1997-03-01 1997     3   1.490 1.295 1.215
#> 244     8726724 Clearwater Beach 1997-04-01 1997     4      NA 1.322 1.243
#> 245     8726724 Clearwater Beach 1997-05-01 1997     5      NA 1.332 1.248
#> 246     8726724 Clearwater Beach 1997-06-01 1997     6   1.568 1.393 1.277
#> 247     8726724 Clearwater Beach 1997-07-01 1997     7   1.639 1.395 1.280
#> 248     8726724 Clearwater Beach 1997-08-01 1997     8   1.602 1.401 1.295
#> 249     8726724 Clearwater Beach 1997-09-01 1997     9   1.628 1.426 1.348
#> 250     8726724 Clearwater Beach 1997-10-01 1997    10   1.693 1.376 1.312
#> 251     8726724 Clearwater Beach 1997-11-01 1997    11   1.749 1.319 1.219
#> 252     8726724 Clearwater Beach 1997-12-01 1997    12   1.605 1.258 1.140
#> 253     8726724 Clearwater Beach 1998-01-01 1998     1   1.500 1.254 1.161
#> 254     8726724 Clearwater Beach 1998-02-01 1998     2   1.754 1.369 1.263
#> 255     8726724 Clearwater Beach 1998-03-01 1998     3   1.625 1.286 1.219
#> 256     8726724 Clearwater Beach 1998-04-01 1998     4   1.511 1.302 1.223
#> 257     8726724 Clearwater Beach 1998-05-01 1998     5   1.579 1.365 1.287
#> 258     8726724 Clearwater Beach 1998-06-01 1998     6   1.522 1.359 1.256
#> 259     8726724 Clearwater Beach 1998-07-01 1998     7   1.535 1.346 1.238
#> 260     8726724 Clearwater Beach 1998-08-01 1998     8   1.527 1.381 1.275
#> 261     8726724 Clearwater Beach 1998-09-01 1998     9   1.861 1.526 1.438
#> 262     8726724 Clearwater Beach 1998-10-01 1998    10   1.571 1.385 1.321
#> 263     8726724 Clearwater Beach 1998-11-01 1998    11   1.664 1.318 1.249
#> 264     8726724 Clearwater Beach 1998-12-01 1998    12   1.559 1.314 1.205
#> 265     8726724 Clearwater Beach 1999-01-01 1999     1   2.374 1.354 1.214
#> 266     8726724 Clearwater Beach 1999-02-01 1999     2   1.671 1.365 1.258
#> 267     8726724 Clearwater Beach 1999-03-01 1999     3   1.539 1.314 1.240
#> 268     8726724 Clearwater Beach 1999-04-01 1999     4   1.747 1.343 1.272
#> 269     8726724 Clearwater Beach 1999-05-01 1999     5   1.586 1.400 1.292
#> 270     8726724 Clearwater Beach 1999-06-01 1999     6   1.579 1.381 1.265
#> 271     8726724 Clearwater Beach 1999-07-01 1999     7      NA 1.419 1.302
#> 272     8726724 Clearwater Beach 1999-08-01 1999     8   1.632 1.464 1.356
#> 273     8726724 Clearwater Beach 1999-09-01 1999     9   1.707 1.533 1.444
#> 274     8726724 Clearwater Beach 1999-10-01 1999    10   1.510 1.413 1.345
#> 275     8726724 Clearwater Beach 1999-11-01 1999    11   1.626 1.348 1.260
#> 276     8726724 Clearwater Beach 1999-12-01 1999    12   1.535 1.288 1.176
#> 277     8726724 Clearwater Beach 2000-01-01 2000     1   1.571 1.241 1.139
#> 278     8726724 Clearwater Beach 2000-02-01 2000     2   1.461 1.231 1.130
#> 279     8726724 Clearwater Beach 2000-03-01 2000     3   1.552 1.328 1.244
#> 280     8726724 Clearwater Beach 2000-04-01 2000     4      NA 1.360 1.254
#> 281     8726724 Clearwater Beach 2000-05-01 2000     5      NA 1.390 1.292
#> 282     8726724 Clearwater Beach 2000-06-01 2000     6   1.570 1.403 1.273
#> 283     8726724 Clearwater Beach 2000-07-01 2000     7      NA 1.453 1.322
#> 284     8726724 Clearwater Beach 2000-08-01 2000     8      NA 1.416 1.318
#> 285     8726724 Clearwater Beach 2000-09-01 2000     9   2.033 1.465 1.381
#> 286     8726724 Clearwater Beach 2000-10-01 2000    10   1.589 1.386 1.309
#> 287     8726724 Clearwater Beach 2000-11-01 2000    11   1.737 1.392 1.293
#> 288     8726724 Clearwater Beach 2000-12-01 2000    12   1.658 1.262 1.135
#> 289     8726724 Clearwater Beach 2001-01-01 2001     1   1.471 1.144 1.035
#> 290     8726724 Clearwater Beach 2001-02-01 2001     2   1.382 1.181 1.080
#> 291     8726724 Clearwater Beach 2001-03-01 2001     3   1.586 1.281 1.189
#> 292     8726724 Clearwater Beach 2001-05-01 2001     5   1.569 1.339 1.236
#> 293     8726724 Clearwater Beach 2001-06-01 2001     6   1.493 1.311 1.197
#> 294     8726724 Clearwater Beach 2001-07-01 2001     7   1.949 1.409 1.275
#> 295     8726724 Clearwater Beach 2001-08-01 2001     8   1.715 1.411 1.294
#> 296     8726724 Clearwater Beach 2001-09-01 2001     9   1.648 1.431 1.342
#> 297     8726724 Clearwater Beach 2001-10-01 2001    10   1.697 1.383 1.303
#> 298     8726724 Clearwater Beach 2001-11-01 2001    11   1.553 1.382 1.295
#> 299     8726724 Clearwater Beach 2001-12-01 2001    12   1.574 1.355 1.233
#> 300     8726724 Clearwater Beach 2002-01-01 2002     1   1.526 1.241 1.116
#> 301     8726724 Clearwater Beach 2002-02-01 2002     2   1.593 1.245 1.149
#> 302     8726724 Clearwater Beach 2002-03-01 2002     3   1.607 1.254 1.183
#> 303     8726724 Clearwater Beach 2002-04-01 2002     4   1.519 1.325 1.247
#> 304     8726724 Clearwater Beach 2002-05-01 2002     5   1.601 1.388 1.270
#> 305     8726724 Clearwater Beach 2002-06-01 2002     6   1.609 1.429 1.301
#> 306     8726724 Clearwater Beach 2002-07-01 2002     7   1.675 1.399 1.280
#> 307     8726724 Clearwater Beach 2002-08-01 2002     8   1.592 1.457 1.339
#> 308     8726724 Clearwater Beach 2002-09-01 2002     9   1.765 1.531 1.450
#> 309     8726724 Clearwater Beach 2002-10-01 2002    10   1.628 1.501 1.424
#> 310     8726724 Clearwater Beach 2002-11-01 2002    11   1.867 1.351 1.246
#> 311     8726724 Clearwater Beach 2002-12-01 2002    12   1.627 1.269 1.145
#> 312     8726724 Clearwater Beach 2003-01-01 2003     1   1.644 1.237 1.093
#> 313     8726724 Clearwater Beach 2003-02-01 2003     2   1.599 1.244 1.156
#> 314     8726724 Clearwater Beach 2003-03-01 2003     3   1.660 1.351 1.274
#> 315     8726724 Clearwater Beach 2003-04-01 2003     4   1.553 1.379 1.295
#> 316     8726724 Clearwater Beach 2003-05-01 2003     5   1.584 1.396 1.286
#> 317     8726724 Clearwater Beach 2003-06-01 2003     6   1.742 1.436 1.299
#> 318     8726724 Clearwater Beach 2003-07-01 2003     7   1.711 1.477 1.348
#> 319     8726724 Clearwater Beach 2003-08-01 2003     8   1.692 1.474 1.359
#> 320     8726724 Clearwater Beach 2003-09-01 2003     9   1.683 1.524 1.425
#> 321     8726724 Clearwater Beach 2003-10-01 2003    10   1.795 1.487 1.417
#> 322     8726724 Clearwater Beach 2003-11-01 2003    11   1.719 1.447 1.343
#> 323     8726724 Clearwater Beach 2003-12-01 2003    12   1.639 1.302 1.183
#> 324     8726724 Clearwater Beach 2004-01-01 2004     1   1.671 1.301 1.198
#> 325     8726724 Clearwater Beach 2004-02-01 2004     2   1.546 1.281 1.175
#> 326     8726724 Clearwater Beach 2004-03-01 2004     3   1.509 1.320 1.228
#> 327     8726724 Clearwater Beach 2004-04-01 2004     4   1.721 1.358 1.268
#> 328     8726724 Clearwater Beach 2004-05-01 2004     5   1.563 1.400 1.284
#> 329     8726724 Clearwater Beach 2004-06-01 2004     6   1.681 1.461 1.323
#> 330     8726724 Clearwater Beach 2004-07-01 2004     7   1.684 1.456 1.307
#> 331     8726724 Clearwater Beach 2004-08-01 2004     8   1.710 1.461 1.341
#> 332     8726724 Clearwater Beach 2004-09-01 2004     9   2.028 1.481 1.376
#> 333     8726724 Clearwater Beach 2004-10-01 2004    10   1.657 1.480 1.401
#> 334     8726724 Clearwater Beach 2004-11-01 2004    11   1.829 1.453 1.341
#> 335     8726724 Clearwater Beach 2004-12-01 2004    12   1.565 1.265 1.146
#> 336     8726724 Clearwater Beach 2005-01-01 2005     1   1.701 1.324 1.205
#> 337     8726724 Clearwater Beach 2005-02-01 2005     2   1.807 1.399 1.316
#> 338     8726724 Clearwater Beach 2005-03-01 2005     3   1.501 1.260 1.202
#> 339     8726724 Clearwater Beach 2005-04-01 2005     4   1.685 1.397 1.324
#> 340     8726724 Clearwater Beach 2005-05-01 2005     5   1.647 1.437 1.323
#> 341     8726724 Clearwater Beach 2005-06-01 2005     6   1.657 1.470 1.344
#> 342     8726724 Clearwater Beach 2005-07-01 2005     7   2.010 1.502 1.353
#> 343     8726724 Clearwater Beach 2005-08-01 2005     8   1.796 1.491 1.361
#> 344     8726724 Clearwater Beach 2005-09-01 2005     9   2.003 1.511 1.422
#> 345     8726724 Clearwater Beach 2005-10-01 2005    10   1.732 1.437 1.355
#> 346     8726724 Clearwater Beach 2005-11-01 2005    11   1.595 1.381 1.269
#> 347     8726724 Clearwater Beach 2005-12-01 2005    12   1.627 1.316 1.175
#> 348     8726724 Clearwater Beach 2006-01-01 2006     1   1.695 1.308 1.172
#> 349     8726724 Clearwater Beach 2006-02-01 2006     2   1.555 1.274 1.175
#> 350     8726724 Clearwater Beach 2006-03-01 2006     3   1.509 1.346 1.255
#> 351     8726724 Clearwater Beach 2006-04-01 2006     4   1.504 1.342 1.247
#> 352     8726724 Clearwater Beach 2006-05-01 2006     5   1.576 1.403 1.315
#> 353     8726724 Clearwater Beach 2006-06-01 2006     6   1.738 1.408 1.283
#> 354     8726724 Clearwater Beach 2006-07-01 2006     7      NA 1.388 1.261
#> 355     8726724 Clearwater Beach 2006-08-01 2006     8   1.644 1.456 1.334
#> 356     8726724 Clearwater Beach 2006-09-01 2006     9   1.699 1.522 1.434
#> 357     8726724 Clearwater Beach 2006-10-01 2006    10   1.832 1.471 1.376
#> 358     8726724 Clearwater Beach 2006-11-01 2006    11   1.795 1.341 1.243
#> 359     8726724 Clearwater Beach 2006-12-01 2006    12   1.675 1.319 1.186
#> 360     8726724 Clearwater Beach 2007-01-01 2007     1   1.585 1.323 1.186
#> 361     8726724 Clearwater Beach 2007-02-01 2007     2      NA 1.254 1.122
#> 362     8726724 Clearwater Beach 2007-03-01 2007     3   1.573 1.270 1.178
#> 363     8726724 Clearwater Beach 2007-04-01 2007     4   1.715 1.295 1.213
#> 364     8726724 Clearwater Beach 2007-05-01 2007     5   1.707 1.469 1.332
#> 365     8726724 Clearwater Beach 2007-06-01 2007     6   1.958 1.477 1.323
#> 366     8726724 Clearwater Beach 2007-07-01 2007     7   1.700 1.460 1.313
#> 367     8726724 Clearwater Beach 2007-08-01 2007     8   1.629 1.486 1.364
#> 368     8726724 Clearwater Beach 2007-09-01 2007     9   1.699 1.478 1.363
#> 369     8726724 Clearwater Beach 2007-10-01 2007    10   1.734 1.487 1.381
#> 370     8726724 Clearwater Beach 2007-11-01 2007    11   1.611 1.360 1.252
#> 371     8726724 Clearwater Beach 2007-12-01 2007    12   1.648 1.317 1.192
#> 372     8726724 Clearwater Beach 2008-01-01 2008     1   1.576 1.276 1.181
#> 373     8726724 Clearwater Beach 2008-02-01 2008     2   1.507 1.254 1.171
#> 374     8726724 Clearwater Beach 2008-03-01 2008     3   1.691 1.251 1.150
#> 375     8726724 Clearwater Beach 2008-04-01 2008     4   1.548 1.391 1.284
#> 376     8726724 Clearwater Beach 2008-07-01 2008     7   1.691 1.504 1.370
#> 377     8726724 Clearwater Beach 2008-08-01 2008     8   1.701 1.502 1.397
#> 378     8726724 Clearwater Beach 2008-09-01 2008     9   2.037 1.582 1.503
#> 379     8726724 Clearwater Beach 2008-10-01 2008    10   1.741 1.492 1.378
#> 380     8726724 Clearwater Beach 2008-11-01 2008    11   1.885 1.403 1.291
#> 381     8726724 Clearwater Beach 2008-12-01 2008    12   1.837 1.324 1.194
#> 382     8726724 Clearwater Beach 2009-01-01 2009     1   1.553 1.239 1.127
#> 383     8726724 Clearwater Beach 2009-02-01 2009     2   1.515 1.254 1.167
#> 384     8726724 Clearwater Beach 2009-03-01 2009     3   1.702 1.380 1.291
#> 385     8726724 Clearwater Beach 2009-04-01 2009     4   1.706 1.382 1.293
#> 386     8726724 Clearwater Beach 2009-05-01 2009     5   1.685 1.419 1.294
#> 387     8726724 Clearwater Beach 2009-06-01 2009     6   1.755 1.515 1.385
#> 388     8726724 Clearwater Beach 2009-07-01 2009     7   1.729 1.524 1.387
#> 389     8726724 Clearwater Beach 2009-08-01 2009     8   1.769 1.529 1.401
#> 390     8726724 Clearwater Beach 2009-09-01 2009     9   1.782 1.597 1.508
#> 391     8726724 Clearwater Beach 2009-11-01 2009    11   1.739 1.474 1.377
#> 392     8726724 Clearwater Beach 2009-12-01 2009    12   1.874 1.438 1.300
#> 393     8726724 Clearwater Beach 2010-01-01 2010     1   1.761 1.356 1.228
#> 394     8726724 Clearwater Beach 2010-02-01 2010     2   1.764 1.354 1.242
#> 395     8726724 Clearwater Beach 2010-04-01 2010     4   1.614 1.348 1.249
#> 396     8726724 Clearwater Beach 2010-05-01 2010     5   1.622 1.419 1.297
#> 397     8726724 Clearwater Beach 2010-06-01 2010     6   1.690 1.497 1.361
#> 398     8726724 Clearwater Beach 2010-08-01 2010     8   1.884 1.529 1.428
#> 399     8726724 Clearwater Beach 2010-09-01 2010     9   1.724 1.585 1.484
#> 400     8726724 Clearwater Beach 2010-10-01 2010    10   1.775 1.458 1.362
#> 401     8726724 Clearwater Beach 2010-11-01 2010    11   1.766 1.419 1.314
#> 402     8726724 Clearwater Beach 2010-12-01 2010    12   1.639 1.298 1.150
#> 403     8726724 Clearwater Beach 2011-01-01 2011     1   1.712 1.299 1.173
#> 404     8726724 Clearwater Beach 2011-02-01 2011     2   1.672 1.290 1.174
#> 405     8726724 Clearwater Beach 2011-03-01 2011     3   1.843 1.364 1.278
#> 406     8726724 Clearwater Beach 2011-04-01 2011     4   1.569 1.368 1.272
#> 407     8726724 Clearwater Beach 2011-05-01 2011     5   1.685 1.424 1.305
#> 408     8726724 Clearwater Beach 2011-06-01 2011     6   1.650 1.487 1.350
#> 409     8726724 Clearwater Beach 2011-07-01 2011     7   1.716 1.551 1.411
#> 410     8726724 Clearwater Beach 2011-08-01 2011     8   1.882 1.556 1.446
#> 411     8726724 Clearwater Beach 2011-09-01 2011     9   1.833 1.519 1.422
#> 412     8726724 Clearwater Beach 2011-10-01 2011    10   1.946 1.456 1.352
#> 413     8726724 Clearwater Beach 2011-11-01 2011    11   1.818 1.444 1.329
#> 414     8726724 Clearwater Beach 2011-12-01 2011    12   1.612 1.359 1.254
#> 415     8726724 Clearwater Beach 2012-01-01 2012     1   1.631 1.325 1.208
#> 416     8726724 Clearwater Beach 2012-02-01 2012     2   1.553 1.371 1.254
#> 417     8726724 Clearwater Beach 2012-03-01 2012     3   1.524 1.394 1.308
#> 418     8726724 Clearwater Beach 2012-04-01 2012     4   1.769 1.445 1.340
#> 419     8726724 Clearwater Beach 2012-05-01 2012     5   1.717 1.498 1.385
#> 420     8726724 Clearwater Beach 2012-06-01 2012     6   2.163 1.624 1.496
#> 421     8726724 Clearwater Beach 2012-07-01 2012     7   1.720 1.565 1.433
#> 422     8726724 Clearwater Beach 2012-09-01 2012     9   1.748 1.520 1.430
#> 423     8726724 Clearwater Beach 2012-10-01 2012    10   1.800 1.506 1.417
#> 424     8726724 Clearwater Beach 2012-11-01 2012    11   1.729 1.507 1.402
#> 425     8726724 Clearwater Beach 2012-12-01 2012    12   1.675 1.434 1.325
#> 426     8726724 Clearwater Beach 2013-01-01 2013     1   1.910 1.408 1.270
#> 427     8726724 Clearwater Beach 2013-02-01 2013     2   1.774 1.375 1.276
#> 428     8726724 Clearwater Beach 2013-03-01 2013     3   1.706 1.359 1.258
#> 429     8726724 Clearwater Beach 2013-04-01 2013     4   1.679 1.384 1.280
#> 430     8726724 Clearwater Beach 2013-05-01 2013     5   1.590 1.392 1.288
#> 431     8726724 Clearwater Beach 2013-06-01 2013     6   1.949 1.462 1.342
#> 432     8726724 Clearwater Beach 2013-07-01 2013     7   1.699 1.505 1.391
#> 433     8726724 Clearwater Beach 2013-08-01 2013     8   1.721 1.507 1.398
#> 434     8726724 Clearwater Beach 2013-09-01 2013     9   1.742 1.542 1.459
#> 435     8726724 Clearwater Beach 2013-10-01 2013    10   1.725 1.511 1.447
#> 436     8726724 Clearwater Beach 2013-12-01 2013    12   1.800 1.415 1.293
#> 437     8726724 Clearwater Beach 2014-01-01 2014     1   1.739 1.366 1.223
#> 438     8726724 Clearwater Beach 2014-02-01 2014     2   1.606 1.375 1.275
#> 439     8726724 Clearwater Beach 2014-03-01 2014     3   1.653 1.372 1.303
#> 440     8726724 Clearwater Beach 2014-04-01 2014     4   1.698 1.429 1.345
#> 441     8726724 Clearwater Beach 2014-05-01 2014     5   1.815 1.460 1.357
#> 442     8726724 Clearwater Beach 2014-08-01 2014     8   1.748 1.520 1.411
#> 443     8726724 Clearwater Beach 2014-09-01 2014     9   1.807 1.546 1.465
#> 444     8726724 Clearwater Beach 2014-10-01 2014    10   1.668 1.507 1.434
#> 445     8726724 Clearwater Beach 2014-11-01 2014    11   1.829 1.445 1.345
#> 446     8726724 Clearwater Beach 2014-12-01 2014    12   1.919 1.480 1.379
#> 447     8726724 Clearwater Beach 2015-01-01 2015     1   1.755 1.388 1.264
#> 448     8726724 Clearwater Beach 2015-02-01 2015     2   1.859 1.442 1.337
#> 449     8726724 Clearwater Beach 2015-03-01 2015     3   1.508 1.351 1.265
#> 450     8726724 Clearwater Beach 2015-05-01 2015     5   1.612 1.458 1.351
#> 451     8726724 Clearwater Beach 2015-06-01 2015     6   1.650 1.470 1.347
#> 452     8726724 Clearwater Beach 2015-07-01 2015     7   1.812 1.518 1.400
#> 453     8726724 Clearwater Beach 2015-08-01 2015     8   1.874 1.580 1.468
#> 454     8726724 Clearwater Beach 2015-09-01 2015     9   1.827 1.560 1.473
#> 455     8726724 Clearwater Beach 2015-10-01 2015    10   1.952 1.637 1.564
#> 456     8726724 Clearwater Beach 2015-11-01 2015    11   1.701 1.528 1.441
#> 457     8726724 Clearwater Beach 2015-12-01 2015    12   1.759 1.504 1.402
#> 458     8726724 Clearwater Beach 2016-01-01 2016     1   2.032 1.488 1.353
#> 459     8726724 Clearwater Beach 2016-02-01 2016     2   1.888 1.389 1.283
#> 460     8726724 Clearwater Beach 2016-03-01 2016     3   1.603 1.390 1.303
#> 461     8726724 Clearwater Beach 2016-04-01 2016     4   1.681 1.462 1.376
#> 462     8726724 Clearwater Beach 2016-05-01 2016     5   1.668 1.486 1.402
#> 463     8726724 Clearwater Beach 2016-06-01 2016     6   2.108 1.510 1.406
#> 464     8726724 Clearwater Beach 2016-07-01 2016     7   1.652 1.499 1.386
#> 465     8726724 Clearwater Beach 2016-08-01 2016     8   1.898 1.573 1.466
#> 466     8726724 Clearwater Beach 2016-09-01 2016     9   2.251 1.590 1.511
#> 467     8726724 Clearwater Beach 2016-10-01 2016    10   1.762 1.493 1.444
#> 468     8726724 Clearwater Beach 2016-11-01 2016    11   1.824 1.522 1.442
#> 469     8726724 Clearwater Beach 2016-12-01 2016    12   1.702 1.401 1.296
#> 470     8726724 Clearwater Beach 2017-01-01 2017     1   2.059 1.438 1.314
#> 471     8726724 Clearwater Beach 2017-02-01 2017     2   1.532 1.327 1.229
#> 472     8726724 Clearwater Beach 2017-03-01 2017     3   1.617 1.321 1.255
#> 473     8726724 Clearwater Beach 2017-04-01 2017     4   1.682 1.446 1.365
#> 474     8726724 Clearwater Beach 2017-05-01 2017     5   1.822 1.429 1.348
#> 475     8726724 Clearwater Beach 2017-06-01 2017     6   1.755 1.497 1.390
#> 476     8726724 Clearwater Beach 2017-07-01 2017     7   1.690 1.505 1.387
#> 477     8726724 Clearwater Beach 2017-08-01 2017     8   1.734 1.541 1.438
#> 478     8726724 Clearwater Beach 2017-09-01 2017     9   1.738 1.560 1.470
#> 479     8726724 Clearwater Beach 2017-10-01 2017    10   2.009 1.569 1.493
#> 480     8726724 Clearwater Beach 2017-11-01 2017    11   1.766 1.464 1.386
#> 481     8726724 Clearwater Beach 2017-12-01 2017    12   1.739 1.437 1.319
#> 482     8726724 Clearwater Beach 2018-01-01 2018     1   1.627 1.277 1.156
#> 483     8726724 Clearwater Beach 2018-02-01 2018     2   1.597 1.357 1.255
#> 484     8726724 Clearwater Beach 2018-03-01 2018     3   1.699 1.448 1.370
#> 485     8726724 Clearwater Beach 2018-04-01 2018     4   1.775 1.403 1.333
#> 486     8726724 Clearwater Beach 2018-05-01 2018     5   1.764 1.466 1.354
#> 487     8726724 Clearwater Beach 2018-06-01 2018     6   1.615 1.437 1.323
#> 488     8726724 Clearwater Beach 2018-07-01 2018     7   1.741 1.516 1.400
#> 489     8726724 Clearwater Beach 2018-08-01 2018     8   1.823 1.549 1.456
#> 490     8726724 Clearwater Beach 2018-09-01 2018     9   1.829 1.574 1.492
#> 491     8726724 Clearwater Beach 2018-10-01 2018    10   2.083 1.551 1.477
#> 492     8726724 Clearwater Beach 2018-11-01 2018    11   1.796 1.449 1.379
#> 493     8726724 Clearwater Beach 2018-12-01 2018    12   2.007 1.452 1.342
#> 494     8726724 Clearwater Beach 2019-01-01 2019     1   1.846 1.376 1.269
#> 495     8726724 Clearwater Beach 2019-02-01 2019     2   1.663 1.434 1.326
#> 496     8726724 Clearwater Beach 2019-03-01 2019     3   1.611 1.429 1.361
#> 497     8726724 Clearwater Beach 2019-04-01 2019     4   1.900 1.472 1.397
#> 498     8726724 Clearwater Beach 2019-05-01 2019     5   1.827 1.529 1.435
#> 499     8726724 Clearwater Beach 2019-06-01 2019     6   1.754 1.566 1.446
#> 500     8726724 Clearwater Beach 2019-07-01 2019     7   1.775 1.580 1.451
#> 501     8726724 Clearwater Beach 2019-08-01 2019     8   1.844 1.594 1.472
#> 502     8726724 Clearwater Beach 2019-09-01 2019     9   1.884 1.566 1.486
#> 503     8726724 Clearwater Beach 2019-10-01 2019    10   1.927 1.712 1.634
#> 504     8726724 Clearwater Beach 2019-11-01 2019    11   1.936 1.617 1.512
#> 505     8726724 Clearwater Beach 2019-12-01 2019    12   1.919 1.480 1.360
#> 506     8726724 Clearwater Beach 2020-01-01 2020     1   1.802 1.432 1.311
#> 507     8726724 Clearwater Beach 2020-02-01 2020     2   1.867 1.392 1.280
#> 508     8726724 Clearwater Beach 2020-03-01 2020     3   1.621 1.404 1.321
#> 509     8726724 Clearwater Beach 2020-04-01 2020     4   1.830 1.512 1.436
#> 510     8726724 Clearwater Beach 2020-05-01 2020     5   1.659 1.476 1.384
#> 511     8726724 Clearwater Beach 2020-06-01 2020     6   1.931 1.580 1.464
#> 512     8726724 Clearwater Beach 2020-07-01 2020     7   1.852 1.552 1.428
#> 513     8726724 Clearwater Beach 2020-08-01 2020     8   1.808 1.598 1.480
#> 514     8726724 Clearwater Beach 2020-09-01 2020     9   1.839 1.625 1.527
#> 515     8726724 Clearwater Beach 2020-10-01 2020    10   1.778 1.628 1.566
#> 516     8726724 Clearwater Beach 2020-11-01 2020    11   2.149 1.546 1.447
#> 517     8726724 Clearwater Beach 2020-12-01 2020    12   1.762 1.424 1.287
#> 518     8726724 Clearwater Beach 2021-01-01 2021     1   1.769 1.404 1.269
#> 519     8726724 Clearwater Beach 2021-02-01 2021     2   1.677 1.423 1.339
#> 520     8726724 Clearwater Beach 2021-03-01 2021     3   1.720 1.443 1.374
#> 521     8726724 Clearwater Beach 2021-04-01 2021     4   2.013 1.518 1.422
#> 522     8726724 Clearwater Beach 2021-05-01 2021     5   1.715 1.464 1.367
#> 523     8726724 Clearwater Beach 2021-06-01 2021     6   1.697 1.541 1.418
#> 524     8726724 Clearwater Beach 2021-07-01 2021     7   1.840 1.522 1.396
#> 525     8726724 Clearwater Beach 2021-08-01 2021     8   1.780 1.594 1.492
#> 526     8726724 Clearwater Beach 2021-09-01 2021     9   1.704 1.581 1.496
#> 527     8726724 Clearwater Beach 2021-10-01 2021    10   1.822 1.640 1.554
#> 528     8726724 Clearwater Beach 2021-11-01 2021    11   1.711 1.520 1.429
#> 529     8726724 Clearwater Beach 2021-12-01 2021    12   1.773 1.516 1.391
#> 530     8726724 Clearwater Beach 2022-01-01 2022     1   1.917 1.491 1.344
#> 531     8726724 Clearwater Beach 2022-02-01 2022     2   1.780 1.445 1.332
#> 532     8726724 Clearwater Beach 2022-03-01 2022     3   1.755 1.454 1.368
#> 533     8726724 Clearwater Beach 2022-04-01 2022     4   1.742 1.489 1.397
#> 534     8726724 Clearwater Beach 2022-05-01 2022     5   1.864 1.571 1.459
#> 535     8726724 Clearwater Beach 2022-06-01 2022     6   1.733 1.578 1.431
#> 536     8726724 Clearwater Beach 2022-07-01 2022     7   1.750 1.566 1.431
#> 537     8726724 Clearwater Beach 2022-08-01 2022     8   1.824 1.601 1.489
#> 538     8726724 Clearwater Beach 2022-09-01 2022     9   1.934 1.630 1.517
#> 539     8726724 Clearwater Beach 2022-10-01 2022    10   1.820 1.598 1.507
#> 540     8726724 Clearwater Beach 2022-11-01 2022    11   1.824 1.553 1.459
#> 541     8726724 Clearwater Beach 2022-12-01 2022    12   1.931 1.539 1.410
#> 542     8726724 Clearwater Beach 2023-01-01 2023     1   1.890 1.463 1.323
#> 543     8726724 Clearwater Beach 2023-02-01 2023     2   1.601 1.399 1.302
#> 544     8726724 Clearwater Beach 2023-03-01 2023     3   1.816 1.523 1.433
#> 545     8726724 Clearwater Beach 2023-04-01 2023     4   1.775 1.533 1.440
#> 546     8726724 Clearwater Beach 2023-05-01 2023     5   1.718 1.534 1.422
#> 547     8726724 Clearwater Beach 2023-06-01 2023     6   1.934 1.652 1.503
#> 548     8726724 Clearwater Beach 2023-07-01 2023     7   1.781 1.560 1.420
#> 549     8726724 Clearwater Beach 2023-08-01 2023     8   2.454 1.634 1.496
#> 550     8726724 Clearwater Beach 2023-09-01 2023     9   1.822 1.596 1.494
#> 551     8726724 Clearwater Beach 2023-10-01 2023    10   1.899 1.635 1.543
#> 552     8726724 Clearwater Beach 2023-11-01 2023    11   1.838 1.589 1.474
#> 553     8726724 Clearwater Beach 2023-12-01 2023    12   2.339 1.542 1.387
#> 554     8726724 Clearwater Beach 2024-01-01 2024     1   1.914 1.428 1.307
#> 555     8726724 Clearwater Beach 2024-02-01 2024     2   1.842 1.452 1.335
#> 556     8726724 Clearwater Beach 2024-03-01 2024     3   1.731 1.469 1.364
#> 557     8726724 Clearwater Beach 2024-04-01 2024     4   2.030 1.499 1.407
#> 558     8726724 Clearwater Beach 2024-05-01 2024     5   1.814 1.555 1.443
#> 559     8726724 Clearwater Beach 2024-06-01 2024     6   1.798 1.582 1.455
#> 560     8726724 Clearwater Beach 2024-07-01 2024     7   1.754 1.577 1.429
#> 561     8726724 Clearwater Beach 2024-08-01 2024     8   2.063 1.608 1.487
#> 562     8726724 Clearwater Beach 2024-09-01 2024     9   3.245 1.781 1.663
#> 563     8726724 Clearwater Beach 2024-10-01 2024    10   1.752 1.607 1.521
#> 564     8726724 Clearwater Beach 2024-11-01 2024    11   1.939 1.609 1.506
#> 565     8726724 Clearwater Beach 2024-12-01 2024    12   1.737 1.423 1.281
#> 566     8726724 Clearwater Beach 2025-01-01 2025     1   1.721 1.352 1.228
#> 567     8726724 Clearwater Beach 2025-02-01 2025     2   1.663 1.391 1.283
#> 568     8726724 Clearwater Beach 2025-03-01 2025     3   1.692 1.440 1.368
#> 569     8726724 Clearwater Beach 2025-04-01 2025     4   1.694 1.480 1.372
#> 570     8726724 Clearwater Beach 2025-05-01 2025     5   1.808 1.544 1.426
#> 571     8726724 Clearwater Beach 2025-06-01 2025     6   1.797 1.584 1.443
#> 572     8726724 Clearwater Beach 2025-07-01 2025     7   1.814 1.576 1.449
#> 573     8726724 Clearwater Beach 2025-08-01 2025     8   1.841 1.641 1.504
#> 574     8726724 Clearwater Beach 2025-09-01 2025     9   1.844 1.620 1.509
#> 575     8726724 Clearwater Beach 2025-10-01 2025    10   1.808 1.610 1.535
#> 576     8726724 Clearwater Beach 2025-11-01 2025    11   1.821 1.490 1.381
#> 577     8726674         East Bay 2019-10-01 2019    10   1.484 1.193 1.118
#> 578     8726674         East Bay 2019-11-01 2019    11   1.413 1.090 0.982
#> 579     8726674         East Bay 2019-12-01 2019    12   1.394 0.970 0.845
#> 580     8726674         East Bay 2020-01-01 2020     1   1.268 0.926 0.830
#> 581     8726674         East Bay 2020-02-01 2020     2   1.478 0.875 0.771
#> 582     8726674         East Bay 2020-03-01 2020     3   1.225 0.908 0.825
#> 583     8726674         East Bay 2020-04-01 2020     4   1.361 1.026 0.947
#> 584     8726674         East Bay 2020-05-01 2020     5   1.220 0.964 0.871
#> 585     8726674         East Bay 2020-06-01 2020     6   1.434 1.087 0.964
#> 586     8726674         East Bay 2020-07-01 2020     7   1.289 1.066 0.937
#> 587     8726674         East Bay 2020-08-01 2020     8   1.278 1.098 0.984
#> 588     8726674         East Bay 2020-09-01 2020     9   1.419 1.123 1.028
#> 589     8726674         East Bay 2020-10-01 2020    10   1.239 1.102 1.044
#> 590     8726674         East Bay 2020-11-01 2020    11   2.013 1.024 0.934
#> 591     8726674         East Bay 2020-12-01 2020    12   1.312 0.936 0.826
#> 592     8726674         East Bay 2021-01-01 2021     1   1.260 0.921 0.788
#> 593     8726674         East Bay 2021-02-01 2021     2   1.214 0.940 0.862
#> 594     8726674         East Bay 2021-03-01 2021     3   1.270 0.943 0.904
#> 595     8726674         East Bay 2021-04-01 2021     4   1.279 1.010 0.938
#> 596     8726674         East Bay 2021-05-01 2021     5   1.274 0.962 0.861
#> 597     8726674         East Bay 2021-06-01 2021     6   1.254 1.065 0.935
#> 598     8726674         East Bay 2021-07-01 2021     7   1.410 1.062 0.940
#> 599     8726674         East Bay 2021-08-01 2021     8   1.269 1.126 1.016
#> 600     8726674         East Bay 2021-09-01 2021     9   1.210 1.101 1.015
#> 601     8726674         East Bay 2021-10-01 2021    10   1.436 1.127 1.057
#> 602     8726674         East Bay 2021-11-01 2021    11   1.237 1.002 0.925
#> 603     8726674         East Bay 2021-12-01 2021    12   1.261 1.012 0.899
#> 604     8726674         East Bay 2022-01-01 2022     1   1.422 0.993 0.898
#> 605     8726674         East Bay 2022-02-01 2022     2   1.242 0.946 0.852
#> 606     8726674         East Bay 2022-03-01 2022     3   1.305 0.961 0.884
#> 607     8726674         East Bay 2022-04-01 2022     4   1.262 0.980 0.906
#> 608     8726674         East Bay 2022-05-01 2022     5   1.350 1.077 0.976
#> 609     8726674         East Bay 2022-06-01 2022     6   1.222 1.099 0.968
#> 610     8726674         East Bay 2022-07-01 2022     7   1.272 1.075 0.949
#> 611     8726674         East Bay 2022-08-01 2022     8   1.295 1.110 1.015
#> 612     8726674         East Bay 2022-09-01 2022     9   1.456 1.127 1.039
#> 613     8726674         East Bay 2022-10-01 2022    10   1.320 1.107 1.025
#> 614     8726674         East Bay 2022-11-01 2022    11   1.430 1.072 0.957
#> 615     8726674         East Bay 2022-12-01 2022    12   1.451 1.027 0.919
#> 616     8726674         East Bay 2023-01-01 2023     1   1.355 0.971 0.847
#> 617     8726674         East Bay 2023-02-01 2023     2   1.069 0.915 0.858
#> 618     8726674         East Bay 2023-03-01 2023     3   1.344 1.048 0.974
#> 619     8726674         East Bay 2023-04-01 2023     4   1.288 1.025 0.959
#> 620     8726674         East Bay 2023-05-01 2023     5   1.233 1.044 0.965
#> 621     8726674         East Bay 2023-06-01 2023     6   1.441 1.168 1.045
#> 622     8726674         East Bay 2023-07-01 2023     7   1.281 1.069 0.957
#> 623     8726674         East Bay 2023-08-01 2023     8   2.205 1.140 1.012
#> 624     8726674         East Bay 2023-09-01 2023     9   1.288 1.086 0.999
#> 625     8726674         East Bay 2023-10-01 2023    10   1.504 1.092 1.008
#> 626     8726674         East Bay 2023-11-01 2023    11   1.332 1.032 0.948
#> 627     8726674         East Bay 2023-12-01 2023    12   1.922 1.015 0.892
#> 628     8726674         East Bay 2024-01-01 2024     1   1.435 0.919 0.819
#> 629     8726674         East Bay 2024-02-01 2024     2   1.341 0.946 0.854
#> 630     8726674         East Bay 2024-03-01 2024     3   1.215 0.978 0.873
#> 631     8726674         East Bay 2024-04-01 2024     4   1.554 1.010 0.903
#> 632     8726674         East Bay 2024-05-01 2024     5   1.325 1.082 0.964
#> 633     8726674         East Bay 2024-06-01 2024     6   1.300 1.090 0.965
#> 634     8726674         East Bay 2024-07-01 2024     7   1.244 1.091 0.972
#> 635     8726674         East Bay 2024-08-01 2024     8   1.750 1.141 1.050
#> 636     8726674         East Bay 2024-09-01 2024     9   3.059 1.313 1.195
#> 637     8726674         East Bay 2024-10-01 2024    10   1.334 1.095 1.020
#> 638     8726674         East Bay 2024-11-01 2024    11   1.512 1.100 1.016
#> 639     8726674         East Bay 2024-12-01 2024    12   1.260 0.924 0.826
#> 640     8726674         East Bay 2025-01-01 2025     1   1.258 0.849 0.738
#> 641     8726674         East Bay 2025-02-01 2025     2   1.135 0.895 0.810
#> 642     8726674         East Bay 2025-03-01 2025     3   1.284 0.955 0.875
#> 643     8726674         East Bay 2025-04-01 2025     4   1.177 0.982 0.891
#> 644     8726674         East Bay 2025-05-01 2025     5   1.309 1.074 0.966
#> 645     8726674         East Bay 2025-06-01 2025     6   1.329 1.102 0.965
#> 646     8726674         East Bay 2025-07-01 2025     7   1.287 1.098 0.990
#> 647     8726674         East Bay 2025-08-01 2025     8   1.361 1.160 1.059
#> 648     8726674         East Bay 2025-09-01 2025     9   1.320 1.102 1.018
#> 649     8726674         East Bay 2025-10-01 2025    10   1.282 1.063 0.995
#> 650     8726674         East Bay 2025-11-01 2025    11   1.300 0.984 0.872
#> 651     8726384     Port Manatee 1976-06-01 1976     6      NA    NA    NA
#> 652     8726384     Port Manatee 1976-07-01 1976     7      NA    NA    NA
#> 653     8726384     Port Manatee 1976-08-01 1976     8      NA    NA    NA
#> 654     8726384     Port Manatee 1976-11-01 1976    11      NA    NA    NA
#> 655     8726384     Port Manatee 1976-12-01 1976    12      NA    NA    NA
#> 656     8726384     Port Manatee 1977-01-01 1977     1      NA    NA    NA
#> 657     8726384     Port Manatee 1977-03-01 1977     3      NA    NA    NA
#> 658     8726384     Port Manatee 1977-04-01 1977     4      NA    NA    NA
#> 659     8726384     Port Manatee 1977-05-01 1977     5      NA    NA    NA
#> 660     8726384     Port Manatee 1977-06-01 1977     6      NA 0.719 0.603
#> 661     8726384     Port Manatee 1977-07-01 1977     7      NA    NA    NA
#> 662     8726384     Port Manatee 1977-09-01 1977     9      NA    NA    NA
#> 663     8726384     Port Manatee 1991-01-01 1991     1   1.013 0.714 0.604
#> 664     8726384     Port Manatee 1991-02-01 1991     2   0.927 0.592 0.501
#> 665     8726384     Port Manatee 1991-03-01 1991     3   1.150 0.656 0.601
#> 666     8726384     Port Manatee 1991-04-01 1991     4   0.952 0.711 0.635
#> 667     8726384     Port Manatee 1991-05-01 1991     5   1.013 0.802 0.708
#> 668     8726384     Port Manatee 1991-06-01 1991     6   0.988 0.763 0.656
#> 669     8726384     Port Manatee 1991-07-01 1991     7   0.997 0.790 0.695
#> 670     8726384     Port Manatee 1991-08-01 1991     8   0.958 0.787 0.708
#> 671     8726384     Port Manatee 1994-05-01 1994     5   0.970 0.686 0.578
#> 672     8726384     Port Manatee 1995-02-01 1995     2   0.713 0.523 0.449
#> 673     8726384     Port Manatee 1995-03-01 1995     3   0.777 0.623 0.561
#> 674     8726384     Port Manatee 1995-04-01 1995     4   0.924 0.687 0.616
#> 675     8726384     Port Manatee 1995-05-01 1995     5   0.943 0.771 0.663
#> 676     8726384     Port Manatee 1995-06-01 1995     6   1.100 0.759 0.620
#> 677     8726384     Port Manatee 1995-07-01 1995     7   0.965 0.766 0.663
#> 678     8726384     Port Manatee 1995-08-01 1995     8   1.130 0.881 0.804
#> 679     8726384     Port Manatee 1996-03-01 1996     3   0.888 0.579 0.492
#> 680     8726384     Port Manatee 1996-04-01 1996     4   0.787 0.621 0.547
#> 681     8726384     Port Manatee 1996-05-01 1996     5   0.785 0.657 0.548
#> 682     8726384     Port Manatee 1996-06-01 1996     6   0.868 0.679 0.556
#> 683     8726384     Port Manatee 1996-07-01 1996     7   0.949 0.730 0.604
#> 684     8726384     Port Manatee 1996-08-01 1996     8   0.861 0.741 0.644
#> 685     8726384     Port Manatee 1999-01-01 1999     1   1.330 0.713 0.591
#> 686     8726384     Port Manatee 1999-02-01 1999     2   0.948 0.731 0.668
#> 687     8726384     Port Manatee 1999-03-01 1999     3   0.922 0.687 0.620
#> 688     8726384     Port Manatee 1999-04-01 1999     4   1.015 0.708 0.663
#> 689     8726384     Port Manatee 1999-05-01 1999     5   0.950 0.774 0.674
#> 690     8726384     Port Manatee 1999-06-01 1999     6   0.950 0.748 0.643
#> 691     8726384     Port Manatee 1999-07-01 1999     7   0.946 0.788 0.678
#> 692     8726384     Port Manatee 1999-08-01 1999     8   0.997 0.832 0.731
#> 693     8726384     Port Manatee 1999-09-01 1999     9   1.106 0.899 0.822
#> 694     8726384     Port Manatee 1999-10-01 1999    10   0.901 0.774 0.722
#> 695     8726384     Port Manatee 1999-11-01 1999    11   0.969 0.707 0.642
#> 696     8726384     Port Manatee 1999-12-01 1999    12   0.891 0.655 0.558
#> 697     8726384     Port Manatee 2000-01-01 2000     1   0.921 0.634 0.529
#> 698     8726384     Port Manatee 2000-02-01 2000     2   0.806 0.604 0.517
#> 699     8726384     Port Manatee 2000-03-01 2000     3   0.968 0.696 0.623
#> 700     8726384     Port Manatee 2000-04-01 2000     4      NA 0.694 0.627
#> 701     8726384     Port Manatee 2000-05-01 2000     5      NA 0.720 0.631
#> 702     8726384     Port Manatee 2000-06-01 2000     6   0.987 0.779 0.667
#> 703     8726384     Port Manatee 2000-07-01 2000     7      NA 0.804 0.689
#> 704     8726384     Port Manatee 2000-08-01 2000     8   1.000 0.816 0.711
#> 705     8726384     Port Manatee 2000-09-01 2000     9   1.419 0.817 0.745
#> 706     8726384     Port Manatee 2000-10-01 2000    10   0.912 0.741 0.680
#> 707     8726384     Port Manatee 2000-11-01 2000    11   1.054 0.756 0.690
#> 708     8726384     Port Manatee 2000-12-01 2000    12   0.989 0.641 0.552
#> 709     8726384     Port Manatee 2001-01-01 2001     1   0.811 0.516 0.429
#> 710     8726384     Port Manatee 2001-02-01 2001     2   0.718 0.545 0.468
#> 711     8726384     Port Manatee 2001-03-01 2001     3   0.909 0.655 0.579
#> 712     8726384     Port Manatee 2001-04-01 2001     4   0.820 0.637 0.585
#> 713     8726384     Port Manatee 2001-05-01 2001     5   0.912 0.699 0.626
#> 714     8726384     Port Manatee 2001-06-01 2001     6   0.848 0.680 0.570
#> 715     8726384     Port Manatee 2001-07-01 2001     7   1.350 0.778 0.668
#> 716     8726384     Port Manatee 2001-08-01 2001     8   1.045 0.784 0.688
#> 717     8726384     Port Manatee 2001-09-01 2001     9   1.004 0.822 0.744
#> 718     8726384     Port Manatee 2001-10-01 2001    10   1.077 0.785 0.736
#> 719     8726384     Port Manatee 2001-11-01 2001    11   0.961 0.807 0.750
#> 720     8726384     Port Manatee 2001-12-01 2001    12   1.059 0.794 0.703
#> 721     8726384     Port Manatee 2002-01-01 2002     1   0.929 0.693 0.619
#> 722     8726384     Port Manatee 2002-02-01 2002     2   0.841 0.602 0.504
#> 723     8726384     Port Manatee 2002-03-01 2002     3   0.792 0.525 0.474
#> 724     8726384     Port Manatee 2002-04-01 2002     4   0.843 0.679 0.632
#> 725     8726384     Port Manatee 2002-05-01 2002     5   0.934 0.754 0.653
#> 726     8726384     Port Manatee 2002-06-01 2002     6   0.968 0.791 0.708
#> 727     8726384     Port Manatee 2002-07-01 2002     7   1.001 0.767 0.682
#> 728     8726384     Port Manatee 2002-08-01 2002     8   0.917 0.806 0.721
#> 729     8726384     Port Manatee 2002-09-01 2002     9   1.081 0.878 0.820
#> 730     8726384     Port Manatee 2002-10-01 2002    10   0.986 0.848 0.799
#> 731     8726384     Port Manatee 2002-11-01 2002    11   1.167 0.708 0.650
#> 732     8726384     Port Manatee 2002-12-01 2002    12   0.988 0.655 0.566
#> 733     8726384     Port Manatee 2003-01-01 2003     1   1.157 0.640 0.547
#> 734     8726384     Port Manatee 2003-02-01 2003     2      NA 0.616 0.547
#> 735     8726384     Port Manatee 2003-03-01 2003     3      NA 0.734 0.667
#> 736     8726384     Port Manatee 2003-04-01 2003     4      NA 0.762 0.690
#> 737     8726384     Port Manatee 2003-05-01 2003     5   0.958 0.776 0.708
#> 738     8726384     Port Manatee 2003-06-01 2003     6   1.089 0.827 0.746
#> 739     8726384     Port Manatee 2003-07-01 2003     7   1.062 0.860 0.753
#> 740     8726384     Port Manatee 2003-08-01 2003     8   1.067 0.850 0.757
#> 741     8726384     Port Manatee 2003-09-01 2003     9   1.177 0.900 0.822
#> 742     8726384     Port Manatee 2003-10-01 2003    10   1.125 0.850 0.804
#> 743     8726384     Port Manatee 2003-11-01 2003    11   1.040 0.803 0.735
#> 744     8726384     Port Manatee 2003-12-01 2003    12   0.997 0.694 0.609
#> 745     8726384     Port Manatee 2004-01-01 2004     1   1.026 0.687 0.610
#> 746     8726384     Port Manatee 2004-02-01 2004     2   0.891 0.674 0.593
#> 747     8726384     Port Manatee 2004-03-01 2004     3   0.849 0.693 0.615
#> 748     8726384     Port Manatee 2004-04-01 2004     4   0.964 0.710 0.636
#> 749     8726384     Port Manatee 2004-05-01 2004     5   0.937 0.764 0.683
#> 750     8726384     Port Manatee 2004-06-01 2004     6   1.048 0.836 0.742
#> 751     8726384     Port Manatee 2004-07-01 2004     7   1.027 0.825 0.723
#> 752     8726384     Port Manatee 2004-08-01 2004     8   1.068 0.832 0.731
#> 753     8726384     Port Manatee 2004-09-01 2004     9   1.430 0.869 0.780
#> 754     8726384     Port Manatee 2004-10-01 2004    10   0.965 0.833 0.772
#> 755     8726384     Port Manatee 2004-11-01 2004    11   1.152 0.821 0.770
#> 756     8726384     Port Manatee 2004-12-01 2004    12   1.232 0.645 0.584
#> 757     8726384     Port Manatee 2005-01-01 2005     1   0.962 0.695 0.618
#> 758     8726384     Port Manatee 2005-02-01 2005     2   1.103 0.778 0.705
#> 759     8726384     Port Manatee 2005-03-01 2005     3   0.919 0.681 0.624
#> 760     8726384     Port Manatee 2005-04-01 2005     4   1.005 0.763 0.701
#> 761     8726384     Port Manatee 2005-05-01 2005     5   1.002 0.806 0.722
#> 762     8726384     Port Manatee 2005-06-01 2005     6   1.017 0.831 0.752
#> 763     8726384     Port Manatee 2005-07-01 2005     7   1.300 0.867 0.777
#> 764     8726384     Port Manatee 2005-08-01 2005     8   1.097 0.857 0.759
#> 765     8726384     Port Manatee 2005-09-01 2005     9   1.317 0.873 0.788
#> 766     8726384     Port Manatee 2005-10-01 2005    10   1.085 0.792 0.726
#> 767     8726384     Port Manatee 2005-11-01 2005    11   0.954 0.751 0.693
#> 768     8726384     Port Manatee 2005-12-01 2005    12   1.016 0.691 0.600
#> 769     8726384     Port Manatee 2006-01-01 2006     1   1.031 0.687 0.587
#> 770     8726384     Port Manatee 2006-02-01 2006     2   0.903 0.641 0.565
#> 771     8726384     Port Manatee 2006-03-01 2006     3   0.917 0.701 0.641
#> 772     8726384     Port Manatee 2006-04-01 2006     4   0.871 0.712 0.639
#> 773     8726384     Port Manatee 2006-05-01 2006     5   0.944 0.792 0.728
#> 774     8726384     Port Manatee 2006-06-01 2006     6   1.095 0.790 0.691
#> 775     8726384     Port Manatee 2006-07-01 2006     7   0.966 0.765 0.665
#> 776     8726384     Port Manatee 2006-08-01 2006     8   0.964 0.828 0.743
#> 777     8726384     Port Manatee 2006-09-01 2006     9   1.057 0.894 0.823
#> 778     8726384     Port Manatee 2006-10-01 2006    10   1.257 0.846 0.789
#> 779     8726384     Port Manatee 2006-11-01 2006    11   1.134 0.719 0.663
#> 780     8726384     Port Manatee 2006-12-01 2006    12   1.060 0.695 0.616
#> 781     8726384     Port Manatee 2007-01-01 2007     1   0.927 0.695 0.627
#> 782     8726384     Port Manatee 2007-02-01 2007     2   1.138 0.637 0.533
#> 783     8726384     Port Manatee 2007-03-01 2007     3   0.972 0.649 0.567
#> 784     8726384     Port Manatee 2007-04-01 2007     4   1.018 0.671 0.605
#> 785     8726384     Port Manatee 2007-05-01 2007     5   1.068 0.841 0.755
#> 786     8726384     Port Manatee 2007-06-01 2007     6   1.400 0.867 0.785
#> 787     8726384     Port Manatee 2007-07-01 2007     7   1.044 0.849 0.755
#> 788     8726384     Port Manatee 2007-08-01 2007     8   1.015 0.859 0.779
#> 789     8726384     Port Manatee 2007-09-01 2007     9   1.092 0.849 0.765
#> 790     8726384     Port Manatee 2007-10-01 2007    10   1.154 0.862 0.798
#> 791     8726384     Port Manatee 2007-11-01 2007    11   0.998 0.755 0.695
#> 792     8726384     Port Manatee 2007-12-01 2007    12   1.055 0.722 0.633
#> 793     8726384     Port Manatee 2008-01-01 2008     1   0.976 0.669 0.596
#> 794     8726384     Port Manatee 2008-02-01 2008     2   0.897 0.654 0.587
#> 795     8726384     Port Manatee 2008-03-01 2008     3   1.001 0.644 0.574
#> 796     8726384     Port Manatee 2008-04-01 2008     4   0.892 0.730 0.659
#> 797     8726384     Port Manatee 2008-05-01 2008     5   1.068 0.798 0.722
#> 798     8726384     Port Manatee 2008-06-01 2008     6   0.978 0.804 0.712
#> 799     8726384     Port Manatee 2008-07-01 2008     7   1.063 0.874 0.784
#> 800     8726384     Port Manatee 2008-08-01 2008     8   1.029 0.886 0.787
#> 801     8726384     Port Manatee 2008-09-01 2008     9   1.307 0.938 0.858
#> 802     8726384     Port Manatee 2008-10-01 2008    10   1.053 0.838 0.779
#> 803     8726384     Port Manatee 2008-11-01 2008    11   1.189 0.761 0.708
#> 804     8726384     Port Manatee 2009-02-01 2009     2   0.880 0.603 0.521
#> 805     8726384     Port Manatee 2009-03-01 2009     3   1.008 0.733 0.679
#> 806     8726384     Port Manatee 2009-04-01 2009     4   0.955 0.736 0.666
#> 807     8726384     Port Manatee 2009-05-01 2009     5   1.030 0.775 0.699
#> 808     8726384     Port Manatee 2009-06-01 2009     6   1.106 0.865 0.791
#> 809     8726384     Port Manatee 2009-07-01 2009     7   1.085 0.890 0.797
#> 810     8726384     Port Manatee 2009-08-01 2009     8   1.069 0.882 0.791
#> 811     8726384     Port Manatee 2009-09-01 2009     9   1.147 0.955 0.890
#> 812     8726384     Port Manatee 2009-10-01 2009    10   1.046 0.863 0.818
#> 813     8726384     Port Manatee 2009-11-01 2009    11   1.039 0.829 0.780
#> 814     8726384     Port Manatee 2010-04-01 2010     4   0.937 0.707 0.637
#> 815     8726384     Port Manatee 2010-05-01 2010     5   0.968 0.790 0.687
#> 816     8726384     Port Manatee 2010-06-01 2010     6   1.039 0.852 0.754
#> 817     8726384     Port Manatee 2010-07-01 2010     7   1.078 0.847 0.755
#> 818     8726384     Port Manatee 2010-08-01 2010     8   1.161 0.872 0.791
#> 819     8726384     Port Manatee 2010-09-01 2010     9   1.082 0.922 0.848
#> 820     8726384     Port Manatee 2010-10-01 2010    10   1.091 0.807 0.742
#> 821     8726384     Port Manatee 2010-11-01 2010    11   1.082 0.760 0.696
#> 822     8726384     Port Manatee 2010-12-01 2010    12   0.938 0.655 0.566
#> 823     8726384     Port Manatee 2011-01-01 2011     1   0.953 0.657 0.576
#> 824     8726384     Port Manatee 2011-04-01 2011     4   0.900 0.727 0.650
#> 825     8726384     Port Manatee 2011-05-01 2011     5   1.006 0.787 0.689
#> 826     8726384     Port Manatee 2011-06-01 2011     6   1.010 0.849 0.754
#> 827     8726384     Port Manatee 2011-07-01 2011     7   1.051 0.898 0.787
#> 828     8726384     Port Manatee 2011-08-01 2011     8   1.115 0.895 0.808
#> 829     8726384     Port Manatee 2011-09-01 2011     9   1.191 0.859 0.778
#> 830     8726384     Port Manatee 2011-10-01 2011    10   1.318 0.789 0.710
#> 831     8726384     Port Manatee 2011-11-01 2011    11   1.117 0.778 0.682
#> 832     8726384     Port Manatee 2011-12-01 2011    12   0.974 0.715 0.627
#> 833     8726384     Port Manatee 2012-01-01 2012     1   0.877 0.657 0.577
#> 834     8726384     Port Manatee 2012-02-01 2012     2   0.908 0.700 0.610
#> 835     8726384     Port Manatee 2012-03-01 2012     3   0.876 0.739 0.660
#> 836     8726384     Port Manatee 2012-04-01 2012     4   1.125 0.796 0.716
#> 837     8726384     Port Manatee 2012-05-01 2012     5   1.033 0.834 0.733
#> 838     8726384     Port Manatee 2012-06-01 2012     6   1.395 0.954 0.848
#> 839     8726384     Port Manatee 2012-07-01 2012     7   1.046 0.907 0.799
#> 840     8726384     Port Manatee 2012-08-01 2012     8   1.155 0.920 0.814
#> 841     8726384     Port Manatee 2012-09-01 2012     9   1.040 0.851 0.782
#> 842     8726384     Port Manatee 2012-10-01 2012    10   1.115 0.828 0.756
#> 843     8726384     Port Manatee 2012-11-01 2012    11   1.082 0.844 0.750
#> 844     8726384     Port Manatee 2012-12-01 2012    12   1.037 0.781 0.693
#> 845     8726384     Port Manatee 2013-01-01 2013     1   0.950 0.733 0.655
#> 846     8726384     Port Manatee 2013-02-01 2013     2   1.048 0.716 0.640
#> 847     8726384     Port Manatee 2013-03-01 2013     3   0.991 0.720 0.643
#> 848     8726384     Port Manatee 2013-04-01 2013     4   1.048 0.745 0.658
#> 849     8726384     Port Manatee 2013-05-01 2013     5   0.926 0.768 0.676
#> 850     8726384     Port Manatee 2013-06-01 2013     6   1.261 0.838 0.717
#> 851     8726384     Port Manatee 2013-07-01 2013     7   1.052 0.891 0.786
#> 852     8726384     Port Manatee 2013-08-01 2013     8   0.997 0.878 0.795
#> 853     8726384     Port Manatee 2013-09-01 2013     9   1.020 0.897 0.835
#> 854     8726384     Port Manatee 2013-10-01 2013    10   1.062 0.869 0.823
#> 855     8726384     Port Manatee 2013-11-01 2013    11   1.082 0.794 0.719
#> 856     8726384     Port Manatee 2013-12-01 2013    12   1.116 0.789 0.696
#> 857     8726384     Port Manatee 2014-01-01 2014     1   1.003 0.729 0.599
#> 858     8726384     Port Manatee 2014-02-01 2014     2   0.951 0.735 0.655
#> 859     8726384     Port Manatee 2014-03-01 2014     3   0.985 0.720 0.664
#> 860     8726384     Port Manatee 2014-04-01 2014     4   1.018 0.779 0.698
#> 861     8726384     Port Manatee 2014-05-01 2014     5   1.097 0.816 0.712
#> 862     8726384     Port Manatee 2014-06-01 2014     6   1.081 0.834 0.717
#> 863     8726384     Port Manatee 2014-07-01 2014     7   1.000 0.830 0.725
#> 864     8726384     Port Manatee 2014-08-01 2014     8   1.054 0.872 0.784
#> 865     8726384     Port Manatee 2014-09-01 2014     9   1.052 0.889 0.816
#> 866     8726384     Port Manatee 2014-10-01 2014    10   0.995 0.856 0.798
#> 867     8726384     Port Manatee 2014-11-01 2014    11   1.156 0.790 0.698
#> 868     8726384     Port Manatee 2014-12-01 2014    12   1.129 0.845 0.737
#> 869     8726384     Port Manatee 2015-01-01 2015     1   1.024 0.747 0.661
#> 870     8726384     Port Manatee 2015-02-01 2015     2   1.103 0.729 0.641
#> 871     8726384     Port Manatee 2015-03-01 2015     3   0.856 0.686 0.620
#> 872     8726384     Port Manatee 2015-04-01 2015     4   0.983 0.768 0.704
#> 873     8726384     Port Manatee 2015-05-01 2015     5   0.935 0.805 0.703
#> 874     8726384     Port Manatee 2015-06-01 2015     6   0.969 0.824 0.707
#> 875     8726384     Port Manatee 2015-07-01 2015     7   1.166 0.885 0.765
#> 876     8726384     Port Manatee 2015-08-01 2015     8   1.154 0.931 0.828
#> 877     8726384     Port Manatee 2015-09-01 2015     9   1.161 0.908 0.839
#> 878     8726384     Port Manatee 2015-10-01 2015    10   1.240 0.968 0.914
#> 879     8726384     Port Manatee 2015-11-01 2015    11   1.037 0.864 0.788
#> 880     8726384     Port Manatee 2015-12-01 2015    12   1.070 0.854 0.755
#> 881     8726384     Port Manatee 2016-01-01 2016     1   1.260 0.843 0.757
#> 882     8726384     Port Manatee 2016-02-01 2016     2   1.245 0.759 0.666
#> 883     8726384     Port Manatee 2016-03-01 2016     3   0.913 0.749 0.679
#> 884     8726384     Port Manatee 2016-04-01 2016     4   1.037 0.814 0.752
#> 885     8726384     Port Manatee 2016-05-01 2016     5   1.016 0.856 0.779
#> 886     8726384     Port Manatee 2016-06-01 2016     6   1.245 0.868 0.769
#> 887     8726384     Port Manatee 2016-07-01 2016     7   1.024 0.865 0.750
#> 888     8726384     Port Manatee 2016-08-01 2016     8   1.240 0.909 0.806
#> 889     8726384     Port Manatee 2016-09-01 2016     9   1.441 0.929 0.866
#> 890     8726384     Port Manatee 2016-10-01 2016    10   1.087 0.836 0.794
#> 891     8726384     Port Manatee 2016-11-01 2016    11   1.115 0.867 0.798
#> 892     8726384     Port Manatee 2016-12-01 2016    12   0.993 0.760 0.674
#> 893     8726384     Port Manatee 2017-01-01 2017     1   1.383 0.784 0.694
#> 894     8726384     Port Manatee 2017-02-01 2017     2   0.857 0.680 0.600
#> 895     8726384     Port Manatee 2017-03-01 2017     3   0.967 0.657 0.593
#> 896     8726384     Port Manatee 2017-04-01 2017     4   1.021 0.792 0.730
#> 897     8726384     Port Manatee 2017-05-01 2017     5   1.134 0.791 0.718
#> 898     8726384     Port Manatee 2017-06-01 2017     6   1.137 0.857 0.750
#> 899     8726384     Port Manatee 2017-07-01 2017     7   1.029 0.869 0.745
#> 900     8726384     Port Manatee 2017-08-01 2017     8   1.068 0.907 0.814
#> 901     8726384     Port Manatee 2017-09-01 2017     9   1.077 0.914 0.825
#> 902     8726384     Port Manatee 2017-10-01 2017    10   1.315 0.908 0.851
#> 903     8726384     Port Manatee 2017-11-01 2017    11   1.071 0.802 0.738
#> 904     8726384     Port Manatee 2017-12-01 2017    12   1.030 0.786 0.673
#> 905     8726384     Port Manatee 2018-01-01 2018     1   1.005 0.628 0.551
#> 906     8726384     Port Manatee 2018-02-01 2018     2   0.880 0.704 0.620
#> 907     8726384     Port Manatee 2018-03-01 2018     3   1.051 0.797 0.738
#> 908     8726384     Port Manatee 2018-04-01 2018     4   0.997 0.748 0.688
#> 909     8726384     Port Manatee 2018-05-01 2018     5   1.062 0.826 0.745
#> 910     8726384     Port Manatee 2018-06-01 2018     6   0.970 0.805 0.692
#> 911     8726384     Port Manatee 2018-07-01 2018     7   1.078 0.888 0.772
#> 912     8726384     Port Manatee 2018-08-01 2018     8   1.111 0.896 0.806
#> 913     8726384     Port Manatee 2018-09-01 2018     9   1.126 0.915 0.846
#> 914     8726384     Port Manatee 2018-10-01 2018    10   1.345 0.889 0.847
#> 915     8726384     Port Manatee 2018-11-01 2018    11   1.089 0.821 0.748
#> 916     8726384     Port Manatee 2018-12-01 2018    12   1.366 0.804 0.745
#> 917     8726384     Port Manatee 2019-01-01 2019     1   1.150 0.716 0.636
#> 918     8726384     Port Manatee 2019-02-01 2019     2   0.988 0.774 0.688
#> 919     8726384     Port Manatee 2019-03-01 2019     3   0.961 0.774 0.716
#> 920     8726384     Port Manatee 2019-04-01 2019     4   1.142 0.824 0.760
#> 921     8726384     Port Manatee 2019-05-01 2019     5   1.096 0.876 0.804
#> 922     8726384     Port Manatee 2019-06-01 2019     6   1.077 0.920 0.815
#> 923     8726384     Port Manatee 2019-07-01 2019     7   1.121 0.945 0.831
#> 924     8726384     Port Manatee 2019-08-01 2019     8   1.166 0.950 0.849
#> 925     8726384     Port Manatee 2019-09-01 2019     9   1.154 0.904 0.831
#> 926     8726384     Port Manatee 2019-10-01 2019    10   1.262 1.042 0.979
#> 927     8726384     Port Manatee 2019-11-01 2019    11   1.246 0.949 0.869
#> 928     8726384     Port Manatee 2019-12-01 2019    12   1.183 0.836 0.731
#> 929     8726384     Port Manatee 2020-01-01 2020     1   1.104 0.791 0.714
#> 930     8726384     Port Manatee 2020-02-01 2020     2   1.345 0.728 0.637
#> 931     8726384     Port Manatee 2020-03-01 2020     3   0.948 0.724 0.652
#> 932     8726384     Port Manatee 2020-04-01 2020     4   1.066 0.830 0.764
#> 933     8726384     Port Manatee 2020-05-01 2020     5   0.999 0.786 0.712
#> 934     8726384     Port Manatee 2020-06-01 2020     6   1.209 0.890 0.783
#> 935     8726384     Port Manatee 2020-07-01 2020     7   1.106 0.870 0.772
#> 936     8726384     Port Manatee 2020-08-01 2020     8   1.121 0.933 0.851
#> 937     8726384     Port Manatee 2020-09-01 2020     9   1.176 0.979 0.906
#> 938     8726384     Port Manatee 2020-10-01 2020    10   1.133 0.974 0.917
#> 939     8726384     Port Manatee 2020-11-01 2020    11   1.643 0.910 0.863
#> 940     8726384     Port Manatee 2020-12-01 2020    12   1.105 0.801 0.740
#> 941     8726384     Port Manatee 2021-01-01 2021     1   1.108 0.777 0.672
#> 942     8726384     Port Manatee 2021-02-01 2021     2   1.047 0.801 0.718
#> 943     8726384     Port Manatee 2021-03-01 2021     3   1.008 0.792 0.754
#> 944     8726384     Port Manatee 2021-04-01 2021     4   1.088 0.860 0.802
#> 945     8726384     Port Manatee 2021-05-01 2021     5   1.067 0.823 0.752
#> 946     8726384     Port Manatee 2021-07-01 2021     7   1.196 0.899 0.834
#> 947     8726384     Port Manatee 2021-08-01 2021     8   1.104 0.972 0.879
#> 948     8726384     Port Manatee 2021-09-01 2021     9   1.039 0.947 0.876
#> 949     8726384     Port Manatee 2021-10-01 2021    10   1.265 0.991 0.928
#> 950     8726384     Port Manatee 2021-11-01 2021    11   1.111 0.893 0.841
#> 951     8726384     Port Manatee 2021-12-01 2021    12   1.100 0.876 0.802
#> 952     8726384     Port Manatee 2022-01-01 2022     1   1.216 0.859 0.791
#> 953     8726384     Port Manatee 2022-02-01 2022     2   1.084 0.814 0.745
#> 954     8726384     Port Manatee 2022-03-01 2022     3   1.093 0.819 0.752
#> 955     8726384     Port Manatee 2022-04-01 2022     4   0.968 0.840 0.774
#> 956     8726384     Port Manatee 2022-05-01 2022     5   1.163 0.931 0.856
#> 957     8726384     Port Manatee 2022-06-01 2022     6   1.079 0.950 0.858
#> 958     8726384     Port Manatee 2022-07-01 2022     7   1.093 0.938 0.841
#> 959     8726384     Port Manatee 2022-08-01 2022     8   1.137 0.965 0.898
#> 960     8726384     Port Manatee 2022-09-01 2022     9   1.272 0.984 0.910
#> 961     8726384     Port Manatee 2022-10-01 2022    10   1.156 0.970 0.916
#> 962     8726384     Port Manatee 2022-11-01 2022    11   1.243 0.947 0.870
#> 963     8726384     Port Manatee 2022-12-01 2022    12   1.263 0.898 0.825
#> 964     8726384     Port Manatee 2023-01-01 2023     1   1.168 0.826 0.741
#> 965     8726384     Port Manatee 2023-02-01 2023     2   0.920 0.770 0.713
#> 966     8726384     Port Manatee 2023-03-01 2023     3   1.185 0.888 0.821
#> 967     8726384     Port Manatee 2023-04-01 2023     4   1.073 0.891 0.821
#> 968     8726384     Port Manatee 2023-05-01 2023     5   1.073 0.904 0.829
#> 969     8726384     Port Manatee 2023-06-01 2023     6   1.243 1.013 0.909
#> 970     8726384     Port Manatee 2023-07-01 2023     7   1.114 0.925 0.845
#> 971     8726384     Port Manatee 2023-08-01 2023     8   1.818 0.985 0.882
#> 972     8726384     Port Manatee 2023-09-01 2023     9   1.129 0.946 0.864
#> 973     8726384     Port Manatee 2023-10-01 2023    10   1.284 0.975 0.912
#> 974     8726384     Port Manatee 2023-11-01 2023    11   1.175 0.930 0.876
#> 975     8726384     Port Manatee 2023-12-01 2023    12   1.643 0.889 0.797
#> 976     8726384     Port Manatee 2024-01-01 2024     1   1.245 0.788 0.704
#> 977     8726384     Port Manatee 2024-02-01 2024     2   1.179 0.821 0.745
#> 978     8726384     Port Manatee 2024-03-01 2024     3   1.012 0.835 0.749
#> 979     8726384     Port Manatee 2024-04-01 2024     4   1.352 0.866 0.784
#> 980     8726384     Port Manatee 2024-05-01 2024     5   1.144 0.930 0.845
#> 981     8726384     Port Manatee 2024-06-01 2024     6   1.133 0.949 0.867
#> 982     8726384     Port Manatee 2024-07-01 2024     7   1.083 0.944 0.846
#> 983     8726384     Port Manatee 2024-08-01 2024     8   1.427 0.972 0.914
#> 984     8726384     Port Manatee 2024-09-01 2024     9   2.555 1.137 1.037
#> 985     8726384     Port Manatee 2024-10-01 2024    10   1.130 0.961 0.909
#> 986     8726384     Port Manatee 2024-11-01 2024    11   1.343 0.966 0.899
#> 987     8726384     Port Manatee 2024-12-01 2024    12   1.082 0.795 0.737
#> 988     8726384     Port Manatee 2025-01-01 2025     1   1.051 0.718 0.620
#> 989     8726384     Port Manatee 2025-02-01 2025     2   0.977 0.746 0.672
#> 990     8726384     Port Manatee 2025-03-01 2025     3   1.127 0.799 0.734
#> 991     8726384     Port Manatee 2025-04-01 2025     4   1.024 0.835 0.756
#> 992     8726384     Port Manatee 2025-05-01 2025     5   1.137 0.911 0.834
#> 993     8726384     Port Manatee 2025-06-01 2025     6   1.154 0.946 0.856
#> 994     8726384     Port Manatee 2025-07-01 2025     7   1.110 0.931 0.845
#> 995     8726384     Port Manatee 2025-08-01 2025     8   1.193 1.005 0.929
#> 996     8726384     Port Manatee 2025-09-01 2025     9   1.141 0.967 0.898
#> 997     8726384     Port Manatee 2025-10-01 2025    10   1.134 0.959 0.909
#> 998     8726384     Port Manatee 2025-11-01 2025    11   1.150 0.842 0.762
#> 999     8726520   St. Petersburg 1947-01-01 1947     1   1.768 1.564 1.442
#> 1000    8726520   St. Petersburg 1947-02-01 1947     2   1.890 1.515 1.381
#> 1001    8726520   St. Petersburg 1947-03-01 1947     3   1.798 1.518 1.411
#> 1002    8726520   St. Petersburg 1947-04-01 1947     4   1.707 1.542 1.439
#> 1003    8726520   St. Petersburg 1947-05-01 1947     5   2.042 1.646 1.545
#> 1004    8726520   St. Petersburg 1947-06-01 1947     6   1.951 1.725 1.588
#> 1005    8726520   St. Petersburg 1947-07-01 1947     7   1.890 1.655 1.521
#> 1006    8726520   St. Petersburg 1947-08-01 1947     8   2.012 1.695 1.576
#> 1007    8726520   St. Petersburg 1947-09-01 1947     9      NA 1.597 1.494
#> 1008    8726520   St. Petersburg 1947-10-01 1947    10      NA 1.728 1.649
#> 1009    8726520   St. Petersburg 1947-11-01 1947    11      NA 1.740 1.643
#> 1010    8726520   St. Petersburg 1947-12-01 1947    12      NA 1.710 1.573
#> 1011    8726520   St. Petersburg 1948-01-01 1948     1   1.829 1.567 1.439
#> 1012    8726520   St. Petersburg 1948-02-01 1948     2   1.798 1.594 1.463
#> 1013    8726520   St. Petersburg 1948-03-01 1948     3   2.012 1.740 1.634
#> 1014    8726520   St. Petersburg 1948-04-01 1948     4   2.012 1.676 1.558
#> 1015    8726520   St. Petersburg 1948-05-01 1948     5   1.829 1.679 1.579
#> 1016    8726520   St. Petersburg 1948-06-01 1948     6   1.951 1.716 1.585
#> 1017    8726520   St. Petersburg 1948-07-01 1948     7   1.920 1.725 1.597
#> 1018    8726520   St. Petersburg 1948-08-01 1948     8   1.951 1.713 1.600
#> 1019    8726520   St. Petersburg 1948-09-01 1948     9   2.012 1.725 1.615
#> 1020    8726520   St. Petersburg 1948-10-01 1948    10   1.920 1.689 1.628
#> 1021    8726520   St. Petersburg 1948-11-01 1948    11   1.890 1.676 1.576
#> 1022    8726520   St. Petersburg 1948-12-01 1948    12   2.012 1.612 1.463
#> 1023    8726520   St. Petersburg 1949-01-01 1949     1   1.768 1.567 1.420
#> 1024    8726520   St. Petersburg 1949-02-01 1949     2   1.737 1.545 1.423
#> 1025    8726520   St. Petersburg 1949-03-01 1949     3   1.859 1.548 1.433
#> 1026    8726520   St. Petersburg 1949-04-01 1949     4   1.951 1.600 1.472
#> 1027    8726520   St. Petersburg 1949-05-01 1949     5   1.798 1.625 1.497
#> 1028    8726520   St. Petersburg 1949-06-01 1949     6   1.890 1.710 1.570
#> 1029    8726520   St. Petersburg 1949-07-01 1949     7   1.920 1.692 1.561
#> 1030    8726520   St. Petersburg 1949-08-01 1949     8   2.134 1.750 1.591
#> 1031    8726520   St. Petersburg 1949-09-01 1949     9   1.920 1.759 1.658
#> 1032    8726520   St. Petersburg 1949-10-01 1949    10   2.012 1.753 1.682
#> 1033    8726520   St. Petersburg 1949-11-01 1949    11   1.890 1.609 1.500
#> 1034    8726520   St. Petersburg 1949-12-01 1949    12   1.768 1.536 1.402
#> 1035    8726520   St. Petersburg 1950-01-01 1950     1   1.951 1.643 1.503
#> 1036    8726520   St. Petersburg 1950-02-01 1950     2   1.920 1.567 1.439
#> 1037    8726520   St. Petersburg 1950-03-01 1950     3   1.798 1.539 1.411
#> 1038    8726520   St. Petersburg 1950-04-01 1950     4   1.768 1.573 1.472
#> 1039    8726520   St. Petersburg 1950-05-01 1950     5   1.890 1.646 1.518
#> 1040    8726520   St. Petersburg 1950-06-01 1950     6   1.859 1.649 1.503
#> 1041    8726520   St. Petersburg 1950-07-01 1950     7   1.890 1.689 1.527
#> 1042    8726520   St. Petersburg 1950-08-01 1950     8   2.012 1.734 1.612
#> 1043    8726520   St. Petersburg 1950-09-01 1950     9   2.560 1.771 1.646
#> 1044    8726520   St. Petersburg 1950-10-01 1950    10   1.920 1.655 1.570
#> 1045    8726520   St. Petersburg 1950-11-01 1950    11   1.859 1.640 1.518
#> 1046    8726520   St. Petersburg 1950-12-01 1950    12   1.951 1.622 1.475
#> 1047    8726520   St. Petersburg 1951-01-01 1951     1   1.768 1.554 1.408
#> 1048    8726520   St. Petersburg 1951-02-01 1951     2   1.829 1.533 1.390
#> 1049    8726520   St. Petersburg 1951-03-01 1951     3   1.859 1.591 1.469
#> 1050    8726520   St. Petersburg 1951-04-01 1951     4   1.737 1.561 1.454
#> 1051    8726520   St. Petersburg 1951-05-01 1951     5   1.890 1.573 1.463
#> 1052    8726520   St. Petersburg 1951-06-01 1951     6   1.920 1.679 1.533
#> 1053    8726520   St. Petersburg 1951-07-01 1951     7   1.920 1.686 1.530
#> 1054    8726520   St. Petersburg 1951-08-01 1951     8   1.920 1.695 1.554
#> 1055    8726520   St. Petersburg 1951-09-01 1951     9   1.890 1.710 1.609
#> 1056    8726520   St. Petersburg 1951-10-01 1951    10   1.890 1.643 1.567
#> 1057    8726520   St. Petersburg 1951-11-01 1951    11   2.195 1.643 1.497
#> 1058    8726520   St. Petersburg 1951-12-01 1951    12   1.859 1.618 1.490
#> 1059    8726520   St. Petersburg 1952-01-01 1952     1   1.829 1.554 1.426
#> 1060    8726520   St. Petersburg 1952-02-01 1952     2   1.859 1.573 1.433
#> 1061    8726520   St. Petersburg 1952-03-01 1952     3   1.890 1.582 1.460
#> 1062    8726520   St. Petersburg 1952-04-01 1952     4   1.920 1.551 1.430
#> 1063    8726520   St. Petersburg 1952-05-01 1952     5   1.859 1.618 1.515
#> 1064    8726520   St. Petersburg 1952-06-01 1952     6   1.890 1.625 1.497
#> 1065    8726520   St. Petersburg 1952-07-01 1952     7      NA    NA    NA
#> 1066    8726520   St. Petersburg 1952-08-01 1952     8      NA    NA    NA
#> 1067    8726520   St. Petersburg 1952-09-01 1952     9      NA    NA    NA
#> 1068    8726520   St. Petersburg 1952-10-01 1952    10      NA    NA    NA
#> 1069    8726520   St. Petersburg 1952-11-01 1952    11      NA    NA    NA
#> 1070    8726520   St. Petersburg 1952-12-01 1952    12   1.981 1.658 1.515
#> 1071    8726520   St. Petersburg 1953-01-01 1953     1      NA 1.594 1.448
#> 1072    8726520   St. Petersburg 1953-02-01 1953     2      NA 1.573 1.426
#> 1073    8726520   St. Petersburg 1953-03-01 1953     3      NA 1.558 1.445
#> 1074    8726520   St. Petersburg 1953-04-01 1953     4      NA 1.597 1.478
#> 1075    8726520   St. Petersburg 1953-05-01 1953     5      NA 1.643 1.506
#> 1076    8726520   St. Petersburg 1953-06-01 1953     6      NA 1.734 1.585
#> 1077    8726520   St. Petersburg 1953-07-01 1953     7      NA 1.625 1.497
#> 1078    8726520   St. Petersburg 1953-08-01 1953     8      NA 1.667 1.548
#> 1079    8726520   St. Petersburg 1953-09-01 1953     9   2.256 1.743 1.643
#> 1080    8726520   St. Petersburg 1953-10-01 1953    10   1.951 1.646 1.548
#> 1081    8726520   St. Petersburg 1953-11-01 1953    11   1.981 1.609 1.494
#> 1082    8726520   St. Petersburg 1953-12-01 1953    12   1.890 1.603 1.454
#> 1083    8726520   St. Petersburg 1954-01-01 1954     1   1.798 1.582 1.433
#> 1084    8726520   St. Petersburg 1954-02-01 1954     2   1.859 1.585 1.454
#> 1085    8726520   St. Petersburg 1954-03-01 1954     3   1.707 1.503 1.381
#> 1086    8726520   St. Petersburg 1954-04-01 1954     4   1.768 1.603 1.487
#> 1087    8726520   St. Petersburg 1954-05-01 1954     5   1.920 1.686 1.558
#> 1088    8726520   St. Petersburg 1954-06-01 1954     6   1.890 1.664 1.515
#> 1089    8726520   St. Petersburg 1954-07-01 1954     7   1.798 1.664 1.512
#> 1090    8726520   St. Petersburg 1954-08-01 1954     8   1.798 1.652 1.542
#> 1091    8726520   St. Petersburg 1954-09-01 1954     9   1.890 1.713 1.618
#> 1092    8726520   St. Petersburg 1954-10-01 1954    10   1.920 1.582 1.494
#> 1093    8726520   St. Petersburg 1954-11-01 1954    11   1.829 1.603 1.475
#> 1094    8726520   St. Petersburg 1954-12-01 1954    12   1.890 1.509 1.366
#> 1095    8726520   St. Petersburg 1955-01-01 1955     1   1.951 1.558 1.414
#> 1096    8726520   St. Petersburg 1955-02-01 1955     2   1.798 1.503 1.372
#> 1097    8726520   St. Petersburg 1955-03-01 1955     3   1.707 1.466 1.366
#> 1098    8726520   St. Petersburg 1955-04-01 1955     4   1.920 1.561 1.457
#> 1099    8726520   St. Petersburg 1955-05-01 1955     5   1.890 1.600 1.481
#> 1100    8726520   St. Petersburg 1955-06-01 1955     6   1.981 1.686 1.545
#> 1101    8726520   St. Petersburg 1955-07-01 1955     7   1.859 1.695 1.561
#> 1102    8726520   St. Petersburg 1955-08-01 1955     8   1.829 1.682 1.567
#> 1103    8726520   St. Petersburg 1955-09-01 1955     9   1.829 1.682 1.594
#> 1104    8726520   St. Petersburg 1955-10-01 1955    10   1.890 1.634 1.558
#> 1105    8726520   St. Petersburg 1955-11-01 1955    11   1.951 1.631 1.500
#> 1106    8726520   St. Petersburg 1955-12-01 1955    12   1.768 1.533 1.402
#> 1107    8726520   St. Petersburg 1956-01-01 1956     1   1.920 1.542 1.408
#> 1108    8726520   St. Petersburg 1956-02-01 1956     2   1.798 1.527 1.402
#> 1109    8726520   St. Petersburg 1956-03-01 1956     3   1.737 1.506 1.384
#> 1110    8726520   St. Petersburg 1956-04-01 1956     4   1.920 1.551 1.439
#> 1111    8726520   St. Petersburg 1956-05-01 1956     5   1.768 1.548 1.426
#> 1112    8726520   St. Petersburg 1956-06-01 1956     6   1.768 1.585 1.472
#> 1113    8726520   St. Petersburg 1956-07-01 1956     7   1.859 1.585 1.457
#> 1114    8726520   St. Petersburg 1956-08-01 1956     8   1.829 1.661 1.545
#> 1115    8726520   St. Petersburg 1956-09-01 1956     9   2.103 1.670 1.579
#> 1116    8726520   St. Petersburg 1956-10-01 1956    10   1.920 1.591 1.512
#> 1117    8726520   St. Petersburg 1956-11-01 1956    11   1.768 1.594 1.487
#> 1118    8726520   St. Petersburg 1956-12-01 1956    12   1.707 1.494 1.359
#> 1119    8726520   St. Petersburg 1957-01-01 1957     1   1.768 1.457 1.329
#> 1120    8726520   St. Petersburg 1957-02-01 1957     2   1.676 1.545 1.426
#> 1121    8726520   St. Petersburg 1957-03-01 1957     3   1.737 1.536 1.460
#> 1122    8726520   St. Petersburg 1957-04-01 1957     4   1.798 1.561 1.457
#> 1123    8726520   St. Petersburg 1957-05-01 1957     5   1.859 1.676 1.564
#> 1124    8726520   St. Petersburg 1957-06-01 1957     6   2.195 1.762 1.634
#> 1125    8726520   St. Petersburg 1957-07-01 1957     7   1.890 1.743 1.628
#> 1126    8726520   St. Petersburg 1957-08-01 1957     8   1.951 1.756 1.652
#> 1127    8726520   St. Petersburg 1957-09-01 1957     9   2.012 1.740 1.658
#> 1128    8726520   St. Petersburg 1957-10-01 1957    10   1.981 1.664 1.609
#> 1129    8726520   St. Petersburg 1957-11-01 1957    11   1.890 1.682 1.588
#> 1130    8726520   St. Petersburg 1957-12-01 1957    12   1.890 1.542 1.396
#> 1131    8726520   St. Petersburg 1958-01-01 1958     1   2.134 1.524 1.384
#> 1132    8726520   St. Petersburg 1958-02-01 1958     2   1.646 1.417 1.323
#> 1133    8726520   St. Petersburg 1958-03-01 1958     3   1.798 1.539 1.454
#> 1134    8726520   St. Petersburg 1958-04-01 1958     4   1.890 1.594 1.503
#> 1135    8726520   St. Petersburg 1958-05-01 1958     5   1.829 1.597 1.481
#> 1136    8726520   St. Petersburg 1958-06-01 1958     6   1.859 1.707 1.579
#> 1137    8726520   St. Petersburg 1958-07-01 1958     7   1.829 1.664 1.542
#> 1138    8726520   St. Petersburg 1958-08-01 1958     8   1.859 1.670 1.567
#> 1139    8726520   St. Petersburg 1958-09-01 1958     9   1.890 1.692 1.631
#> 1140    8726520   St. Petersburg 1958-10-01 1958    10   2.042 1.716 1.628
#> 1141    8726520   St. Petersburg 1958-11-01 1958    11   1.859 1.676 1.573
#> 1142    8726520   St. Petersburg 1958-12-01 1958    12   1.798 1.564 1.445
#> 1143    8726520   St. Petersburg 1959-01-01 1959     1   1.951 1.561 1.420
#> 1144    8726520   St. Petersburg 1959-02-01 1959     2   1.951 1.548 1.430
#> 1145    8726520   St. Petersburg 1959-03-01 1959     3   1.920 1.576 1.478
#> 1146    8726520   St. Petersburg 1959-04-01 1959     4   1.768 1.594 1.500
#> 1147    8726520   St. Petersburg 1959-05-01 1959     5   1.798 1.637 1.536
#> 1148    8726520   St. Petersburg 1959-06-01 1959     6   2.195 1.722 1.612
#> 1149    8726520   St. Petersburg 1959-07-01 1959     7   1.890 1.710 1.594
#> 1150    8726520   St. Petersburg 1959-08-01 1959     8   1.951 1.716 1.609
#> 1151    8726520   St. Petersburg 1959-09-01 1959     9   1.951 1.722 1.646
#> 1152    8726520   St. Petersburg 1959-10-01 1959    10   1.920 1.731 1.676
#> 1153    8726520   St. Petersburg 1959-11-01 1959    11   2.012 1.591 1.521
#> 1154    8726520   St. Petersburg 1959-12-01 1959    12   1.951 1.603 1.469
#> 1155    8726520   St. Petersburg 1960-01-01 1960     1   1.829 1.615 1.475
#> 1156    8726520   St. Petersburg 1960-02-01 1960     2   1.859 1.542 1.445
#> 1157    8726520   St. Petersburg 1960-03-01 1960     3   1.798 1.509 1.426
#> 1158    8726520   St. Petersburg 1960-04-01 1960     4   1.798 1.564 1.469
#> 1159    8726520   St. Petersburg 1960-05-01 1960     5   1.798 1.606 1.518
#> 1160    8726520   St. Petersburg 1960-06-01 1960     6   1.829 1.704 1.582
#> 1161    8726520   St. Petersburg 1960-07-01 1960     7   2.256 1.798 1.664
#> 1162    8726520   St. Petersburg 1960-08-01 1960     8   1.920 1.740 1.634
#> 1163    8726520   St. Petersburg 1960-09-01 1960     9   1.859 1.722 1.634
#> 1164    8726520   St. Petersburg 1960-10-01 1960    10   1.890 1.719 1.649
#> 1165    8726520   St. Petersburg 1960-11-01 1960    11   1.859 1.591 1.506
#> 1166    8726520   St. Petersburg 1960-12-01 1960    12   2.073 1.554 1.433
#> 1167    8726520   St. Petersburg 1961-01-01 1961     1   1.829 1.494 1.366
#> 1168    8726520   St. Petersburg 1961-02-01 1961     2   1.737 1.539 1.436
#> 1169    8726520   St. Petersburg 1961-03-01 1961     3   1.829 1.591 1.524
#> 1170    8726520   St. Petersburg 1961-04-01 1961     4   1.859 1.582 1.490
#> 1171    8726520   St. Petersburg 1961-05-01 1961     5   1.890 1.622 1.518
#> 1172    8726520   St. Petersburg 1961-06-01 1961     6   1.829 1.652 1.521
#> 1173    8726520   St. Petersburg 1961-07-01 1961     7   1.920 1.704 1.582
#> 1174    8726520   St. Petersburg 1961-08-01 1961     8   1.859 1.716 1.615
#> 1175    8726520   St. Petersburg 1961-09-01 1961     9   1.890 1.701 1.622
#> 1176    8726520   St. Petersburg 1961-10-01 1961    10   1.829 1.615 1.561
#> 1177    8726520   St. Petersburg 1961-11-01 1961    11   1.981 1.646 1.573
#> 1178    8726520   St. Petersburg 1961-12-01 1961    12   1.859 1.606 1.481
#> 1179    8726520   St. Petersburg 1962-01-01 1962     1   1.798 1.457 1.375
#> 1180    8726520   St. Petersburg 1962-02-01 1962     2   1.737 1.545 1.454
#> 1181    8726520   St. Petersburg 1962-03-01 1962     3   1.951 1.582 1.545
#> 1182    8726520   St. Petersburg 1962-04-01 1962     4   1.768 1.500 1.439
#> 1183    8726520   St. Petersburg 1962-05-01 1962     5   1.768 1.600 1.506
#> 1184    8726520   St. Petersburg 1962-06-01 1962     6   1.920 1.686 1.573
#> 1185    8726520   St. Petersburg 1962-07-01 1962     7   1.829 1.701 1.573
#> 1186    8726520   St. Petersburg 1962-08-01 1962     8   1.890 1.737 1.628
#> 1187    8726520   St. Petersburg 1962-09-01 1962     9   1.890 1.747 1.670
#> 1188    8726520   St. Petersburg 1962-10-01 1962    10   1.951 1.664 1.600
#> 1189    8726520   St. Petersburg 1962-11-01 1962    11   1.890 1.612 1.518
#> 1190    8726520   St. Petersburg 1962-12-01 1962    12   2.012 1.615 1.481
#> 1191    8726520   St. Petersburg 1963-01-01 1963     1   1.981 1.591 1.500
#> 1192    8726520   St. Petersburg 1963-02-01 1963     2   1.798 1.533 1.484
#> 1193    8726520   St. Petersburg 1963-03-01 1963     3   1.798 1.536 1.506
#> 1194    8726520   St. Petersburg 1963-04-01 1963     4   1.768 1.582 1.527
#> 1195    8726520   St. Petersburg 1963-05-01 1963     5   1.829 1.573 1.490
#> 1196    8726520   St. Petersburg 1963-06-01 1963     6   1.859 1.640 1.545
#> 1197    8726520   St. Petersburg 1963-07-01 1963     7   1.920 1.661 1.558
#> 1198    8726520   St. Petersburg 1963-08-01 1963     8   1.829 1.667 1.567
#> 1199    8726520   St. Petersburg 1963-09-01 1963     9   2.408 1.725 1.628
#> 1200    8726520   St. Petersburg 1963-10-01 1963    10   1.798 1.606 1.542
#> 1201    8726520   St. Petersburg 1963-11-01 1963    11   2.012 1.625 1.564
#> 1202    8726520   St. Petersburg 1963-12-01 1963    12   1.798 1.500 1.396
#> 1203    8726520   St. Petersburg 1964-01-01 1964     1   1.798 1.478 1.369
#> 1204    8726520   St. Petersburg 1964-02-01 1964     2   1.829 1.475 1.396
#> 1205    8726520   St. Petersburg 1964-03-01 1964     3   1.676 1.454 1.390
#> 1206    8726520   St. Petersburg 1964-04-01 1964     4   1.798 1.527 1.436
#> 1207    8726520   St. Petersburg 1964-05-01 1964     5   1.859 1.603 1.512
#> 1208    8726520   St. Petersburg 1964-06-01 1964     6   1.798 1.646 1.533
#> 1209    8726520   St. Petersburg 1964-07-01 1964     7   1.859 1.640 1.515
#> 1210    8726520   St. Petersburg 1964-08-01 1964     8   1.829 1.673 1.570
#> 1211    8726520   St. Petersburg 1964-09-01 1964     9   1.981 1.722 1.652
#> 1212    8726520   St. Petersburg 1964-10-01 1964    10   1.859 1.622 1.551
#> 1213    8726520   St. Petersburg 1964-11-01 1964    11   1.981 1.594 1.515
#> 1214    8726520   St. Petersburg 1964-12-01 1964    12   1.859 1.548 1.442
#> 1215    8726520   St. Petersburg 1965-01-01 1965     1      NA 1.558 1.494
#> 1216    8726520   St. Petersburg 1965-02-01 1965     2      NA 1.527 1.472
#> 1217    8726520   St. Petersburg 1965-03-01 1965     3   1.829 1.503 1.451
#> 1218    8726520   St. Petersburg 1965-04-01 1965     4   1.707 1.545 1.487
#> 1219    8726520   St. Petersburg 1965-05-01 1965     5   1.798 1.618 1.533
#> 1220    8726520   St. Petersburg 1965-06-01 1965     6   1.981 1.704 1.603
#> 1221    8726520   St. Petersburg 1965-07-01 1965     7   2.134 1.701 1.603
#> 1222    8726520   St. Petersburg 1965-08-01 1965     8   1.981 1.765 1.689
#> 1223    8726520   St. Petersburg 1965-09-01 1965     9   2.377 1.762 1.704
#> 1224    8726520   St. Petersburg 1965-10-01 1965    10   1.981 1.695 1.643
#> 1225    8726520   St. Petersburg 1965-11-01 1965    11   1.920 1.676 1.609
#> 1226    8726520   St. Petersburg 1965-12-01 1965    12   1.829 1.564 1.481
#> 1227    8726520   St. Petersburg 1966-01-01 1966     1   1.890 1.625 1.539
#> 1228    8726520   St. Petersburg 1966-02-01 1966     2   1.890 1.579 1.497
#> 1229    8726520   St. Petersburg 1966-03-01 1966     3   1.890 1.545 1.469
#> 1230    8726520   St. Petersburg 1966-04-01 1966     4   1.798 1.600 1.536
#> 1231    8726520   St. Petersburg 1966-05-01 1966     5   2.042 1.719 1.655
#> 1232    8726520   St. Petersburg 1966-06-01 1966     6   2.225 1.682 1.585
#> 1233    8726520   St. Petersburg 1966-07-01 1966     7   1.951 1.710 1.634
#> 1234    8726520   St. Petersburg 1966-08-01 1966     8   1.920 1.728 1.634
#> 1235    8726520   St. Petersburg 1966-09-01 1966     9   1.981 1.771 1.701
#> 1236    8726520   St. Petersburg 1966-10-01 1966    10   1.890 1.676 1.612
#> 1237    8726520   St. Petersburg 1966-11-01 1966    11   2.042 1.591 1.539
#> 1238    8726520   St. Petersburg 1966-12-01 1966    12   1.920 1.622 1.551
#> 1239    8726520   St. Petersburg 1967-01-01 1967     1   1.859 1.585 1.515
#> 1240    8726520   St. Petersburg 1967-02-01 1967     2   2.012 1.594 1.463
#> 1241    8726520   St. Petersburg 1967-03-01 1967     3   1.859 1.539 1.490
#> 1242    8726520   St. Petersburg 1967-04-01 1967     4   1.859 1.661 1.600
#> 1243    8726520   St. Petersburg 1967-05-01 1967     5   2.042 1.698 1.643
#> 1244    8726520   St. Petersburg 1967-06-01 1967     6   1.981 1.756 1.673
#> 1245    8726520   St. Petersburg 1967-07-01 1967     7   1.890 1.743 1.658
#> 1246    8726520   St. Petersburg 1967-08-01 1967     8   1.981 1.783 1.719
#> 1247    8726520   St. Petersburg 1967-09-01 1967     9   2.012 1.728 1.655
#> 1248    8726520   St. Petersburg 1967-10-01 1967    10   1.890 1.634 1.570
#> 1249    8726520   St. Petersburg 1967-11-01 1967    11   1.920 1.628 1.564
#> 1250    8726520   St. Petersburg 1967-12-01 1967    12   1.890 1.716 1.637
#> 1251    8726520   St. Petersburg 1968-01-01 1968     1   1.890 1.579 1.475
#> 1252    8726520   St. Petersburg 1968-02-01 1968     2   1.768 1.539 1.445
#> 1253    8726520   St. Petersburg 1968-03-01 1968     3   1.798 1.515 1.426
#> 1254    8726520   St. Petersburg 1968-04-01 1968     4   1.768 1.612 1.527
#> 1255    8726520   St. Petersburg 1968-05-01 1968     5   1.798 1.600 1.527
#> 1256    8726520   St. Petersburg 1968-06-01 1968     6   1.890 1.637 1.554
#> 1257    8726520   St. Petersburg 1968-07-01 1968     7   2.042 1.713 1.658
#> 1258    8726520   St. Petersburg 1968-08-01 1968     8      NA 1.753 1.692
#> 1259    8726520   St. Petersburg 1968-09-01 1968     9   1.981 1.747 1.670
#> 1260    8726520   St. Petersburg 1968-10-01 1968    10   2.469 1.704 1.649
#> 1261    8726520   St. Petersburg 1968-11-01 1968    11   1.951 1.640 1.567
#> 1262    8726520   St. Petersburg 1968-12-01 1968    12   1.859 1.576 1.484
#> 1263    8726520   St. Petersburg 1969-01-01 1969     1   1.920 1.588 1.509
#> 1264    8726520   St. Petersburg 1969-02-01 1969     2   2.012 1.597 1.533
#> 1265    8726520   St. Petersburg 1969-03-01 1969     3   1.981 1.591 1.530
#> 1266    8726520   St. Petersburg 1969-04-01 1969     4   1.798 1.567 1.527
#> 1267    8726520   St. Petersburg 1969-05-01 1969     5   1.829 1.603 1.518
#> 1268    8726520   St. Petersburg 1969-06-01 1969     6   1.920 1.743 1.673
#> 1269    8726520   St. Petersburg 1969-07-01 1969     7   1.951 1.710 1.612
#> 1270    8726520   St. Petersburg 1969-08-01 1969     8   1.920 1.750 1.655
#> 1271    8726520   St. Petersburg 1969-09-01 1969     9   1.829 1.679 1.615
#> 1272    8726520   St. Petersburg 1969-10-01 1969    10   1.951 1.698 1.637
#> 1273    8726520   St. Petersburg 1969-11-01 1969    11      NA 1.634 1.573
#> 1274    8726520   St. Petersburg 1969-12-01 1969    12      NA 1.615 1.542
#> 1275    8726520   St. Petersburg 1970-01-01 1970     1   1.859 1.527 1.448
#> 1276    8726520   St. Petersburg 1970-02-01 1970     2   1.981 1.518 1.426
#> 1277    8726520   St. Petersburg 1970-03-01 1970     3   1.859 1.652 1.582
#> 1278    8726520   St. Petersburg 1970-04-01 1970     4   1.829 1.637 1.588
#> 1279    8726520   St. Petersburg 1970-05-01 1970     5   1.951 1.707 1.640
#> 1280    8726520   St. Petersburg 1970-06-01 1970     6   2.012 1.750 1.646
#> 1281    8726520   St. Petersburg 1970-07-01 1970     7   1.920 1.737 1.652
#> 1282    8726520   St. Petersburg 1970-08-01 1970     8   1.920 1.807 1.710
#> 1283    8726520   St. Petersburg 1970-09-01 1970     9   1.859 1.740 1.664
#> 1284    8726520   St. Petersburg 1970-10-01 1970    10   2.134 1.759 1.686
#> 1285    8726520   St. Petersburg 1970-11-01 1970    11   1.890 1.603 1.530
#> 1286    8726520   St. Petersburg 1970-12-01 1970    12   1.890 1.612 1.530
#> 1287    8726520   St. Petersburg 1971-01-01 1971     1   1.829 1.515 1.436
#> 1288    8726520   St. Petersburg 1971-02-01 1971     2   1.768 1.561 1.451
#> 1289    8726520   St. Petersburg 1971-03-01 1971     3   2.012 1.527 1.451
#> 1290    8726520   St. Petersburg 1971-04-01 1971     4   1.768 1.539 1.451
#> 1291    8726520   St. Petersburg 1971-05-01 1971     5   1.951 1.597 1.512
#> 1292    8726520   St. Petersburg 1971-06-01 1971     6   1.829 1.634 1.527
#> 1293    8726520   St. Petersburg 1971-07-01 1971     7      NA 1.637 1.545
#> 1294    8726520   St. Petersburg 1971-08-01 1971     8   1.920 1.716 1.655
#> 1295    8726520   St. Petersburg 1971-09-01 1971     9   1.859 1.710 1.707
#> 1296    8726520   St. Petersburg 1971-10-01 1971    10   2.012 1.759 1.753
#> 1297    8726520   St. Petersburg 1971-11-01 1971    11   1.981 1.780 1.753
#> 1298    8726520   St. Petersburg 1971-12-01 1971    12   1.981 1.707 1.682
#> 1299    8726520   St. Petersburg 1972-01-01 1972     1   1.859 1.652 1.530
#> 1300    8726520   St. Petersburg 1972-02-01 1972     2   1.951 1.585 1.478
#> 1301    8726520   St. Petersburg 1972-03-01 1972     3   1.920 1.634 1.576
#> 1302    8726520   St. Petersburg 1972-04-01 1972     4   1.890 1.622 1.521
#> 1303    8726520   St. Petersburg 1972-05-01 1972     5   2.012 1.737 1.661
#> 1304    8726520   St. Petersburg 1972-06-01 1972     6   1.951 1.835 1.728
#> 1305    8726520   St. Petersburg 1972-07-01 1972     7   1.951 1.734 1.640
#> 1306    8726520   St. Petersburg 1972-08-01 1972     8   1.920 1.734 1.643
#> 1307    8726520   St. Petersburg 1972-09-01 1972     9   1.859 1.747 1.686
#> 1308    8726520   St. Petersburg 1972-10-01 1972    10   2.012 1.710 1.649
#> 1309    8726520   St. Petersburg 1972-11-01 1972    11   2.042 1.725 1.640
#> 1310    8726520   St. Petersburg 1972-12-01 1972    12   2.225 1.646 1.573
#> 1311    8726520   St. Petersburg 1973-01-01 1973     1      NA 1.670 1.558
#> 1312    8726520   St. Petersburg 1973-02-01 1973     2   1.957 1.625 1.533
#> 1313    8726520   St. Petersburg 1973-03-01 1973     3   2.042 1.719 1.640
#> 1314    8726520   St. Petersburg 1973-04-01 1973     4   2.210 1.698 1.634
#> 1315    8726520   St. Petersburg 1973-05-01 1973     5   1.881 1.719 1.618
#> 1316    8726520   St. Petersburg 1973-06-01 1973     6   1.917 1.728 1.631
#> 1317    8726520   St. Petersburg 1973-07-01 1973     7   1.893 1.728 1.618
#> 1318    8726520   St. Petersburg 1973-08-01 1973     8   1.929 1.747 1.661
#> 1319    8726520   St. Petersburg 1973-09-01 1973     9   1.929 1.768 1.698
#> 1320    8726520   St. Petersburg 1973-10-01 1973    10   1.990 1.716 1.649
#> 1321    8726520   St. Petersburg 1973-11-01 1973    11   1.978 1.734 1.664
#> 1322    8726520   St. Petersburg 1973-12-01 1973    12   1.896 1.615 1.579
#> 1323    8726520   St. Petersburg 1974-01-01 1974     1   1.856 1.643 1.545
#> 1324    8726520   St. Petersburg 1974-02-01 1974     2   1.899 1.585 1.494
#> 1325    8726520   St. Petersburg 1974-03-01 1974     3   1.850 1.582 1.524
#> 1326    8726520   St. Petersburg 1974-04-01 1974     4   1.808 1.594 1.506
#> 1327    8726520   St. Petersburg 1974-05-01 1974     5   2.009 1.686 1.600
#> 1328    8726520   St. Petersburg 1974-06-01 1974     6   2.307 1.792 1.676
#> 1329    8726520   St. Petersburg 1974-07-01 1974     7   1.878 1.740 1.637
#> 1330    8726520   St. Petersburg 1974-08-01 1974     8   1.905 1.728 1.631
#> 1331    8726520   St. Petersburg 1974-09-01 1974     9   1.966 1.789 1.716
#> 1332    8726520   St. Petersburg 1974-10-01 1974    10   1.929 1.673 1.625
#> 1333    8726520   St. Petersburg 1974-11-01 1974    11   1.853 1.646 1.551
#> 1334    8726520   St. Petersburg 1974-12-01 1974    12   1.981 1.634 1.506
#> 1335    8726520   St. Petersburg 1975-01-01 1975     1   1.923 1.582 1.469
#> 1336    8726520   St. Petersburg 1975-02-01 1975     2   1.923 1.643 1.551
#> 1337    8726520   St. Petersburg 1975-03-01 1975     3   1.832 1.622 1.524
#> 1338    8726520   St. Petersburg 1975-04-01 1975     4   1.908 1.637 1.521
#> 1339    8726520   St. Petersburg 1975-05-01 1975     5   1.914 1.713 1.603
#> 1340    8726520   St. Petersburg 1975-06-01 1975     6   1.862 1.710 1.597
#> 1341    8726520   St. Petersburg 1975-07-01 1975     7   2.039 1.792 1.673
#> 1342    8726520   St. Petersburg 1975-08-01 1975     8   1.890 1.768 1.661
#> 1343    8726520   St. Petersburg 1975-09-01 1975     9   2.112 1.811 1.722
#> 1344    8726520   St. Petersburg 1975-10-01 1975    10   1.981 1.670 1.603
#> 1345    8726520   St. Petersburg 1975-11-01 1975    11   1.884 1.661 1.564
#> 1346    8726520   St. Petersburg 1975-12-01 1975    12      NA 1.673 1.545
#> 1347    8726520   St. Petersburg 1976-01-01 1976     1   1.762 1.484 1.350
#> 1348    8726520   St. Petersburg 1976-02-01 1976     2   1.832 1.478 1.356
#> 1349    8726520   St. Petersburg 1976-03-01 1976     3   1.759 1.539 1.448
#> 1350    8726520   St. Petersburg 1976-04-01 1976     4   1.871 1.631 1.530
#> 1351    8726520   St. Petersburg 1976-05-01 1976     5   2.143 1.722 1.588
#> 1352    8726520   St. Petersburg 1976-06-01 1976     6   1.893 1.737 1.609
#> 1353    8726520   St. Petersburg 1976-07-01 1976     7   1.856 1.701 1.588
#> 1354    8726520   St. Petersburg 1976-08-01 1976     8   1.859 1.682 1.567
#> 1355    8726520   St. Petersburg 1976-09-01 1976     9   1.841 1.725 1.634
#> 1356    8726520   St. Petersburg 1976-10-01 1976    10   1.960 1.612 1.533
#> 1357    8726520   St. Petersburg 1976-11-01 1976    11   1.902 1.551 1.454
#> 1358    8726520   St. Petersburg 1976-12-01 1976    12   1.984 1.591 1.460
#> 1359    8726520   St. Petersburg 1977-01-01 1977     1   1.859 1.530 1.390
#> 1360    8726520   St. Petersburg 1977-02-01 1977     2   1.646 1.445 1.335
#> 1361    8726520   St. Petersburg 1977-03-01 1977     3   1.676 1.536 1.436
#> 1362    8726520   St. Petersburg 1977-04-01 1977     4   1.798 1.500 1.423
#> 1363    8726520   St. Petersburg 1977-05-01 1977     5   1.768 1.634 1.533
#> 1364    8726520   St. Petersburg 1977-06-01 1977     6   1.981 1.713 1.594
#> 1365    8726520   St. Petersburg 1977-07-01 1977     7   1.890 1.707 1.573
#> 1366    8726520   St. Petersburg 1977-08-01 1977     8   1.890 1.725 1.634
#> 1367    8726520   St. Petersburg 1977-09-01 1977     9   1.920 1.789 1.716
#> 1368    8726520   St. Petersburg 1977-10-01 1977    10   1.829 1.637 1.570
#> 1369    8726520   St. Petersburg 1977-11-01 1977    11   1.829 1.664 1.579
#> 1370    8726520   St. Petersburg 1977-12-01 1977    12   1.829 1.579 1.481
#> 1371    8726520   St. Petersburg 1978-01-01 1978     1   2.091 1.484 1.378
#> 1372    8726520   St. Petersburg 1978-02-01 1978     2   1.826 1.515 1.411
#> 1373    8726520   St. Petersburg 1978-03-01 1978     3   1.820 1.527 1.451
#> 1374    8726520   St. Petersburg 1978-04-01 1978     4   1.844 1.594 1.512
#> 1375    8726520   St. Petersburg 1978-05-01 1978     5   2.109 1.658 1.558
#> 1376    8726520   St. Petersburg 1978-06-01 1978     6   1.935 1.686 1.567
#> 1377    8726520   St. Petersburg 1978-07-01 1978     7   1.914 1.719 1.597
#> 1378    8726520   St. Petersburg 1978-08-01 1978     8   1.771 1.695 1.588
#> 1379    8726520   St. Petersburg 1978-09-01 1978     9      NA 1.734 1.667
#> 1380    8726520   St. Petersburg 1978-10-01 1978    10   1.872 1.695 1.640
#> 1381    8726520   St. Petersburg 1978-11-01 1978    11   1.926 1.719 1.640
#> 1382    8726520   St. Petersburg 1978-12-01 1978    12   1.975 1.625 1.503
#> 1383    8726520   St. Petersburg 1979-01-01 1979     1   2.000 1.615 1.490
#> 1384    8726520   St. Petersburg 1979-02-01 1979     2   1.926 1.530 1.439
#> 1385    8726520   St. Petersburg 1979-03-01 1979     3   2.076 1.622 1.536
#> 1386    8726520   St. Petersburg 1979-04-01 1979     4   1.929 1.679 1.597
#> 1387    8726520   St. Petersburg 1979-05-01 1979     5   1.899 1.689 1.579
#> 1388    8726520   St. Petersburg 1979-06-01 1979     6   1.932 1.698 1.573
#> 1389    8726520   St. Petersburg 1979-07-01 1979     7   2.030 1.750 1.631
#> 1390    8726520   St. Petersburg 1979-08-01 1979     8   1.945 1.768 1.658
#> 1391    8726520   St. Petersburg 1979-09-01 1979     9   2.225 1.838 1.753
#> 1392    8726520   St. Petersburg 1979-10-01 1979    10   1.905 1.716 1.655
#> 1393    8726520   St. Petersburg 1979-11-01 1979    11   1.847 1.603 1.521
#> 1394    8726520   St. Petersburg 1979-12-01 1979    12   1.896 1.625 1.503
#> 1395    8726520   St. Petersburg 1980-01-01 1980     1   1.874 1.655 1.539
#> 1396    8726520   St. Petersburg 1980-02-01 1980     2   1.938 1.597 1.506
#> 1397    8726520   St. Petersburg 1980-03-01 1980     3   1.826 1.591 1.521
#> 1398    8726520   St. Petersburg 1980-04-01 1980     4   1.902 1.628 1.573
#> 1399    8726520   St. Petersburg 1980-05-01 1980     5   1.874 1.707 1.600
#> 1400    8726520   St. Petersburg 1980-06-01 1980     6   1.868 1.731 1.625
#> 1401    8726520   St. Petersburg 1980-07-01 1980     7   1.911 1.747 1.625
#> 1402    8726520   St. Petersburg 1980-08-01 1980     8   1.978 1.716 1.615
#> 1403    8726520   St. Petersburg 1980-09-01 1980     9   1.853 1.708 1.622
#> 1404    8726520   St. Petersburg 1980-10-01 1980    10   1.841 1.622 1.558
#> 1405    8726520   St. Petersburg 1980-11-01 1980    11   1.905 1.652 1.585
#> 1406    8726520   St. Petersburg 1980-12-01 1980    12   1.838 1.600 1.500
#> 1407    8726520   St. Petersburg 1981-01-01 1981     1   1.963 1.559 1.468
#> 1408    8726520   St. Petersburg 1981-02-01 1981     2   1.841 1.551 1.478
#> 1409    8726520   St. Petersburg 1981-03-01 1981     3   1.923 1.579 1.500
#> 1410    8726520   St. Petersburg 1981-04-01 1981     4   1.740 1.585 1.524
#> 1411    8726520   St. Petersburg 1981-05-01 1981     5   2.002 1.676 1.600
#> 1412    8726520   St. Petersburg 1981-06-01 1981     6   1.884 1.710 1.606
#> 1413    8726520   St. Petersburg 1981-07-01 1981     7   2.012 1.774 1.640
#> 1414    8726520   St. Petersburg 1981-08-01 1981     8   2.000 1.753 1.646
#> 1415    8726520   St. Petersburg 1981-09-01 1981     9   1.841 1.713 1.646
#> 1416    8726520   St. Petersburg 1981-10-01 1981    10   1.920 1.643 1.579
#> 1417    8726520   St. Petersburg 1981-11-01 1981    11   2.109 1.707 1.628
#> 1418    8726520   St. Petersburg 1981-12-01 1981    12   1.954 1.625 1.515
#> 1419    8726520   St. Petersburg 1982-01-01 1982     1   1.920 1.553 1.448
#> 1420    8726520   St. Petersburg 1982-02-01 1982     2   1.759 1.591 1.500
#> 1421    8726520   St. Petersburg 1982-03-01 1982     3   1.990 1.612 1.536
#> 1422    8726520   St. Petersburg 1982-04-01 1982     4   1.972 1.609 1.536
#> 1423    8726520   St. Petersburg 1982-05-01 1982     5   1.905 1.640 1.558
#> 1424    8726520   St. Petersburg 1982-06-01 1982     6   2.789 1.753 1.637
#> 1425    8726520   St. Petersburg 1982-07-01 1982     7   1.945 1.716 1.600
#> 1426    8726520   St. Petersburg 1982-08-01 1982     8   2.015 1.725 1.622
#> 1427    8726520   St. Petersburg 1982-09-01 1982     9   1.896 1.750 1.670
#> 1428    8726520   St. Petersburg 1982-10-01 1982    10   1.905 1.725 1.661
#> 1429    8726520   St. Petersburg 1982-11-01 1982    11   2.036 1.713 1.649
#> 1430    8726520   St. Petersburg 1982-12-01 1982    12   2.103 1.753 1.649
#> 1431    8726520   St. Petersburg 1983-01-01 1983     1   1.939 1.679 1.582
#> 1432    8726520   St. Petersburg 1983-02-01 1983     2   2.063 1.670 1.573
#> 1433    8726520   St. Petersburg 1983-03-01 1983     3   2.155 1.750 1.661
#> 1434    8726520   St. Petersburg 1983-04-01 1983     4   2.045 1.676 1.597
#> 1435    8726520   St. Petersburg 1983-05-01 1983     5   1.942 1.737 1.664
#> 1436    8726520   St. Petersburg 1983-06-01 1983     6   1.966 1.753 1.661
#> 1437    8726520   St. Petersburg 1983-07-01 1983     7   1.926 1.759 1.649
#> 1438    8726520   St. Petersburg 1983-08-01 1983     8   2.003 1.759 1.661
#> 1439    8726520   St. Petersburg 1983-09-01 1983     9   2.042 1.747 1.661
#> 1440    8726520   St. Petersburg 1983-10-01 1983    10   2.018 1.786 1.719
#> 1441    8726520   St. Petersburg 1983-11-01 1983    11   2.140 1.789 1.722
#> 1442    8726520   St. Petersburg 1983-12-01 1983    12   1.960 1.622 1.542
#> 1443    8726520   St. Petersburg 1984-01-01 1984     1   2.006 1.649 1.545
#> 1444    8726520   St. Petersburg 1984-02-01 1984     2   1.923 1.640 1.527
#> 1445    8726520   St. Petersburg 1984-03-01 1984     3   2.070 1.631 1.551
#> 1446    8726520   St. Petersburg 1984-04-01 1984     4   1.963 1.679 1.618
#> 1447    8726520   St. Petersburg 1984-05-01 1984     5   2.063 1.701 1.609
#> 1448    8726520   St. Petersburg 1984-06-01 1984     6   1.990 1.795 1.701
#> 1449    8726520   St. Petersburg 1984-07-01 1984     7   2.012 1.807 1.686
#> 1450    8726520   St. Petersburg 1984-08-01 1984     8   1.908 1.762 1.670
#> 1451    8726520   St. Petersburg 1984-09-01 1984     9   1.914 1.762 1.692
#> 1452    8726520   St. Petersburg 1984-10-01 1984    10   2.036 1.765 1.710
#> 1453    8726520   St. Petersburg 1984-11-01 1984    11   2.033 1.686 1.634
#> 1454    8726520   St. Petersburg 1984-12-01 1984    12   1.878 1.704 1.615
#> 1455    8726520   St. Petersburg 1985-01-01 1985     1   1.942 1.686 1.588
#> 1456    8726520   St. Petersburg 1985-02-01 1985     2   2.002 1.588 1.521
#> 1457    8726520   St. Petersburg 1985-03-01 1985     3   1.786 1.612 1.539
#> 1458    8726520   St. Petersburg 1985-04-01 1985     4   1.808 1.622 1.542
#> 1459    8726520   St. Petersburg 1985-05-01 1985     5   1.887 1.707 1.634
#> 1460    8726520   St. Petersburg 1985-06-01 1985     6   1.862 1.747 1.661
#> 1461    8726520   St. Petersburg 1985-07-01 1985     7   2.003 1.771 1.686
#> 1462    8726520   St. Petersburg 1985-08-01 1985     8   2.935 1.865 1.759
#> 1463    8726520   St. Petersburg 1985-09-01 1985     9   2.426 1.780 1.704
#> 1464    8726520   St. Petersburg 1985-10-01 1985    10   2.335 1.847 1.804
#> 1465    8726520   St. Petersburg 1985-11-01 1985    11   2.426 1.801 1.722
#> 1466    8726520   St. Petersburg 1985-12-01 1985    12   2.158 1.652 1.551
#> 1467    8726520   St. Petersburg 1986-01-01 1986     1   2.045 1.588 1.509
#> 1468    8726520   St. Petersburg 1986-02-01 1986     2   1.847 1.628 1.554
#> 1469    8726520   St. Petersburg 1986-03-01 1986     3   1.747 1.573 1.503
#> 1470    8726520   St. Petersburg 1986-04-01 1986     4   1.935 1.704 1.640
#> 1471    8726520   St. Petersburg 1986-05-01 1986     5   1.966 1.804 1.731
#> 1472    8726520   St. Petersburg 1986-06-01 1986     6   2.024 1.811 1.707
#> 1473    8726520   St. Petersburg 1986-07-01 1986     7   1.999 1.768 1.667
#> 1474    8726520   St. Petersburg 1986-08-01 1986     8   1.999 1.750 1.655
#> 1475    8726520   St. Petersburg 1986-09-01 1986     9   1.972 1.838 1.759
#> 1476    8726520   St. Petersburg 1986-10-01 1986    10   1.954 1.762 1.704
#> 1477    8726520   St. Petersburg 1986-11-01 1986    11   2.082 1.783 1.713
#> 1478    8726520   St. Petersburg 1986-12-01 1986    12   1.969 1.704 1.637
#> 1479    8726520   St. Petersburg 1987-01-01 1987     1   2.432 1.731 1.631
#> 1480    8726520   St. Petersburg 1987-02-01 1987     2   1.908 1.698 1.622
#> 1481    8726520   St. Petersburg 1987-03-01 1987     3   2.082 1.777 1.698
#> 1482    8726520   St. Petersburg 1987-04-01 1987     4   1.996 1.637 1.558
#> 1483    8726520   St. Petersburg 1987-05-01 1987     5   1.926 1.716 1.625
#> 1484    8726520   St. Petersburg 1987-06-01 1987     6   2.073 1.783 1.707
#> 1485    8726520   St. Petersburg 1987-07-01 1987     7   2.094 1.823 1.728
#> 1486    8726520   St. Petersburg 1987-08-01 1987     8   1.984 1.777 1.686
#> 1487    8726520   St. Petersburg 1987-09-01 1987     9   2.015 1.792 1.725
#> 1488    8726520   St. Petersburg 1987-10-01 1987    10   1.969 1.615 1.564
#> 1489    8726520   St. Petersburg 1987-11-01 1987    11   1.963 1.722 1.679
#> 1490    8726520   St. Petersburg 1987-12-01 1987    12   1.972 1.716 1.646
#> 1491    8726520   St. Petersburg 1988-01-01 1988     1   2.100 1.625 1.564
#> 1492    8726520   St. Petersburg 1988-02-01 1988     2   1.993 1.600 1.530
#> 1493    8726520   St. Petersburg 1988-03-01 1988     3   1.847 1.606 1.524
#> 1494    8726520   St. Petersburg 1988-04-01 1988     4   2.048 1.704 1.634
#> 1495    8726520   St. Petersburg 1988-05-01 1988     5   1.865 1.670 1.591
#> 1496    8726520   St. Petersburg 1988-06-01 1988     6   1.926 1.759 1.676
#> 1497    8726520   St. Petersburg 1988-07-01 1988     7   1.981 1.768 1.658
#> 1498    8726520   St. Petersburg 1988-08-01 1988     8   1.963 1.750 1.664
#> 1499    8726520   St. Petersburg 1988-09-01 1988     9   2.213 1.850 1.765
#> 1500    8726520   St. Petersburg 1988-10-01 1988    10   1.911 1.713 1.646
#> 1501    8726520   St. Petersburg 1988-11-01 1988    11   2.262 1.747 1.676
#> 1502    8726520   St. Petersburg 1988-12-01 1988    12   1.875 1.588 1.518
#> 1503    8726520   St. Petersburg 1989-01-01 1989     1   1.850 1.637 1.564
#> 1504    8726520   St. Petersburg 1989-02-01 1989     2   1.884 1.649 1.558
#> 1505    8726520   St. Petersburg 1989-03-01 1989     3   1.902 1.698 1.612
#> 1506    8726520   St. Petersburg 1989-04-01 1989     4   1.838 1.676 1.615
#> 1507    8726520   St. Petersburg 1989-05-01 1989     5   1.963 1.698 1.603
#> 1508    8726520   St. Petersburg 1989-06-01 1989     6   2.137 1.835 1.728
#> 1509    8726520   St. Petersburg 1989-07-01 1989     7   1.999 1.838 1.743
#> 1510    8726520   St. Petersburg 1989-08-01 1989     8   1.935 1.844 1.740
#> 1511    8726520   St. Petersburg 1989-09-01 1989     9   1.975 1.829 1.768
#> 1512    8726520   St. Petersburg 1989-10-01 1989    10   2.006 1.713 1.655
#> 1513    8726520   St. Petersburg 1989-11-01 1989    11   2.076 1.713 1.643
#> 1514    8726520   St. Petersburg 1989-12-01 1989    12   2.103 1.585 1.509
#> 1515    8726520   St. Petersburg 1990-01-01 1990     1   1.856 1.594 1.494
#> 1516    8726520   St. Petersburg 1990-02-01 1990     2   1.868 1.628 1.521
#> 1517    8726520   St. Petersburg 1990-03-01 1990     3   2.042 1.737 1.661
#> 1518    8726520   St. Petersburg 1990-04-01 1990     4   2.070 1.695 1.615
#> 1519    8726520   St. Petersburg 1990-05-01 1990     5   2.097 1.798 1.710
#> 1520    8726520   St. Petersburg 1990-06-01 1990     6   2.012 1.759 1.640
#> 1521    8726520   St. Petersburg 1990-07-01 1990     7   2.009 1.789 1.695
#> 1522    8726520   St. Petersburg 1990-08-01 1990     8   1.972 1.826 1.750
#> 1523    8726520   St. Petersburg 1990-09-01 1990     9   1.887 1.771 1.686
#> 1524    8726520   St. Petersburg 1990-10-01 1990    10   2.073 1.747 1.679
#> 1525    8726520   St. Petersburg 1990-11-01 1990    11   2.076 1.762 1.670
#> 1526    8726520   St. Petersburg 1990-12-01 1990    12   2.100 1.689 1.579
#> 1527    8726520   St. Petersburg 1991-01-01 1991     1   2.091 1.731 1.628
#> 1528    8726520   St. Petersburg 1991-02-01 1991     2   1.917 1.606 1.518
#> 1529    8726520   St. Petersburg 1991-03-01 1991     3   2.161 1.676 1.615
#> 1530    8726520   St. Petersburg 1991-04-01 1991     4   1.951 1.713 1.634
#> 1531    8726520   St. Petersburg 1991-05-01 1991     5   2.042 1.829 1.731
#> 1532    8726520   St. Petersburg 1991-06-01 1991     6   2.009 1.783 1.667
#> 1533    8726520   St. Petersburg 1991-07-01 1991     7   2.027 1.817 1.716
#> 1534    8726520   St. Petersburg 1991-08-01 1991     8   1.972 1.807 1.722
#> 1535    8726520   St. Petersburg 1991-09-01 1991     9   1.966 1.826 1.747
#> 1536    8726520   St. Petersburg 1991-10-01 1991    10   1.993 1.771 1.695
#> 1537    8726520   St. Petersburg 1991-11-01 1991    11   1.948 1.698 1.618
#> 1538    8726520   St. Petersburg 1991-12-01 1991    12   1.902 1.622 1.551
#> 1539    8726520   St. Petersburg 1992-01-01 1992     1   2.006 1.661 1.561
#> 1540    8726520   St. Petersburg 1992-02-01 1992     2   2.051 1.679 1.585
#> 1541    8726520   St. Petersburg 1992-03-01 1992     3   1.856 1.564 1.503
#> 1542    8726520   St. Petersburg 1992-04-01 1992     4   1.981 1.640 1.554
#> 1543    8726520   St. Petersburg 1992-05-01 1992     5   1.887 1.695 1.594
#> 1544    8726520   St. Petersburg 1992-06-01 1992     6   2.070 1.841 1.719
#> 1545    8726520   St. Petersburg 1992-07-01 1992     7   1.978 1.765 1.655
#> 1546    8726520   St. Petersburg 1992-08-01 1992     8   2.103 1.774 1.689
#> 1547    8726520   St. Petersburg 1992-09-01 1992     9   1.865 1.765 1.692
#> 1548    8726520   St. Petersburg 1992-10-01 1992    10   2.320 1.835 1.737
#> 1549    8726520   St. Petersburg 1992-11-01 1992    11   2.027 1.692 1.591
#> 1550    8726520   St. Petersburg 1992-12-01 1992    12   1.881 1.658 1.554
#> 1551    8726520   St. Petersburg 1993-01-01 1993     1   1.932 1.686 1.591
#> 1552    8726520   St. Petersburg 1993-02-01 1993     2   2.051 1.679 1.588
#> 1553    8726520   St. Petersburg 1993-03-01 1993     3   2.603 1.628 1.524
#> 1554    8726520   St. Petersburg 1993-04-01 1993     4   2.009 1.664 1.573
#> 1555    8726520   St. Petersburg 1993-05-01 1993     5   1.926 1.722 1.622
#> 1556    8726520   St. Petersburg 1993-06-01 1993     6   1.881 1.737 1.603
#> 1557    8726520   St. Petersburg 1993-07-01 1993     7   1.868 1.725 1.622
#> 1558    8726520   St. Petersburg 1993-08-01 1993     8   1.911 1.768 1.664
#> 1559    8726520   St. Petersburg 1993-09-01 1993     9   1.923 1.771 1.707
#> 1560    8726520   St. Petersburg 1993-10-01 1993    10   2.198 1.804 1.725
#> 1561    8726520   St. Petersburg 1993-11-01 1993    11   1.963 1.664 1.573
#> 1562    8726520   St. Petersburg 1993-12-01 1993    12   1.999 1.661 1.573
#> 1563    8726520   St. Petersburg 1994-01-01 1994     1   1.859 1.567 1.524
#> 1564    8726520   St. Petersburg 1994-02-01 1994     2   1.920 1.617 1.520
#> 1565    8726520   St. Petersburg 1994-03-01 1994     3   1.987 1.653 1.576
#> 1566    8726520   St. Petersburg 1994-04-01 1994     4   1.881 1.691 1.614
#> 1567    8726520   St. Petersburg 1994-05-01 1994     5   1.987 1.704 1.586
#> 1568    8726520   St. Petersburg 1994-06-01 1994     6   1.939 1.737 1.618
#> 1569    8726520   St. Petersburg 1994-07-01 1994     7   1.914 1.759 1.651
#> 1570    8726520   St. Petersburg 1994-08-01 1994     8   1.890 1.777 1.689
#> 1571    8726520   St. Petersburg 1994-09-01 1994     9   1.868 1.789 1.718
#> 1572    8726520   St. Petersburg 1994-10-01 1994    10   2.073 1.783 1.716
#> 1573    8726520   St. Petersburg 1994-11-01 1994    11   1.954 1.702 1.612
#> 1574    8726520   St. Petersburg 1994-12-01 1994    12   2.048 1.713 1.605
#> 1575    8726520   St. Petersburg 1995-01-01 1995     1   1.990 1.648 1.532
#> 1576    8726520   St. Petersburg 1995-02-01 1995     2   1.737 1.522 1.446
#> 1577    8726520   St. Petersburg 1995-03-01 1995     3   1.786 1.632 1.566
#> 1578    8726520   St. Petersburg 1995-04-01 1995     4   1.952 1.692 1.624
#> 1579    8726520   St. Petersburg 1995-05-01 1995     5   1.971 1.780 1.676
#> 1580    8726520   St. Petersburg 1995-06-01 1995     6   2.177 1.781 1.640
#> 1581    8726520   St. Petersburg 1995-07-01 1995     7   2.091 1.792 1.686
#> 1582    8726520   St. Petersburg 1995-08-01 1995     8   2.204 1.904 1.812
#> 1583    8726520   St. Petersburg 1995-09-01 1995     9   2.063 1.906 1.840
#> 1584    8726520   St. Petersburg 1995-10-01 1995    10   2.420 1.858 1.797
#> 1585    8726520   St. Petersburg 1995-11-01 1995    11   2.042 1.699 1.616
#> 1586    8726520   St. Petersburg 1995-12-01 1995    12   2.036 1.667 1.549
#> 1587    8726520   St. Petersburg 1996-01-01 1996     1   1.998 1.647 1.529
#> 1588    8726520   St. Petersburg 1996-02-01 1996     2   1.901 1.555 1.468
#> 1589    8726520   St. Petersburg 1996-03-01 1996     3   1.895 1.563 1.472
#> 1590    8726520   St. Petersburg 1996-04-01 1996     4   1.804 1.627 1.552
#> 1591    8726520   St. Petersburg 1996-05-01 1996     5   1.795 1.666 1.560
#> 1592    8726520   St. Petersburg 1996-06-01 1996     6   1.878 1.695 1.571
#> 1593    8726520   St. Petersburg 1996-07-01 1996     7   1.958 1.747 1.623
#> 1594    8726520   St. Petersburg 1996-08-01 1996     8   1.885 1.761 1.661
#> 1595    8726520   St. Petersburg 1996-09-01 1996     9   1.884 1.769 1.695
#> 1596    8726520   St. Petersburg 1996-10-01 1996    10   2.807 1.791 1.717
#> 1597    8726520   St. Petersburg 1996-11-01 1996    11   1.984 1.691 1.619
#> 1598    8726520   St. Petersburg 1996-12-01 1996    12   1.856 1.630 1.545
#> 1599    8726520   St. Petersburg 1997-01-01 1997     1   1.931 1.607 1.518
#> 1600    8726520   St. Petersburg 1997-02-01 1997     2   1.847 1.591 1.521
#> 1601    8726520   St. Petersburg 1997-03-01 1997     3   1.864 1.654 1.580
#> 1602    8726520   St. Petersburg 1997-04-01 1997     4   2.088 1.685 1.616
#> 1603    8726520   St. Petersburg 1997-05-01 1997     5   1.900 1.697 1.607
#> 1604    8726520   St. Petersburg 1997-06-01 1997     6   1.890 1.769 1.649
#> 1605    8726520   St. Petersburg 1997-07-01 1997     7   1.969 1.772 1.652
#> 1606    8726520   St. Petersburg 1997-08-01 1997     8   1.916 1.775 1.672
#> 1607    8726520   St. Petersburg 1997-09-01 1997     9   1.966 1.798 1.732
#> 1608    8726520   St. Petersburg 1997-10-01 1997    10   2.024 1.744 1.691
#> 1609    8726520   St. Petersburg 1997-11-01 1997    11   2.099 1.698 1.614
#> 1610    8726520   St. Petersburg 1997-12-01 1997    12   1.937 1.656 1.553
#> 1611    8726520   St. Petersburg 1998-01-01 1998     1   1.912 1.646 1.555
#> 1612    8726520   St. Petersburg 1998-02-01 1998     2   2.148 1.727 1.642
#> 1613    8726520   St. Petersburg 1998-03-01 1998     3   1.950 1.644 1.575
#> 1614    8726520   St. Petersburg 1998-04-01 1998     4   1.881 1.669 1.599
#> 1615    8726520   St. Petersburg 1998-05-01 1998     5   1.941 1.739 1.663
#> 1616    8726520   St. Petersburg 1998-06-01 1998     6   1.831 1.723 1.618
#> 1617    8726520   St. Petersburg 1998-07-01 1998     7   1.850 1.725 1.615
#> 1618    8726520   St. Petersburg 1998-08-01 1998     8   1.847 1.742 1.650
#> 1619    8726520   St. Petersburg 1998-09-01 1998     9   2.326 1.871 1.787
#> 1620    8726520   St. Petersburg 1998-10-01 1998    10   1.934 1.718 1.682
#> 1621    8726520   St. Petersburg 1998-11-01 1998    11   1.948 1.656 1.593
#> 1622    8726520   St. Petersburg 1998-12-01 1998    12   1.911 1.655 1.547
#> 1623    8726520   St. Petersburg 1999-01-01 1999     1   2.342 1.690 1.565
#> 1624    8726520   St. Petersburg 1999-02-01 1999     2   1.933 1.709 1.640
#> 1625    8726520   St. Petersburg 1999-03-01 1999     3   1.937 1.664 1.605
#> 1626    8726520   St. Petersburg 1999-04-01 1999     4   2.029 1.691 1.639
#> 1627    8726520   St. Petersburg 1999-05-01 1999     5   1.941 1.759 1.658
#> 1628    8726520   St. Petersburg 1999-06-01 1999     6   1.968 1.740 1.629
#> 1629    8726520   St. Petersburg 1999-07-01 1999     7   1.931 1.782 1.669
#> 1630    8726520   St. Petersburg 1999-08-01 1999     8   1.992 1.826 1.719
#> 1631    8726520   St. Petersburg 1999-09-01 1999     9   2.108 1.887 1.799
#> 1632    8726520   St. Petersburg 1999-10-01 1999    10   1.888 1.750 1.695
#> 1633    8726520   St. Petersburg 1999-11-01 1999    11   1.964 1.680 1.610
#> 1634    8726520   St. Petersburg 1999-12-01 1999    12   1.887 1.633 1.542
#> 1635    8726520   St. Petersburg 2000-01-01 2000     1   1.906 1.604 1.503
#> 1636    8726520   St. Petersburg 2000-02-01 2000     2   1.783 1.576 1.486
#> 1637    8726520   St. Petersburg 2000-03-01 2000     3   1.946 1.675 1.600
#> 1638    8726520   St. Petersburg 2000-04-01 2000     4   1.990 1.683 1.620
#> 1639    8726520   St. Petersburg 2000-05-01 2000     5   1.844 1.721 1.629
#> 1640    8726520   St. Petersburg 2000-06-01 2000     6   1.989 1.775 1.658
#> 1641    8726520   St. Petersburg 2000-07-01 2000     7   1.991 1.837 1.714
#> 1642    8726520   St. Petersburg 2000-08-01 2000     8   1.977 1.806 1.702
#> 1643    8726520   St. Petersburg 2000-09-01 2000     9   2.490 1.814 1.736
#> 1644    8726520   St. Petersburg 2000-10-01 2000    10   1.902 1.716 1.655
#> 1645    8726520   St. Petersburg 2000-11-01 2000    11   2.054 1.745 1.684
#> 1646    8726520   St. Petersburg 2000-12-01 2000    12   1.977 1.613 1.537
#> 1647    8726520   St. Petersburg 2001-01-01 2001     1   1.790 1.489 1.397
#> 1648    8726520   St. Petersburg 2001-02-01 2001     2   1.700 1.526 1.444
#> 1649    8726520   St. Petersburg 2001-03-01 2001     3   1.907 1.632 1.549
#> 1650    8726520   St. Petersburg 2001-04-01 2001     4   1.813 1.619 1.565
#> 1651    8726520   St. Petersburg 2001-05-01 2001     5   1.906 1.688 1.612
#> 1652    8726520   St. Petersburg 2001-06-01 2001     6   1.836 1.677 1.562
#> 1653    8726520   St. Petersburg 2001-07-01 2001     7   2.381 1.780 1.652
#> 1654    8726520   St. Petersburg 2001-08-01 2001     8   2.030 1.782 1.690
#> 1655    8726520   St. Petersburg 2001-09-01 2001     9   1.982 1.787 1.719
#> 1656    8726520   St. Petersburg 2001-10-01 2001    10   2.042 1.725 1.671
#> 1657    8726520   St. Petersburg 2001-11-01 2001    11   1.897 1.733 1.676
#> 1658    8726520   St. Petersburg 2001-12-01 2001    12   1.978 1.710 1.616
#> 1659    8726520   St. Petersburg 2002-01-01 2002     1   1.855 1.600 1.511
#> 1660    8726520   St. Petersburg 2002-02-01 2002     2   1.893 1.583 1.489
#> 1661    8726520   St. Petersburg 2002-03-01 2002     3   1.911 1.592 1.540
#> 1662    8726520   St. Petersburg 2002-04-01 2002     4   1.833 1.674 1.623
#> 1663    8726520   St. Petersburg 2002-05-01 2002     5   1.920 1.747 1.641
#> 1664    8726520   St. Petersburg 2002-06-01 2002     6   1.974 1.783 1.698
#> 1665    8726520   St. Petersburg 2002-07-01 2002     7   1.994 1.768 1.666
#> 1666    8726520   St. Petersburg 2002-08-01 2002     8   1.932 1.811 1.718
#> 1667    8726520   St. Petersburg 2002-09-01 2002     9   2.104 1.883 1.820
#> 1668    8726520   St. Petersburg 2002-10-01 2002    10   2.001 1.845 1.794
#> 1669    8726520   St. Petersburg 2002-11-01 2002    11   2.171 1.687 1.630
#> 1670    8726520   St. Petersburg 2002-12-01 2002    12   1.985 1.640 1.547
#> 1671    8726520   St. Petersburg 2003-01-01 2003     1   2.204 1.620 1.526
#> 1672    8726520   St. Petersburg 2003-02-01 2003     2   1.993 1.599 1.521
#> 1673    8726520   St. Petersburg 2003-03-01 2003     3   1.975 1.718 1.644
#> 1674    8726520   St. Petersburg 2003-04-01 2003     4   1.930 1.746 1.667
#> 1675    8726520   St. Petersburg 2003-05-01 2003     5   1.947 1.770 1.697
#> 1676    8726520   St. Petersburg 2003-06-01 2003     6   2.109 1.823 1.730
#> 1677    8726520   St. Petersburg 2003-07-01 2003     7   2.060 1.864 1.750
#> 1678    8726520   St. Petersburg 2003-08-01 2003     8   2.069 1.856 1.758
#> 1679    8726520   St. Petersburg 2003-09-01 2003     9   2.173 1.899 1.817
#> 1680    8726520   St. Petersburg 2003-10-01 2003    10   2.130 1.840 1.785
#> 1681    8726520   St. Petersburg 2003-11-01 2003    11   2.036 1.789 1.725
#> 1682    8726520   St. Petersburg 2003-12-01 2003    12   1.981 1.667 1.597
#> 1683    8726520   St. Petersburg 2004-01-01 2004     1   1.982 1.663 1.582
#> 1684    8726520   St. Petersburg 2004-02-01 2004     2   1.903 1.653 1.573
#> 1685    8726520   St. Petersburg 2004-03-01 2004     3   1.839 1.672 1.587
#> 1686    8726520   St. Petersburg 2004-04-01 2004     4   1.997 1.688 1.612
#> 1687    8726520   St. Petersburg 2004-05-01 2004     5   1.922 1.748 1.670
#> 1688    8726520   St. Petersburg 2004-06-01 2004     6   2.043 1.830 1.734
#> 1689    8726520   St. Petersburg 2004-07-01 2004     7   2.017 1.827 1.739
#> 1690    8726520   St. Petersburg 2004-08-01 2004     8   2.082 1.834 1.729
#> 1691    8726520   St. Petersburg 2004-09-01 2004     9   2.550 1.866 1.765
#> 1692    8726520   St. Petersburg 2004-10-01 2004    10   1.976 1.834 1.769
#> 1693    8726520   St. Petersburg 2004-11-01 2004    11   2.177 1.814 1.762
#> 1694    8726520   St. Petersburg 2004-12-01 2004    12   1.926 1.611 1.529
#> 1695    8726520   St. Petersburg 2005-01-01 2005     1   1.959 1.675 1.598
#> 1696    8726520   St. Petersburg 2005-02-01 2005     2   2.087 1.766 1.689
#> 1697    8726520   St. Petersburg 2005-03-01 2005     3   1.928 1.662 1.603
#> 1698    8726520   St. Petersburg 2005-04-01 2005     4   2.021 1.749 1.690
#> 1699    8726520   St. Petersburg 2005-05-01 2005     5   1.995 1.796 1.712
#> 1700    8726520   St. Petersburg 2005-06-01 2005     6   1.998 1.828 1.751
#> 1701    8726520   St. Petersburg 2005-07-01 2005     7   2.392 1.868 1.767
#> 1702    8726520   St. Petersburg 2005-08-01 2005     8   2.126 1.856 1.763
#> 1703    8726520   St. Petersburg 2005-09-01 2005     9   2.316 1.863 1.783
#> 1704    8726520   St. Petersburg 2005-10-01 2005    10   2.097 1.779 1.696
#> 1705    8726520   St. Petersburg 2005-11-01 2005    11   1.942 1.736 1.680
#> 1706    8726520   St. Petersburg 2005-12-01 2005    12   2.000 1.670 1.577
#> 1707    8726520   St. Petersburg 2006-01-01 2006     1   1.997 1.668 1.587
#> 1708    8726520   St. Petersburg 2006-02-01 2006     2   1.908 1.622 1.540
#> 1709    8726520   St. Petersburg 2006-03-01 2006     3   1.910 1.689 1.624
#> 1710    8726520   St. Petersburg 2006-04-01 2006     4      NA 1.696 1.623
#> 1711    8726520   St. Petersburg 2006-05-01 2006     5   1.942 1.774 1.709
#> 1712    8726520   St. Petersburg 2006-06-01 2006     6   2.171 1.785 1.679
#> 1713    8726520   St. Petersburg 2006-07-01 2006     7   1.950 1.759 1.653
#> 1714    8726520   St. Petersburg 2006-08-01 2006     8   1.946 1.821 1.731
#> 1715    8726520   St. Petersburg 2006-09-01 2006     9   2.060 1.890 1.819
#> 1716    8726520   St. Petersburg 2006-10-01 2006    10   2.276 1.831 1.777
#> 1717    8726520   St. Petersburg 2006-11-01 2006    11   2.101 1.700 1.639
#> 1718    8726520   St. Petersburg 2006-12-01 2006    12   2.047 1.680 1.590
#> 1719    8726520   St. Petersburg 2007-01-01 2007     1   1.927 1.676 1.601
#> 1720    8726520   St. Petersburg 2007-02-01 2007     2   2.160 1.615 1.506
#> 1721    8726520   St. Petersburg 2007-03-01 2007     3   1.950 1.634 1.549
#> 1722    8726520   St. Petersburg 2007-04-01 2007     4   1.925 1.652 1.590
#> 1723    8726520   St. Petersburg 2007-05-01 2007     5   2.059 1.826 1.737
#> 1724    8726520   St. Petersburg 2007-06-01 2007     6   2.386 1.856 1.774
#> 1725    8726520   St. Petersburg 2007-07-01 2007     7   2.045 1.840 1.739
#> 1726    8726520   St. Petersburg 2007-08-01 2007     8   1.998 1.849 1.768
#> 1727    8726520   St. Petersburg 2007-09-01 2007     9   2.109 1.839 1.762
#> 1728    8726520   St. Petersburg 2007-10-01 2007    10   2.142 1.845 1.782
#> 1729    8726520   St. Petersburg 2007-11-01 2007    11   1.989 1.734 1.671
#> 1730    8726520   St. Petersburg 2007-12-01 2007    12   2.075 1.712 1.617
#> 1731    8726520   St. Petersburg 2008-01-01 2008     1   1.935 1.639 1.570
#> 1732    8726520   St. Petersburg 2008-02-01 2008     2   1.886 1.634 1.566
#> 1733    8726520   St. Petersburg 2008-03-01 2008     3   1.984 1.625 1.554
#> 1734    8726520   St. Petersburg 2008-04-01 2008     4   1.881 1.711 1.645
#> 1735    8726520   St. Petersburg 2008-05-01 2008     5   2.059 1.785 1.703
#> 1736    8726520   St. Petersburg 2008-06-01 2008     6   1.957 1.791 1.698
#> 1737    8726520   St. Petersburg 2008-07-01 2008     7   2.071 1.864 1.770
#> 1738    8726520   St. Petersburg 2008-08-01 2008     8   2.026 1.870 1.769
#> 1739    8726520   St. Petersburg 2008-09-01 2008     9   2.313 1.925 1.858
#> 1740    8726520   St. Petersburg 2008-10-01 2008    10   2.045 1.815 1.743
#> 1741    8726520   St. Petersburg 2008-11-01 2008    11   2.182 1.738 1.685
#> 1742    8726520   St. Petersburg 2008-12-01 2008    12   2.102 1.673 1.569
#> 1743    8726520   St. Petersburg 2009-01-01 2009     1   1.849 1.564 1.481
#> 1744    8726520   St. Petersburg 2009-02-01 2009     2   1.892 1.578 1.495
#> 1745    8726520   St. Petersburg 2009-03-01 2009     3   2.057 1.712 1.656
#> 1746    8726520   St. Petersburg 2009-04-01 2009     4   1.982 1.720 1.645
#> 1747    8726520   St. Petersburg 2009-05-01 2009     5   2.018 1.758 1.683
#> 1748    8726520   St. Petersburg 2009-06-01 2009     6   2.092 1.853 1.763
#> 1749    8726520   St. Petersburg 2009-07-01 2009     7   2.076 1.880 1.783
#> 1750    8726520   St. Petersburg 2009-08-01 2009     8   2.085 1.871 1.773
#> 1751    8726520   St. Petersburg 2009-09-01 2009     9   2.154 1.941 1.872
#> 1752    8726520   St. Petersburg 2009-10-01 2009    10   2.027 1.848 1.799
#> 1753    8726520   St. Petersburg 2009-11-01 2009    11   2.038 1.809 1.754
#> 1754    8726520   St. Petersburg 2010-01-01 2010     1   2.024 1.684 1.595
#> 1755    8726520   St. Petersburg 2010-02-01 2010     2   1.978 1.669 1.588
#> 1756    8726520   St. Petersburg 2010-03-01 2010     3   2.043 1.676 1.607
#> 1757    8726520   St. Petersburg 2010-04-01 2010     4   1.932 1.693 1.620
#> 1758    8726520   St. Petersburg 2010-05-01 2010     5   1.972 1.779 1.674
#> 1759    8726520   St. Petersburg 2010-06-01 2010     6   2.038 1.846 1.748
#> 1760    8726520   St. Petersburg 2010-07-01 2010     7   2.076 1.840 1.739
#> 1761    8726520   St. Petersburg 2010-08-01 2010     8   2.180 1.870 1.795
#> 1762    8726520   St. Petersburg 2010-09-01 2010     9   2.067 1.922 1.839
#> 1763    8726520   St. Petersburg 2010-10-01 2010    10   2.080 1.788 1.724
#> 1764    8726520   St. Petersburg 2010-11-01 2010    11   2.006 1.743 1.675
#> 1765    8726520   St. Petersburg 2010-12-01 2010    12   1.934 1.623 1.540
#> 1766    8726520   St. Petersburg 2011-01-01 2011     1   1.901 1.635 1.567
#> 1767    8726520   St. Petersburg 2011-02-01 2011     2   1.852 1.615 1.542
#> 1768    8726520   St. Petersburg 2011-03-01 2011     3   2.048 1.680 1.609
#> 1769    8726520   St. Petersburg 2011-04-01 2011     4   1.851 1.705 1.628
#> 1770    8726520   St. Petersburg 2011-05-01 2011     5   1.985 1.764 1.656
#> 1771    8726520   St. Petersburg 2011-06-01 2011     6   1.980 1.829 1.716
#> 1772    8726520   St. Petersburg 2011-07-01 2011     7   2.042 1.887 1.770
#> 1773    8726520   St. Petersburg 2011-08-01 2011     8   2.085 1.888 1.792
#> 1774    8726520   St. Petersburg 2011-09-01 2011     9   2.171 1.851 1.769
#> 1775    8726520   St. Petersburg 2011-10-01 2011    10   2.340 1.781 1.695
#> 1776    8726520   St. Petersburg 2011-11-01 2011    11   2.136 1.775 1.683
#> 1777    8726520   St. Petersburg 2011-12-01 2011    12   1.979 1.710 1.617
#> 1778    8726520   St. Petersburg 2012-01-01 2012     1   1.884 1.654 1.583
#> 1779    8726520   St. Petersburg 2012-02-01 2012     2   1.929 1.701 1.609
#> 1780    8726520   St. Petersburg 2012-03-01 2012     3   1.903 1.745 1.667
#> 1781    8726520   St. Petersburg 2012-04-01 2012     4   2.114 1.801 1.726
#> 1782    8726520   St. Petersburg 2012-05-01 2012     5   2.043 1.838 1.733
#> 1783    8726520   St. Petersburg 2012-06-01 2012     6   2.505 1.964 1.842
#> 1784    8726520   St. Petersburg 2012-07-01 2012     7   2.046 1.912 1.798
#> 1785    8726520   St. Petersburg 2012-08-01 2012     8   2.205 1.931 1.824
#> 1786    8726520   St. Petersburg 2012-09-01 2012     9   2.054 1.863 1.784
#> 1787    8726520   St. Petersburg 2012-10-01 2012    10   2.127 1.833 1.762
#> 1788    8726520   St. Petersburg 2012-11-01 2012    11   2.095 1.854 1.756
#> 1789    8726520   St. Petersburg 2012-12-01 2012    12   2.059 1.785 1.703
#> 1790    8726520   St. Petersburg 2013-01-01 2013     1   1.958 1.735 1.652
#> 1791    8726520   St. Petersburg 2013-02-01 2013     2   2.034 1.710 1.633
#> 1792    8726520   St. Petersburg 2013-03-01 2013     3   1.970 1.686 1.602
#> 1793    8726520   St. Petersburg 2013-04-01 2013     4   2.029 1.721 1.629
#> 1794    8726520   St. Petersburg 2013-05-01 2013     5   1.926 1.744 1.652
#> 1795    8726520   St. Petersburg 2013-06-01 2013     6   2.320 1.819 1.700
#> 1796    8726520   St. Petersburg 2013-07-01 2013     7   2.027 1.875 1.760
#> 1797    8726520   St. Petersburg 2013-08-01 2013     8   1.991 1.864 1.771
#> 1798    8726520   St. Petersburg 2013-09-01 2013     9   2.030 1.881 1.813
#> 1799    8726520   St. Petersburg 2013-10-01 2013    10   2.044 1.852 1.803
#> 1800    8726520   St. Petersburg 2013-11-01 2013    11   2.076 1.770 1.694
#> 1801    8726520   St. Petersburg 2013-12-01 2013    12   2.100 1.768 1.667
#> 1802    8726520   St. Petersburg 2014-01-01 2014     1   1.924 1.698 1.570
#> 1803    8726520   St. Petersburg 2014-02-01 2014     2   1.938 1.727 1.646
#> 1804    8726520   St. Petersburg 2014-03-01 2014     3   1.982 1.709 1.653
#> 1805    8726520   St. Petersburg 2014-04-01 2014     4   2.023 1.776 1.695
#> 1806    8726520   St. Petersburg 2014-05-01 2014     5   2.105 1.814 1.712
#> 1807    8726520   St. Petersburg 2014-06-01 2014     6   2.093 1.832 1.717
#> 1808    8726520   St. Petersburg 2014-07-01 2014     7   1.985 1.824 1.720
#> 1809    8726520   St. Petersburg 2014-08-01 2014     8   2.052 1.870 1.771
#> 1810    8726520   St. Petersburg 2014-09-01 2014     9   2.036 1.887 1.813
#> 1811    8726520   St. Petersburg 2014-10-01 2014    10   1.992 1.861 1.793
#> 1812    8726520   St. Petersburg 2014-11-01 2014    11   2.137 1.776 1.701
#> 1813    8726520   St. Petersburg 2014-12-01 2014    12   2.145 1.840 1.733
#> 1814    8726520   St. Petersburg 2015-01-01 2015     1   2.041 1.731 1.638
#> 1815    8726520   St. Petersburg 2015-02-01 2015     2   2.101 1.712 1.620
#> 1816    8726520   St. Petersburg 2015-03-01 2015     3   1.837 1.674 1.599
#> 1817    8726520   St. Petersburg 2015-04-01 2015     4   1.969 1.752 1.683
#> 1818    8726520   St. Petersburg 2015-05-01 2015     5   1.923 1.794 1.689
#> 1819    8726520   St. Petersburg 2015-06-01 2015     6   1.953 1.819 1.697
#> 1820    8726520   St. Petersburg 2015-07-01 2015     7   2.120 1.877 1.752
#> 1821    8726520   St. Petersburg 2015-08-01 2015     8   2.137 1.933 1.829
#> 1822    8726520   St. Petersburg 2015-09-01 2015     9   2.170 1.910 1.834
#> 1823    8726520   St. Petersburg 2015-10-01 2015    10   2.250 1.966 1.907
#> 1824    8726520   St. Petersburg 2015-11-01 2015    11   2.056 1.860 1.786
#> 1825    8726520   St. Petersburg 2015-12-01 2015    12   2.069 1.845 1.748
#> 1826    8726520   St. Petersburg 2016-01-01 2016     1   2.239 1.818 1.730
#> 1827    8726520   St. Petersburg 2016-02-01 2016     2   2.155 1.742 1.647
#> 1828    8726520   St. Petersburg 2016-03-01 2016     3   1.911 1.735 1.663
#> 1829    8726520   St. Petersburg 2016-04-01 2016     4   2.029 1.797 1.734
#> 1830    8726520   St. Petersburg 2016-05-01 2016     5   2.010 1.845 1.756
#> 1831    8726520   St. Petersburg 2016-06-01 2016     6   2.401 1.860 1.756
#> 1832    8726520   St. Petersburg 2016-07-01 2016     7   2.007 1.850 1.732
#> 1833    8726520   St. Petersburg 2016-08-01 2016     8   2.223 1.899 1.796
#> 1834    8726520   St. Petersburg 2016-09-01 2016     9   2.500 1.924 1.858
#> 1835    8726520   St. Petersburg 2016-10-01 2016    10   2.076 1.813 1.773
#> 1836    8726520   St. Petersburg 2016-11-01 2016    11   2.095 1.849 1.779
#> 1837    8726520   St. Petersburg 2016-12-01 2016    12   1.975 1.740 1.648
#> 1838    8726520   St. Petersburg 2017-01-01 2017     1   2.401 1.773 1.679
#> 1839    8726520   St. Petersburg 2017-02-01 2017     2   1.850 1.667 1.591
#> 1840    8726520   St. Petersburg 2017-03-01 2017     3   1.938 1.639 1.569
#> 1841    8726520   St. Petersburg 2017-04-01 2017     4   2.008 1.776 1.712
#> 1842    8726520   St. Petersburg 2017-05-01 2017     5   2.150 1.778 1.701
#> 1843    8726520   St. Petersburg 2017-06-01 2017     6   2.148 1.868 1.744
#> 1844    8726520   St. Petersburg 2017-07-01 2017     7   2.002 1.852 1.727
#> 1845    8726520   St. Petersburg 2017-08-01 2017     8   2.058 1.892 1.785
#> 1846    8726520   St. Petersburg 2017-09-01 2017     9   2.051 1.898 1.832
#> 1847    8726520   St. Petersburg 2017-10-01 2017    10   2.306 1.893 1.827
#> 1848    8726520   St. Petersburg 2017-11-01 2017    11   2.066 1.786 1.720
#> 1849    8726520   St. Petersburg 2017-12-01 2017    12   2.033 1.783 1.670
#> 1850    8726520   St. Petersburg 2018-01-01 2018     1   2.008 1.612 1.539
#> 1851    8726520   St. Petersburg 2018-02-01 2018     2   1.874 1.703 1.612
#> 1852    8726520   St. Petersburg 2018-03-01 2018     3   2.050 1.784 1.717
#> 1853    8726520   St. Petersburg 2018-04-01 2018     4   2.023 1.742 1.677
#> 1854    8726520   St. Petersburg 2018-05-01 2018     5   2.085 1.822 1.736
#> 1855    8726520   St. Petersburg 2018-06-01 2018     6   1.971 1.800 1.684
#> 1856    8726520   St. Petersburg 2018-07-01 2018     7   2.075 1.888 1.767
#> 1857    8726520   St. Petersburg 2018-08-01 2018     8   2.065 1.900 1.808
#> 1858    8726520   St. Petersburg 2018-09-01 2018     9   2.131 1.919 1.848
#> 1859    8726520   St. Petersburg 2018-10-01 2018    10   2.377 1.892 1.845
#> 1860    8726520   St. Petersburg 2018-11-01 2018    11   2.099 1.814 1.732
#> 1861    8726520   St. Petersburg 2018-12-01 2018    12   2.376 1.808 1.726
#> 1862    8726520   St. Petersburg 2019-01-01 2019     1   2.165 1.704 1.622
#> 1863    8726520   St. Petersburg 2019-02-01 2019     2   1.988 1.766 1.674
#> 1864    8726520   St. Petersburg 2019-03-01 2019     3   1.963 1.757 1.697
#> 1865    8726520   St. Petersburg 2019-04-01 2019     4   2.178 1.811 1.745
#> 1866    8726520   St. Petersburg 2019-05-01 2019     5   2.081 1.864 1.791
#> 1867    8726520   St. Petersburg 2019-06-01 2019     6   2.070 1.909 1.800
#> 1868    8726520   St. Petersburg 2019-07-01 2019     7   2.099 1.944 1.816
#> 1869    8726520   St. Petersburg 2019-08-01 2019     8   2.171 1.948 1.834
#> 1870    8726520   St. Petersburg 2019-09-01 2019     9   2.146 1.896 1.821
#> 1871    8726520   St. Petersburg 2019-10-01 2019    10   2.288 2.042 1.974
#> 1872    8726520   St. Petersburg 2019-11-01 2019    11   2.258 1.941 1.865
#> 1873    8726520   St. Petersburg 2019-12-01 2019    12   2.207 1.828 1.721
#> 1874    8726520   St. Petersburg 2020-01-01 2020     1   2.105 1.778 1.692
#> 1875    8726520   St. Petersburg 2020-02-01 2020     2   2.339 1.727 1.639
#> 1876    8726520   St. Petersburg 2020-03-01 2020     3   1.972 1.735 1.665
#> 1877    8726520   St. Petersburg 2020-04-01 2020     4   2.095 1.842 1.782
#> 1878    8726520   St. Petersburg 2020-05-01 2020     5   2.030 1.802 1.729
#> 1879    8726520   St. Petersburg 2020-06-01 2020     6   2.263 1.917 1.807
#> 1880    8726520   St. Petersburg 2020-07-01 2020     7   2.136 1.895 1.793
#> 1881    8726520   St. Petersburg 2020-08-01 2020     8   2.098 1.937 1.842
#> 1882    8726520   St. Petersburg 2020-09-01 2020     9   2.165 1.960 1.882
#> 1883    8726520   St. Petersburg 2020-10-01 2020    10   2.113 1.952 1.896
#> 1884    8726520   St. Petersburg 2020-11-01 2020    11   2.744 1.884 1.835
#> 1885    8726520   St. Petersburg 2020-12-01 2020    12   2.051 1.772 1.710
#> 1886    8726520   St. Petersburg 2021-01-01 2021     1   2.103 1.760 1.648
#> 1887    8726520   St. Petersburg 2021-02-01 2021     2   2.034 1.778 1.691
#> 1888    8726520   St. Petersburg 2021-03-01 2021     3   2.006 1.768 1.729
#> 1889    8726520   St. Petersburg 2021-04-01 2021     4   2.060 1.836 1.773
#> 1890    8726520   St. Petersburg 2021-05-01 2021     5   2.050 1.801 1.728
#> 1891    8726520   St. Petersburg 2021-06-01 2021     6   2.043 1.887 1.784
#> 1892    8726520   St. Petersburg 2021-07-01 2021     7   2.208 1.886 1.798
#> 1893    8726520   St. Petersburg 2021-08-01 2021     8   2.107 1.956 1.858
#> 1894    8726520   St. Petersburg 2021-09-01 2021     9   2.029 1.930 1.857
#> 1895    8726520   St. Petersburg 2021-10-01 2021    10   2.214 1.974 1.907
#> 1896    8726520   St. Petersburg 2021-11-01 2021    11   2.100 1.860 1.810
#> 1897    8726520   St. Petersburg 2021-12-01 2021    12   2.087 1.858 1.769
#> 1898    8726520   St. Petersburg 2022-01-01 2022     1   2.198 1.835 1.763
#> 1899    8726520   St. Petersburg 2022-02-01 2022     2   2.072 1.790 1.722
#> 1900    8726520   St. Petersburg 2022-03-01 2022     3   2.097 1.793 1.729
#> 1901    8726520   St. Petersburg 2022-04-01 2022     4   1.957 1.816 1.757
#> 1902    8726520   St. Petersburg 2022-05-01 2022     5   2.147 1.906 1.834
#> 1903    8726520   St. Petersburg 2022-06-01 2022     6   2.061 1.928 1.858
#> 1904    8726520   St. Petersburg 2022-07-01 2022     7   2.067 1.917 1.815
#> 1905    8726520   St. Petersburg 2022-08-01 2022     8   2.111 1.946 1.854
#> 1906    8726520   St. Petersburg 2022-09-01 2022     9   2.248 1.958 1.880
#> 1907    8726520   St. Petersburg 2022-10-01 2022    10   2.143 1.943 1.885
#> 1908    8726520   St. Petersburg 2022-11-01 2022    11   2.230 1.920 1.824
#> 1909    8726520   St. Petersburg 2022-12-01 2022    12   2.245 1.877 1.803
#> 1910    8726520   St. Petersburg 2023-01-01 2023     1   2.139 1.809 1.711
#> 1911    8726520   St. Petersburg 2023-02-01 2023     2   1.882 1.747 1.688
#> 1912    8726520   St. Petersburg 2023-03-01 2023     3   2.156 1.859 1.796
#> 1913    8726520   St. Petersburg 2023-04-01 2023     4   2.047 1.864 1.802
#> 1914    8726520   St. Petersburg 2023-05-01 2023     5   2.059 1.879 1.801
#> 1915    8726520   St. Petersburg 2023-06-01 2023     6   2.234 1.984 1.877
#> 1916    8726520   St. Petersburg 2023-07-01 2023     7   2.086 1.898 1.818
#> 1917    8726520   St. Petersburg 2023-08-01 2023     8   2.874 1.964 1.860
#> 1918    8726520   St. Petersburg 2023-09-01 2023     9   2.118 1.924 1.842
#> 1919    8726520   St. Petersburg 2023-10-01 2023    10   2.283 1.945 1.881
#> 1920    8726520   St. Petersburg 2023-11-01 2023    11   2.142 1.893 1.833
#> 1921    8726520   St. Petersburg 2023-12-01 2023    12   2.678 1.861 1.767
#> 1922    8726520   St. Petersburg 2024-01-01 2024     1   2.230 1.762 1.667
#> 1923    8726520   St. Petersburg 2024-02-01 2024     2   2.146 1.788 1.714
#> 1924    8726520   St. Petersburg 2024-03-01 2024     3   1.987 1.804 1.717
#> 1925    8726520   St. Petersburg 2024-04-01 2024     4   2.338 1.840 1.754
#> 1926    8726520   St. Petersburg 2024-05-01 2024     5   2.127 1.905 1.818
#> 1927    8726520   St. Petersburg 2024-06-01 2024     6   2.113 1.926 1.844
#> 1928    8726520   St. Petersburg 2024-07-01 2024     7   2.067 1.920 1.828
#> 1929    8726520   St. Petersburg 2024-08-01 2024     8   2.499 1.962 1.895
#> 1930    8726520   St. Petersburg 2024-09-01 2024     9   3.624 2.131 2.025
#> 1931    8726520   St. Petersburg 2024-10-01 2024    10   2.099 1.937 1.881
#> 1932    8726520   St. Petersburg 2024-11-01 2024    11   2.326 1.954 1.890
#> 1933    8726520   St. Petersburg 2024-12-01 2024    12   2.082 1.779 1.702
#> 1934    8726520   St. Petersburg 2025-01-01 2025     1   2.060 1.697 1.613
#> 1935    8726520   St. Petersburg 2025-02-01 2025     2   1.961 1.724 1.648
#> 1936    8726520   St. Petersburg 2025-03-01 2025     3   2.088 1.772 1.703
#> 1937    8726520   St. Petersburg 2025-04-01 2025     4   2.008 1.809 1.729
#> 1938    8726520   St. Petersburg 2025-05-01 2025     5   2.121 1.892 1.810
#> 1939    8726520   St. Petersburg 2025-06-01 2025     6   2.133 1.927 1.827
#> 1940    8726520   St. Petersburg 2025-07-01 2025     7   2.119 1.917 1.821
#> 1941    8726520   St. Petersburg 2025-08-01 2025     8   2.143 1.976 1.889
#> 1942    8726520   St. Petersburg 2025-09-01 2025     9   2.111 1.936 1.861
#> 1943    8726520   St. Petersburg 2025-10-01 2025    10   2.110 1.920 1.856
#> 1944    8726520   St. Petersburg 2025-11-01 2025    11   2.131 1.807 1.718
#>        msl   mtl    mlw   mllw   dtl    gt    mn   dhq   dlq  hwi   lwi lowest
#> 1    0.960 0.960  0.658  0.463 0.920 0.920 0.604 0.119 0.195 4.54 10.41  0.149
#> 2    0.951 0.954  0.655  0.448 0.914 0.930 0.594 0.128 0.207 4.48 10.53  0.162
#> 3    0.951 0.942  0.631  0.457 0.920 0.927 0.622 0.131 0.174 4.48 10.25  0.186
#> 4    0.981 0.972  0.668  0.555 0.975 0.841 0.613 0.116 0.113 4.37 10.50  0.439
#> 5    1.036 1.027  0.732  0.610 1.018 0.817 0.594 0.101 0.122 4.52 10.37  0.384
#> 6    1.024 1.018  0.747  0.588 0.981 0.789 0.543 0.088 0.158 4.24 10.15  0.418
#> 7    1.012 1.021  0.753  0.533 0.966 0.866 0.539 0.107 0.219 4.37 10.27  0.012
#> 8    0.896 0.893  0.622  0.436 0.856 0.841 0.539 0.116 0.186 4.30 10.32  0.024
#> 9    0.872 0.866  0.573  0.393 0.844 0.902 0.585 0.137 0.180 4.40 10.30  0.101
#> 10   0.869 0.863  0.579  0.430 0.850 0.841 0.570 0.122 0.149 4.55 10.31  0.012
#> 11   0.875 0.869  0.564  0.396 0.841 0.893 0.610 0.116 0.168   NA    NA     NA
#> 12   0.896 0.887  0.607  0.448 0.866 0.835 0.564 0.113 0.158 4.80 10.49  0.073
#> 13   0.966 0.960  0.674  0.503 0.927 0.847 0.570 0.107 0.171 4.58 10.45  0.311
#> 14   1.036 1.030  0.738  0.549 1.000 0.905 0.585 0.131 0.189 4.49 10.41  0.146
#> 15   0.954 0.948  0.655  0.500 0.936 0.872 0.588 0.128 0.155 4.46 10.40  0.165
#> 16   0.969 0.963  0.664  0.542 0.957 0.832 0.594 0.116 0.122 4.54 10.39  0.323
#> 17   1.064 1.055  0.765  0.671 1.055 0.765 0.579 0.091 0.094 4.38 10.43  0.488
#> 18   1.003 1.000  0.719  0.585 0.972 0.774 0.561 0.079 0.134 4.46 10.51  0.274
#> 19   0.908 0.905  0.631  0.445 0.869 0.847 0.546 0.116 0.186 4.33 10.33  0.189
#> 20   0.872 0.863  0.585  0.387 0.829 0.881 0.552 0.131 0.198 4.41 10.36  0.082
#> 21   0.847 0.844  0.555  0.399 0.823 0.847 0.579 0.113 0.155 4.46 10.58  0.171
#> 22   0.905 0.899  0.597  0.482 0.896 0.829 0.600 0.113 0.116 4.62 10.52  0.220
#> 23   0.881 0.878  0.588  0.463 0.860 0.796 0.579 0.091 0.125 4.73 10.74  0.290
#> 24   0.899 0.896  0.616  0.466 0.872 0.808 0.561 0.098 0.149 4.80 10.88  0.238
#> 25   0.960 0.960  0.677  0.524 0.933 0.820 0.564 0.104 0.152 4.59 10.63  0.293
#> 26   0.960 0.960  0.671  0.497 0.927 0.856 0.576 0.107 0.174 4.28 10.27  0.229
#> 27   1.033 1.030  0.738  0.597 1.021 0.847 0.585 0.122 0.140 4.40 10.89  0.384
#> 28   1.018 1.018  0.725  0.604 1.012 0.820 0.588 0.110 0.122   NA    NA     NA
#> 29   1.100 1.100  0.814  0.692 1.085 0.783 0.573 0.088 0.122   NA    NA  0.503
#> 30   1.012 1.003  0.725  0.594 0.972 0.756 0.555 0.070 0.131 4.59 10.73  0.378
#> 31   0.969 0.963  0.686  0.503 0.917 0.829 0.552 0.094 0.183 4.36 10.52  0.226
#> 32   0.951 0.945  0.664  0.475 0.908 0.869 0.561 0.119 0.189 4.57 10.61  0.064
#> 33   0.753 0.747  0.469  0.302 0.732 0.856 0.555 0.134 0.168 4.73 10.71 -0.037
#> 34   0.744 0.738  0.445  0.314 0.732 0.838 0.585 0.122 0.131   NA    NA     NA
#> 35   0.826 0.820  0.521  0.408 0.811 0.805 0.600 0.091 0.113   NA    NA     NA
#> 36   0.905 0.896  0.610  0.469 0.878 0.820 0.576 0.104 0.140 4.51 10.49  0.210
#> 37   0.972 0.975  0.686  0.506 0.948 0.884 0.579 0.125 0.180 4.44 10.58  0.241
#> 38   0.969 0.966  0.677  0.503 0.939 0.872 0.579 0.119 0.174 4.61 10.64  0.232
#> 39   0.945 0.933  0.643  0.506 0.920 0.829 0.582 0.110 0.137 4.56 10.51  0.286
#> 40   0.942 0.933  0.637  0.527 0.936 0.817 0.594 0.113 0.110 4.46 10.50  0.341
#> 41   1.015 1.006  0.707  0.594 0.994 0.799 0.594 0.091 0.113   NA    NA     NA
#> 42   0.939 0.930  0.655  0.509 0.896 0.774 0.552 0.076 0.146 4.50 10.54  0.131
#> 43   0.853 0.847  0.579  0.411 0.814 0.805 0.539 0.098 0.168   NA    NA     NA
#> 44   0.838 0.832  0.539  0.360 0.817 0.911 0.585 0.146 0.180 4.44 10.54  0.040
#> 45   0.777 0.771  0.475  0.332 0.762 0.860 0.588 0.128 0.143 4.55 10.56 -0.256
#> 46   0.741 0.735  0.448  0.317 0.719 0.805 0.573 0.101 0.131 4.70 10.75  0.030
#> 47   0.838 0.832  0.546  0.418 0.817 0.799 0.570 0.101 0.128 4.58 10.50  0.128
#> 48   0.841 0.835  0.539  0.415 0.811 0.789 0.588 0.076 0.125   NA    NA  0.082
#> 49   0.942 0.936  0.631  0.479 0.914 0.869 0.613 0.104 0.152   NA    NA  0.210
#> 50   0.985 0.975  0.683  0.506 0.945 0.875 0.588 0.110 0.177 4.59 10.60  0.216
#> 51   0.942 0.927  0.622  0.472 0.914 0.887 0.613 0.125 0.149 4.58 10.64  0.107
#> 52   1.000 0.994  0.698  0.600 0.994 0.786 0.591 0.098 0.098 4.84 10.46  0.378
#> 53   1.076 1.070  0.777  0.680 1.061 0.762 0.585 0.079 0.098 4.48 10.58  0.533
#> 54   0.951 0.945  0.658  0.530 0.920 0.777 0.576 0.073 0.128 4.47 10.54  0.222
#> 55   0.969 0.963  0.683  0.521 0.927 0.814 0.558 0.094 0.162 4.54 10.50 -0.009
#> 56   0.838 0.832  0.567  0.354 0.811 0.911 0.533 0.165 0.213   NA    NA     NA
#> 57   0.780 0.774  0.479  0.323 0.759 0.872 0.588 0.128 0.155 4.56 10.54 -0.006
#> 58   0.847 0.838  0.552  0.427 0.829 0.805 0.573 0.107 0.125 4.81 10.79  0.064
#> 59   0.829 0.823  0.521  0.390 0.799 0.817 0.604 0.082 0.131 4.53 10.61  0.183
#> 60   0.908 0.899  0.607  0.454 0.863 0.817 0.585 0.079 0.152 4.82 10.77  0.238
#> 61   0.960 0.957  0.686  0.533 0.927 0.789 0.539 0.098 0.152 5.04 11.27  0.280
#> 62   0.963 0.957  0.683  0.521 0.939 0.832 0.552 0.119 0.162 4.60 11.31  0.350
#> 63   1.012 1.006  0.710  0.576 0.997 0.841 0.591 0.116 0.134 4.92 11.28  0.402
#> 64   0.981 0.975  0.664  0.485 0.933 0.899 0.622 0.098 0.180   NA    NA     NA
#> 65   1.039 1.033  0.725  0.597 1.009 0.823 0.616 0.079 0.128   NA    NA     NA
#> 66   1.064 1.058  0.768  0.649 1.036 0.771 0.582 0.070 0.119 4.42 10.60  0.421
#> 67   1.021 1.021  0.732  0.567 0.981 0.826 0.576 0.085 0.165 4.31 10.48  0.344
#> 68   0.872 0.866  0.582  0.399 0.841 0.881 0.564 0.134 0.183 4.34 10.48  0.146
#> 69   0.863 0.853  0.546  0.375 0.829 0.911 0.616 0.125 0.171 4.23 10.36 -0.070
#> 70   0.814 0.805  0.500  0.369 0.789 0.841 0.607 0.104 0.131 4.44 10.49 -0.037
#> 71   0.881 0.872  0.576  0.463 0.860 0.792 0.594 0.085 0.113 4.53 10.52  0.265
#> 72   0.954 0.945  0.658  0.515 0.914 0.799 0.573 0.082 0.143 4.40 10.54  0.280
#> 73   0.927 0.924  0.631  0.466 0.890 0.844 0.585 0.094 0.165 4.53 10.56  0.174
#> 74   0.936 0.930  0.640  0.472 0.899 0.853 0.579 0.107 0.168 4.48 10.57  0.250
#> 75   1.003 0.997  0.710  0.579 0.985 0.811 0.573 0.107 0.131 5.16 11.15  0.296
#> 76   1.045 1.039  0.747  0.637 1.036 0.802 0.585 0.107 0.110   NA    NA  0.375
#> 77   1.094 1.088  0.792  0.701 1.079 0.759 0.591 0.076 0.091 4.79 10.02  0.433
#> 78   0.997 0.991  0.707  0.585 0.966 0.762 0.570 0.070 0.122 4.28 10.35  0.363
#> 79   0.936 0.930  0.652  0.503 0.890 0.774 0.549 0.076 0.149 4.50 10.51  0.198
#> 80   0.866 0.860  0.573  0.396 0.829 0.863 0.573 0.113 0.177 4.60 10.75 -0.009
#> 81   0.914 0.908  0.628  0.475 0.890 0.826 0.564 0.110 0.152   NA    NA     NA
#> 82   0.860 0.856  0.576  0.448 0.847 0.796 0.561 0.107 0.131   NA    NA  0.125
#> 83   0.856 0.860  0.555  0.433 0.829 0.792 0.610 0.061 0.119   NA    NA  0.009
#> 84   0.914 0.908  0.622  0.482 0.872 0.780 0.570 0.070 0.140 4.47 10.58  0.189
#> 85   0.951 0.945  0.658  0.494 0.914 0.838 0.573 0.101 0.168 4.36 10.54  0.244
#> 86   0.954 0.951  0.664  0.469 0.914 0.893 0.576 0.125 0.195 4.41 10.45  0.155
#> 87   0.960 0.954  0.661  0.509 0.936 0.853 0.588 0.113 0.152 4.34 10.51  0.296
#> 88   0.969 0.960  0.674  0.564 0.957 0.786 0.573 0.104 0.110 4.44 10.56  0.390
#> 89   1.015 1.006  0.716  0.610 0.994 0.765 0.576 0.082 0.110 4.36 10.36  0.463
#> 90   0.939 0.927  0.643  0.512 0.896 0.765 0.567 0.067 0.131 4.24 10.34  0.113
#> 91   0.957 0.951  0.677  0.515 0.914 0.799 0.552 0.088 0.158 4.39 10.48  0.024
#> 92   0.856 0.850  0.579  0.421 0.829 0.820 0.543 0.116 0.158 4.36 10.48  0.018
#> 93   0.780 0.774  0.497  0.344 0.762 0.835 0.555 0.128 0.152   NA    NA -0.137
#> 94   0.796 0.799  0.503  0.366 0.774 0.817 0.591 0.088 0.137   NA    NA -0.046
#> 95   0.847 0.841  0.555  0.411 0.823 0.820 0.570 0.107 0.143 4.52 10.42  0.198
#> 96   0.878 0.872  0.576  0.439 0.835 0.796 0.591 0.070 0.137   NA    NA  0.082
#> 97   0.942 0.939  0.640  0.475 0.896 0.838 0.591 0.082 0.165   NA    NA  0.259
#> 98   0.951 0.942  0.655  0.472 0.908 0.872 0.576 0.113 0.183 4.32 10.39  0.165
#> 99   0.988 0.981  0.689  0.521 0.963 0.887 0.585 0.134 0.168 4.38 10.51  0.311
#> 100  0.988 0.978  0.698  0.570 0.975 0.811 0.561 0.122 0.128 4.42 10.36  0.375
#> 101  1.003 0.997  0.719  0.613 0.988 0.750 0.552 0.091 0.107 4.20 10.30  0.408
#> 102  0.954 0.948  0.677  0.546 0.920 0.747 0.543 0.073 0.131   NA    NA  0.241
#> 103  0.985 0.981  0.710  0.536 0.945 0.823 0.546 0.104 0.174 4.44 10.38  0.155
#> 104  0.853 0.844  0.576  0.393 0.823 0.856 0.536 0.137 0.183 4.21 10.26  0.027
#> 105  0.802 0.796  0.521  0.351 0.774 0.844 0.552 0.125 0.171 4.49 10.39 -0.058
#> 106  0.838 0.829  0.536  0.369 0.789 0.838 0.582 0.088 0.168   NA    NA -0.049
#> 107  0.869 0.856  0.555  0.424 0.838 0.832 0.604 0.094 0.131   NA    NA -0.040
#> 108  0.866 0.866  0.579  0.421 0.835 0.829 0.570 0.101 0.158 4.44 10.45  0.107
#> 109  0.899 0.890  0.594  0.439 0.860 0.844 0.591 0.094 0.158   NA    NA  0.140
#> 110  0.972 0.972  0.695  0.512 0.942 0.856 0.555 0.119 0.183 4.38 10.43  0.247
#> 111  0.936 0.927  0.652  0.472 0.902 0.863 0.552 0.128 0.180 4.44 10.46  0.192
#> 112  0.963 0.957  0.677  0.527 0.945 0.838 0.561 0.128 0.149 4.43 10.37  0.351
#> 113  1.009 1.003  0.710  0.594 0.994 0.802 0.585 0.101 0.116 4.33 10.44  0.375
#> 114  1.030 1.024  0.741  0.619 0.994 0.753 0.564 0.064 0.122   NA    NA  0.387
#> 115  1.003 0.997  0.719  0.539 0.954 0.832 0.558 0.094 0.180 4.27 10.44 -0.037
#> 116  0.978 0.975  0.695  0.485 0.927 0.884 0.558 0.116 0.210 4.15 10.33  0.128
#> 117  0.917 0.908  0.625  0.433 0.875 0.884 0.567 0.125 0.189 4.42 10.48  0.125
#> 118  0.911 0.908  0.628  0.463 0.884 0.838 0.558 0.116 0.165   NA    NA -0.094
#> 119  0.972 0.969  0.674  0.543 0.951 0.817 0.588 0.094 0.131   NA    NA  0.165
#> 120  0.911 0.905  0.604  0.463 0.884 0.841 0.607 0.094 0.140   NA    NA  0.198
#> 121  0.972 0.969  0.689  0.500 0.927 0.860 0.564 0.104 0.189   NA    NA  0.293
#> 122  0.960 0.957  0.677  0.475 0.920 0.887 0.561 0.125 0.201 4.44 10.40  0.155
#> 123  0.966 0.963  0.686  0.506 0.936 0.863 0.555 0.128 0.180 4.25 10.54  0.162
#> 124  0.978 0.972  0.689  0.546 0.960 0.832 0.567 0.119 0.143 4.43 10.50  0.277
#> 125  1.003 0.997  0.707  0.570 0.981 0.820 0.576 0.107 0.137 4.42 10.36  0.378
#> 126  1.058 1.049  0.756  0.613 1.018 0.814 0.588 0.082 0.143   NA    NA  0.320
#> 127  1.052 1.045  0.765  0.604 1.015 0.823 0.564 0.098 0.162   NA    NA  0.317
#> 128  0.860 0.860  0.591  0.378 0.817 0.878 0.536 0.131 0.210 4.41 10.35 -0.030
#> 129  0.856 0.856  0.576  0.360 0.820 0.917 0.567 0.137 0.213 4.49 10.34 -0.052
#> 130  0.838 0.820  0.500  0.351 0.792 0.887 0.643 0.091 0.149   NA    NA  0.058
#> 131  0.863 0.860  0.539  0.408 0.829 0.841 0.637 0.073 0.134   NA    NA  0.113
#> 132  0.924 0.917  0.616  0.479 0.890 0.820 0.607 0.076 0.137   NA    NA  0.165
#> 133  0.914 0.911  0.607  0.424 0.869 0.893 0.610 0.101 0.183   NA    NA  0.082
#> 134  0.997 0.994  0.704  0.497 0.963 0.930 0.579 0.143 0.207 4.42 10.38  0.198
#> 135  1.021 1.012  0.710  0.515 0.981 0.933 0.607 0.131 0.195 4.18 10.36  0.238
#> 136  1.006 1.000  0.713  0.558 0.978 0.838 0.576 0.110 0.152 4.38 10.37  0.213
#> 137  1.045 1.033  0.741  0.616 1.021 0.808 0.588 0.094 0.125   NA    NA  0.412
#> 138  1.064 1.061  0.768  0.625 1.030 0.811 0.588 0.079 0.143   NA    NA  0.390
#> 139  0.994 0.988  0.716  0.564 0.954 0.783 0.539 0.088 0.155   NA    NA -0.055
#> 140  0.948 0.945  0.671  0.463 0.899 0.869 0.549 0.116 0.207 4.30 10.45  0.119
#> 141  0.905 0.902  0.631  0.448 0.881 0.866 0.543 0.140 0.183   NA    NA  0.012
#> 142  0.841 0.841  0.539  0.384 0.814 0.860 0.604 0.101 0.155   NA    NA  0.070
#> 143  0.866 0.850  0.536  0.418 0.829 0.826 0.631 0.076 0.119   NA    NA  0.091
#> 144  0.881 0.878  0.567  0.421 0.847 0.850 0.619 0.085 0.146   NA    NA  0.143
#> 145  0.951 0.948  0.649  0.466 0.905 0.875 0.594 0.098 0.183   NA    NA  0.177
#> 146  0.951 0.954  0.664  0.442 0.908 0.939 0.579 0.137 0.223 4.43 10.41  0.149
#> 147  0.966 0.966  0.677  0.485 0.939 0.905 0.576 0.137 0.192   NA    NA  0.162
#> 148  1.082 1.067  0.765  0.646 1.067 0.838 0.600 0.119 0.119   NA    NA  0.341
#> 149  1.042 1.027  0.747  0.619 1.015 0.792 0.564 0.101 0.128   NA    NA  0.341
#> 150  1.134 1.140  0.838  0.680 1.100 0.838 0.607 0.073 0.155   NA    NA  0.405
#> 151  1.030 1.024  0.756  0.543 0.978 0.869 0.539 0.116 0.210 4.25 10.28  0.207
#> 152  0.887 0.887  0.616  0.399 0.850 0.899 0.539 0.143 0.216 4.38 10.30 -0.040
#> 153  0.829 0.826  0.539  0.351 0.789 0.878 0.576 0.113 0.186 4.48 10.41 -0.070
#> 154  0.875 0.872  0.543  0.399 0.838 0.881 0.658 0.076 0.143   NA    NA  0.192
#> 155  0.802 0.792  0.463  0.323 0.774 0.905 0.652 0.110 0.140   NA    NA -0.067
#> 156  0.951 0.954  0.637  0.457 0.902 0.890 0.634 0.076 0.180   NA    NA  0.268
#> 157  1.045 1.042  0.750  0.555 1.000 0.887 0.582 0.110 0.195   NA    NA  0.216
#> 158  1.027 1.024  0.741  0.536 0.985 0.899 0.570 0.125 0.204 4.43 10.41  0.229
#> 159  0.978 0.978  0.701  0.512 0.951 0.875 0.555 0.134 0.189 4.40 10.42  0.186
#> 160  0.991 0.985  0.698  0.533 0.963 0.860 0.573 0.122 0.165   NA    NA  0.271
#> 161  1.088 1.079  0.777  0.646 1.061 0.826 0.604 0.094 0.128   NA    NA  0.506
#> 162  1.067 1.061  0.783  0.643 1.036 0.786 0.555 0.091 0.140   NA    NA  0.335
#> 163  1.039 1.039  0.759  0.555 0.985 0.863 0.555 0.101 0.207 4.46 10.49  0.311
#> 164  0.933 0.936  0.652  0.421 0.896 0.948 0.564 0.152 0.232 4.33 10.39  0.101
#> 165  0.899 0.905  0.591  0.427 0.908 0.960 0.628 0.168 0.165   NA    NA     NA
#> 166  0.887 0.896  0.570  0.427 0.884 0.911 0.652 0.116 0.143   NA    NA     NA
#> 167  0.972 0.966  0.622  0.491 0.948 0.917 0.686 0.098 0.131   NA    NA  0.091
#> 168  0.863 0.863  0.561  0.399 0.826 0.853 0.604 0.088 0.158   NA    NA  0.219
#> 169  0.933 0.933  0.637  0.436 0.896 0.920 0.591 0.131 0.198   NA    NA  0.134
#> 170  0.997 0.997  0.722  0.515 0.966 0.899 0.549 0.143 0.204 4.41 10.24  0.280
#> 171  1.009 1.000  0.713  0.546 0.978 0.866 0.573 0.128 0.168   NA    NA  0.253
#> 172  0.985 0.978  0.686  0.539 0.963 0.841 0.585 0.113 0.146   NA    NA  0.259
#> 173  1.009 1.000  0.692  0.567 0.981 0.832 0.619 0.088 0.125   NA    NA  0.442
#> 174  0.887 0.887  0.591  0.427 0.838 0.823 0.588 0.070 0.165   NA    NA  0.158
#> 175  0.978 0.981  0.698  0.503 0.927 0.844 0.561 0.085 0.195   NA    NA -0.046
#> 176  0.917 0.920  0.649  0.424 0.872 0.896 0.546 0.128 0.226   NA    NA  0.012
#> 177  0.808 0.799  0.457  0.332 0.783 0.902 0.680 0.098 0.125   NA    NA -0.064
#> 178     NA 0.957  0.668  0.448 0.920 0.945 0.579 0.146 0.219   NA    NA  0.226
#> 179  0.920 0.911  0.604  0.454 0.893 0.878 0.622 0.110 0.146   NA    NA  0.256
#> 180  0.988 0.972  0.661  0.546 0.966 0.838 0.619 0.104 0.116   NA    NA  0.277
#> 181  0.957 0.948  0.661  0.521 0.924 0.808 0.570 0.094 0.143   NA    NA  0.168
#> 182  0.908 0.902  0.637  0.451 0.869 0.835 0.533 0.119 0.183   NA    NA  0.067
#> 183  0.884 0.875  0.579  0.399 0.847 0.893 0.591 0.125 0.180 4.75 10.68  0.088
#> 184  0.966 0.969  0.671  0.466 0.942 0.951 0.594 0.152 0.204 4.27 10.35  0.195
#> 185  1.009 1.000  0.677  0.570 1.000 0.860 0.649 0.104 0.107   NA    NA  0.375
#> 186  1.036 1.030  0.728  0.622 1.018 0.789 0.600 0.082 0.107   NA    NA  0.411
#> 187  0.954 0.951  0.671  0.512 0.914 0.808 0.561 0.088 0.158   NA    NA  0.177
#> 188  0.957 0.954  0.680  0.469 0.914 0.887 0.552 0.128 0.210   NA    NA -0.015
#> 189  0.820 0.823  0.543  0.323 0.783 0.917 0.564 0.137 0.216   NA    NA -0.079
#> 190  0.777 0.768  0.460  0.305 0.756 0.902 0.622 0.128 0.152   NA    NA -0.009
#> 191  0.823 0.817  0.512  0.378 0.811 0.863 0.610 0.119 0.134   NA    NA  0.073
#> 192  0.960 0.966  0.643  0.503 0.942 0.881 0.643 0.094 0.143   NA    NA  0.247
#> 193  0.945 0.933  0.628  0.479 0.911 0.866 0.607 0.110 0.149   NA    NA  0.241
#> 194  1.027 1.024  0.753  0.579 1.000 0.841 0.543 0.125 0.174 4.43 10.28  0.268
#> 195  0.978 0.975  0.695  0.509 0.948 0.884 0.564 0.134 0.186 4.32 10.46  0.192
#> 196  0.991 0.981  0.695  0.539 0.966 0.856 0.576 0.125 0.155   NA    NA  0.305
#> 197  1.061 1.052  0.750  0.631 1.045 0.832 0.607 0.107 0.119   NA    NA  0.430
#> 198  1.030 1.018  0.716  0.600 1.009 0.817 0.607 0.094 0.116   NA    NA  0.479
#> 199  1.052 1.045  0.765  0.625 1.012 0.774 0.564 0.073 0.140   NA    NA  0.387
#> 200  1.052 1.049  0.780  0.576 1.000 0.844 0.533 0.107 0.204 4.34 10.35 -0.061
#> 201  0.933 0.930  0.643  0.415 0.887 0.945 0.573 0.140 0.229 4.21 10.26  0.058
#> 202  0.963 0.960  0.646  0.488 0.948 0.920 0.628 0.134 0.158   NA    NA  0.140
#> 203  0.872 0.863  0.552  0.433 0.850 0.832 0.622 0.091 0.119   NA    NA  0.073
#> 204  0.954 0.948  0.634  0.497 0.930 0.869 0.628 0.101 0.137   NA    NA  0.186
#> 205  1.018 1.012  0.695  0.552 0.985 0.866 0.631 0.091 0.143   NA    NA  0.238
#> 206  1.106 1.100  0.817  0.631 1.073 0.884 0.567 0.131 0.186   NA    NA  0.363
#> 207  1.070 1.061  0.780  0.588 1.036 0.896 0.564 0.143 0.189 4.31 10.31  0.293
#> 208  1.091 1.088  0.799  0.634 1.073 0.875 0.582 0.131 0.162 4.27 10.36  0.305
#> 209  1.113 1.103  0.796  0.668 1.100 0.863 0.616 0.116 0.128   NA    NA  0.396
#> 210  1.116 1.109  0.799  0.683 1.100 0.838 0.622 0.098 0.116   NA    NA  0.475
#> 211  1.085 1.079  0.802  0.643 1.052 0.817 0.558 0.101 0.155 4.35 10.37  0.366
#> 212  1.015 1.012  0.741  0.555 0.972 0.835 0.549 0.104 0.186 4.38 10.46  0.000
#> 213  0.887 0.884  0.607  0.408 0.850 0.881 0.558 0.128 0.198   NA    NA  0.003
#> 214  0.920 0.908  0.604  0.451 0.893 0.887 0.616 0.122 0.152   NA    NA  0.085
#> 215  0.960 0.954  0.652  0.491 0.933 0.887 0.600 0.125 0.165   NA    NA  0.305
#> 216  0.890 0.878  0.570  0.460 0.856 0.792 0.613 0.070 0.110   NA    NA  0.219
#> 217  1.000 0.994  0.701  0.555 0.969 0.829 0.582 0.101 0.146   NA    NA  0.326
#> 218  1.003 0.997  0.710  0.509 0.957 0.896 0.573 0.122 0.201 4.53 10.51  0.262
#> 219  1.146 1.140  0.860  0.671 1.116 0.887 0.564 0.134 0.189   NA    NA     NA
#> 220  1.076 1.070  0.771  0.607 1.045 0.881 0.597 0.119 0.165   NA    NA     NA
#> 221  1.073 1.061  0.762  0.637 1.058 0.844 0.600 0.119 0.125   NA    NA -0.143
#> 222  1.113 1.103  0.814  0.695 1.088 0.783 0.582 0.085 0.116   NA    NA  0.567
#> 223  1.137 1.122  0.829  0.692 1.106 0.829 0.582 0.110 0.137   NA    NA  0.469
#> 224  1.033 1.030  0.762  0.576 0.988 0.826 0.536 0.104 0.186 4.16 10.32  0.210
#> 225  0.963 0.960  0.692  0.515 0.933 0.838 0.536 0.125 0.177 4.43 10.41  0.265
#> 226  0.978 0.975  0.680  0.515 0.957 0.881 0.594 0.125 0.162   NA    NA  0.219
#> 227  0.978 0.969  0.664  0.527 0.960 0.866 0.613 0.119 0.137   NA    NA  0.259
#> 228  0.942 0.939  0.701  0.607 0.930 0.649 0.472 0.079 0.098   NA    NA  0.213
#> 229  0.872 0.863  0.587  0.427 0.846 0.839 0.552 0.127 0.160 4.40 10.48  0.064
#> 230  0.828 0.819  0.534  0.413 0.808 0.791 0.570 0.100 0.121 4.31 10.36 -0.130
#> 231  0.833 0.825  0.546  0.440 0.816 0.753 0.558 0.089 0.106   NA    NA -0.027
#> 232  0.897 0.890  0.600  0.461 0.864 0.805 0.579 0.087 0.139 4.46 10.54  0.254
#> 233  0.915 0.908  0.623  0.463 0.878 0.831 0.569 0.102 0.160 4.41 10.53  0.244
#> 234  0.918 0.912  0.630  0.469 0.897 0.856 0.565 0.130 0.161 4.36 10.49  0.242
#> 235  0.972 0.964  0.680  0.532 0.955 0.846 0.568 0.130 0.148 4.31 10.42  0.204
#> 236  1.023 1.008  0.713  0.610 1.008 0.795 0.591 0.101 0.103 4.32 10.50  0.378
#> 237  1.061 1.051  0.768  0.667 1.043 0.752 0.566 0.085 0.101 4.37 10.51  0.572
#> 238  1.098 1.088  0.818  0.689 1.069 0.760 0.540 0.091 0.129 4.36 10.40  0.408
#> 239  1.015 1.006  0.735  0.580 0.973 0.786 0.542 0.089 0.155 4.43 10.53  0.155
#> 240  0.912 0.906  0.641  0.461 0.870 0.818 0.530 0.108 0.180 4.29 10.34  0.164
#> 241  0.880 0.874  0.589  0.441 0.854 0.825 0.569 0.108 0.148 4.33 10.43  0.032
#> 242  0.866 0.858  0.564  0.434 0.843 0.818 0.588 0.100 0.130 4.44 10.57  0.202
#> 243  0.935 0.928  0.641  0.529 0.912 0.766 0.574 0.080 0.112   NA    NA  0.053
#> 244  0.959 0.949  0.655  0.530 0.926 0.792 0.588 0.079 0.125   NA    NA     NA
#> 245  0.967 0.960  0.672  0.539 0.935 0.793 0.576 0.084 0.133   NA    NA     NA
#> 246  1.004 0.998  0.718  0.554 0.974 0.839 0.559 0.116 0.164 4.36 10.45  0.289
#> 247  1.008 0.998  0.716  0.547 0.971 0.848 0.564 0.115 0.169 4.41 10.53  0.233
#> 248  1.022 1.013  0.731  0.604 1.002 0.797 0.564 0.106 0.127 4.40 10.53  0.410
#> 249  1.076 1.068  0.787  0.681 1.054 0.745 0.561 0.078 0.106 4.44 10.47  0.508
#> 250  1.044 1.038  0.764  0.651 1.014 0.725 0.548 0.064 0.113 4.27 10.46  0.400
#> 251  0.954 0.948  0.676  0.508 0.914 0.811 0.543 0.100 0.168 4.35 10.43  0.043
#> 252  0.877 0.874  0.608  0.434 0.846 0.824 0.532 0.118 0.174 4.37 10.45  0.027
#> 253  0.883 0.878  0.594  0.428 0.841 0.826 0.567 0.093 0.166 4.42 10.60 -0.212
#> 254  0.975 0.970  0.676  0.543 0.956 0.826 0.587 0.106 0.133 4.47 10.63  0.156
#> 255  0.932 0.916  0.612  0.503 0.894 0.783 0.607 0.067 0.109   NA    NA  0.214
#> 256  0.954 0.952  0.681  0.531 0.916 0.771 0.542 0.079 0.150 4.67 10.61  0.309
#> 257  1.015 1.008  0.729  0.553 0.959 0.812 0.558 0.078 0.176 4.51 10.60  0.330
#> 258  0.975 0.972  0.687  0.520 0.940 0.839 0.569 0.103 0.167 4.43 10.64  0.256
#> 259  0.971 0.967  0.696  0.553 0.950 0.793 0.542 0.108 0.143 4.48 10.56  0.340
#> 260  1.016 1.008  0.742  0.618 1.000 0.763 0.533 0.106 0.124 4.42 10.39  0.416
#> 261  1.167 1.159  0.880  0.763 1.144 0.763 0.558 0.088 0.117   NA    NA  0.451
#> 262  1.053 1.046  0.771  0.632 1.008 0.753 0.550 0.064 0.139 4.62 10.70  0.188
#> 263  0.971 0.964  0.679  0.527 0.922 0.791 0.570 0.069 0.152 4.55 10.62  0.157
#> 264  0.927 0.920  0.636  0.453 0.884 0.861 0.569 0.109 0.183 4.34 10.51  0.146
#> 265  0.926 0.927  0.640  0.461 0.908 0.893 0.574 0.140 0.179 4.39 10.45  0.166
#> 266  0.978 0.972  0.686  0.551 0.958 0.814 0.572 0.107 0.135   NA    NA  0.105
#> 267  0.958 0.950  0.659  0.547 0.930 0.767 0.581 0.074 0.112   NA    NA  0.295
#> 268  0.993 0.986  0.699  0.570 0.956 0.773 0.573 0.071 0.129   NA    NA  0.209
#> 269  1.025 1.018  0.744  0.576 0.988 0.824 0.548 0.108 0.168 4.47 10.50  0.274
#> 270  0.993 0.990  0.714  0.531 0.956 0.850 0.551 0.116 0.183 4.41 10.46  0.242
#> 271  1.030 1.025  0.749  0.584 1.001 0.835 0.553 0.117 0.165   NA    NA     NA
#> 272  1.085 1.074  0.793  0.670 1.067 0.794 0.563 0.108 0.123 4.38 10.34  0.441
#> 273  1.173 1.160  0.877  0.780 1.156 0.753 0.567 0.089 0.097   NA    NA  0.617
#> 274  1.077 1.072  0.800  0.659 1.036 0.754 0.545 0.068 0.141   NA    NA  0.306
#> 275  1.000 0.994  0.727  0.557 0.952 0.791 0.533 0.088 0.170 4.41 10.46  0.269
#> 276  0.919 0.916  0.657  0.481 0.884 0.807 0.519 0.112 0.176 4.34 10.42 -0.039
#> 277  0.867 0.863  0.587  0.424 0.832 0.817 0.552 0.102 0.163   NA    NA  0.132
#> 278  0.856 0.846  0.563  0.421 0.826 0.810 0.567 0.101 0.142   NA    NA  0.166
#> 279  0.965 0.958  0.672  0.559 0.944 0.769 0.572 0.084 0.113   NA    NA  0.327
#> 280  0.978 0.967  0.680  0.568 0.964 0.792 0.574 0.106 0.112   NA    NA     NA
#> 281  1.002 0.988  0.684  0.559 0.974 0.831 0.608 0.098 0.125   NA    NA     NA
#> 282  1.007 1.002  0.732  0.548 0.976 0.855 0.541 0.130 0.184 4.32 10.41  0.230
#> 283  1.045 1.038  0.755  0.570 1.011 0.883 0.567 0.131 0.185   NA    NA     NA
#> 284  1.032 1.023  0.728  0.602 1.009 0.814 0.590 0.098 0.126   NA    NA     NA
#> 285  1.102 1.096  0.810  0.703 1.084 0.762 0.571 0.084 0.107   NA    NA  0.484
#> 286  1.051 1.040  0.771  0.642 1.014 0.744 0.538 0.077 0.129   NA    NA  0.415
#> 287  1.037 1.030  0.767  0.584 0.988 0.808 0.526 0.099 0.183 4.41 10.37  0.306
#> 288  0.866 0.866  0.596  0.391 0.826 0.871 0.539 0.127 0.205 4.32 10.33  0.024
#> 289  0.771 0.765  0.495  0.327 0.736 0.817 0.540 0.109 0.168 4.46 10.46 -0.139
#> 290  0.783 0.776  0.472  0.329 0.755 0.852 0.608 0.101 0.143   NA    NA -0.050
#> 291  0.896 0.893  0.597  0.473 0.877 0.808 0.592 0.092 0.124   NA    NA  0.112
#> 292  0.960 0.960  0.685  0.508 0.924 0.831 0.551 0.103 0.177 4.53 10.50  0.259
#> 293  0.929 0.925  0.653  0.474 0.892 0.837 0.544 0.114 0.179 4.37 10.46  0.178
#> 294  1.012 1.008  0.740  0.570 0.990 0.839 0.535 0.134 0.170 4.31 10.31  0.267
#> 295  1.038 1.030  0.767  0.608 1.010 0.803 0.527 0.117 0.159 4.55 10.62  0.341
#> 296  1.071 1.062  0.783  0.680 1.056 0.751 0.559 0.089 0.103   NA    NA  0.470
#> 297  1.039 1.032  0.760  0.633 1.008 0.750 0.543 0.080 0.127   NA    NA  0.247
#> 298  1.035 1.032  0.769  0.578 0.980 0.804 0.526 0.087 0.191 4.37 10.38  0.198
#> 299  0.963 0.960  0.688  0.477 0.916 0.878 0.545 0.122 0.211 4.38 10.42  0.223
#> 300  0.838 0.832  0.547  0.343 0.792 0.898 0.569 0.125 0.204 4.55 10.50  0.014
#> 301  0.862 0.848  0.547  0.418 0.832 0.827 0.602 0.096 0.129   NA    NA  0.178
#> 302  0.883 0.878  0.572  0.437 0.846 0.817 0.611 0.071 0.135   NA    NA  0.234
#> 303  0.960 0.958  0.670  0.507 0.916 0.818 0.577 0.078 0.163   NA    NA  0.325
#> 304  0.986 0.982  0.694  0.517 0.952 0.871 0.576 0.118 0.177   NA    NA  0.224
#> 305  1.042 1.040  0.778  0.577 1.003 0.852 0.523 0.128 0.201 4.42 10.46  0.327
#> 306  1.014 1.010  0.741  0.572 0.986 0.827 0.539 0.119 0.169   NA    NA  0.381
#> 307  1.083 1.075  0.811  0.674 1.066 0.783 0.528 0.118 0.137   NA    NA  0.376
#> 308  1.177 1.174  0.899  0.764 1.148 0.767 0.551 0.081 0.135   NA    NA  0.599
#> 309  1.148 1.138  0.851  0.707 1.104 0.794 0.573 0.077 0.144   NA    NA  0.526
#> 310  0.982 0.968  0.690  0.540 0.946 0.811 0.556 0.105 0.150   NA    NA  0.202
#> 311  0.886 0.884  0.622  0.403 0.836 0.866 0.523 0.124 0.219 4.55 10.48  0.097
#> 312  0.829 0.825  0.557  0.352 0.794 0.885 0.536 0.144 0.205 4.49 10.45  0.110
#> 313  0.865 0.857  0.558  0.406 0.825 0.838 0.598 0.088 0.152   NA    NA  0.142
#> 314  0.973 0.971  0.668  0.537 0.944 0.814 0.606 0.077 0.131   NA    NA  0.114
#> 315  0.999 0.992  0.690  0.554 0.966 0.825 0.605 0.084 0.136   NA    NA  0.311
#> 316  1.005 1.002  0.717  0.513 0.954 0.883 0.569 0.110 0.204 4.43 10.36  0.187
#> 317  1.020 1.020  0.741  0.531 0.984 0.905 0.558 0.137 0.210 4.43 10.30  0.226
#> 318  1.063 1.060  0.772  0.592 1.034 0.885 0.576 0.129 0.180   NA    NA  0.360
#> 319  1.078 1.067  0.775  0.637 1.056 0.837 0.584 0.115 0.138   NA    NA  0.437
#> 320  1.140 1.128  0.830  0.716 1.120 0.808 0.595 0.099 0.114   NA    NA  0.534
#> 321  1.122 1.120  0.822  0.672 1.080 0.815 0.595 0.070 0.150   NA    NA  0.431
#> 322  1.061 1.063  0.783  0.584 1.016 0.863 0.560 0.104 0.199   NA    NA  0.176
#> 323  0.932 0.930  0.677  0.475 0.888 0.827 0.506 0.119 0.202 4.43 10.37  0.111
#> 324  0.911 0.918  0.639  0.443 0.872 0.858 0.559 0.103 0.196   NA    NA  0.098
#> 325  0.875 0.874  0.572  0.410 0.846 0.871 0.603 0.106 0.162   NA    NA -0.002
#> 326  0.925 0.910  0.591  0.475 0.898 0.845 0.637 0.092 0.116   NA    NA  0.285
#> 327  0.955 0.944  0.621  0.485 0.922 0.873 0.647 0.090 0.136   NA    NA  0.292
#> 328  1.006 1.000  0.715  0.550 0.975 0.850 0.569 0.116 0.165   NA    NA  0.184
#> 329  1.053 1.048  0.772  0.564 1.012 0.897 0.551 0.138 0.208 4.45 10.35  0.267
#> 330  1.035 1.027  0.747  0.545 1.000 0.911 0.560 0.149 0.202 4.40 10.26  0.226
#> 331  1.046 1.036  0.731  0.592 1.026 0.869 0.610 0.120 0.139   NA    NA  0.167
#> 332  1.110 1.100  0.824  0.707 1.094 0.774 0.552 0.105 0.117   NA    NA  0.464
#> 333  1.111 1.110  0.818  0.678 1.079 0.802 0.583 0.079 0.140   NA    NA  0.425
#> 334  1.080 1.076  0.812  0.627 1.040 0.826 0.529 0.112 0.185   NA    NA  0.261
#> 335  0.877 0.871  0.596  0.391 0.828 0.874 0.550 0.119 0.205 4.31 10.45 -0.196
#> 336  0.924 0.922  0.639  0.454 0.889 0.870 0.566 0.119 0.185   NA    NA  0.022
#> 337  0.992 0.988  0.661  0.523 0.961 0.876 0.655 0.083 0.138   NA    NA  0.211
#> 338  0.875 0.882  0.561  0.437 0.848 0.823 0.641 0.058 0.124   NA    NA  0.144
#> 339  0.998 1.002  0.681  0.513 0.955 0.884 0.643 0.073 0.168   NA    NA  0.224
#> 340  1.032 1.026  0.728  0.536 0.986 0.901 0.595 0.114 0.192   NA    NA  0.308
#> 341  1.071 1.071  0.798  0.584 1.027 0.886 0.546 0.126 0.214 4.37 10.32  0.243
#> 342  1.083 1.066  0.780  0.602 1.052 0.900 0.573 0.149 0.178   NA    NA  0.355
#> 343  1.083 1.062  0.763  0.617 1.054 0.874 0.598 0.130 0.146   NA    NA  0.370
#> 344  1.140 1.132  0.842  0.720 1.116 0.791 0.580 0.089 0.122   NA    NA  0.467
#> 345  1.076 1.072  0.788  0.643 1.040 0.794 0.567 0.082 0.145   NA    NA  0.252
#> 346  0.999 0.998  0.727  0.525 0.953 0.856 0.542 0.112 0.202   NA    NA  0.200
#> 347  0.902 0.899  0.623  0.392 0.854 0.924 0.552 0.141 0.231 4.40 10.21  0.163
#> 348  0.877 0.877  0.582  0.376 0.842 0.932 0.590 0.136 0.206   NA    NA -0.021
#> 349  0.889 0.884  0.593  0.456 0.865 0.818 0.582 0.099 0.137   NA    NA  0.048
#> 350  0.942 0.934  0.612  0.481 0.914 0.865 0.643 0.091 0.131   NA    NA  0.228
#> 351  0.961 0.955  0.663  0.505 0.924 0.837 0.584 0.095 0.158   NA    NA  0.156
#> 352  1.021 1.022  0.728  0.547 0.975 0.856 0.587 0.088 0.181   NA    NA  0.309
#> 353  1.010 1.012  0.741  0.542 0.975 0.866 0.542 0.125 0.199   NA    NA  0.309
#> 354  0.985 0.977  0.693  0.538 0.963 0.850 0.568 0.127 0.155   NA    NA     NA
#> 355  1.054 1.046  0.757  0.625 1.040 0.831 0.577 0.122 0.132   NA    NA  0.379
#> 356  1.129 1.128  0.821  0.698 1.110 0.824 0.613 0.088 0.123   NA    NA  0.482
#> 357  1.089 1.078  0.781  0.646 1.058 0.825 0.595 0.095 0.135   NA    NA  0.163
#> 358  0.989 0.985  0.727  0.547 0.944 0.794 0.516 0.098 0.180   NA    NA  0.180
#> 359  0.916 0.918  0.649  0.417 0.868 0.902 0.537 0.133 0.232 4.62 10.43  0.012
#> 360  0.901 0.896  0.606  0.418 0.870 0.905 0.580 0.137 0.188   NA    NA  0.175
#> 361  0.859 0.839  0.556  0.420 0.837 0.834 0.566 0.132 0.136   NA    NA  0.105
#> 362  0.876 0.866  0.554  0.418 0.844 0.852 0.624 0.092 0.136   NA    NA  0.160
#> 363  0.925 0.918  0.623  0.468 0.882 0.827 0.590 0.082 0.155   NA    NA  0.160
#> 364  1.044 1.042  0.753  0.559 1.014 0.910 0.579 0.137 0.194   NA    NA  0.296
#> 365  1.050 1.046  0.768  0.561 1.019 0.916 0.555 0.154 0.207   NA    NA  0.318
#> 366  1.038 1.038  0.763  0.567 1.014 0.893 0.550 0.147 0.196 4.28 10.15  0.337
#> 367  1.083 1.075  0.786  0.653 1.070 0.833 0.578 0.122 0.133   NA    NA  0.476
#> 368  1.088 1.078  0.793  0.674 1.076 0.804 0.570 0.115 0.119   NA    NA  0.357
#> 369  1.107 1.089  0.797  0.653 1.070 0.834 0.584 0.106 0.144   NA    NA  0.233
#> 370  0.990 0.986  0.721  0.524 0.942 0.836 0.531 0.108 0.197 4.31 10.23  0.188
#> 371  0.930 0.926  0.661  0.454 0.886 0.863 0.531 0.125 0.207 4.40 10.37  0.143
#> 372  0.849 0.863  0.545  0.376 0.826 0.900 0.636 0.095 0.169   NA    NA -0.195
#> 373  0.853 0.858  0.544  0.393 0.824 0.861 0.627 0.083 0.151   NA    NA  0.109
#> 374  0.866 0.860  0.571  0.430 0.840 0.821 0.579 0.101 0.141   NA    NA  0.222
#> 375  0.992 0.979  0.674  0.547 0.969 0.844 0.610 0.107 0.127   NA    NA  0.241
#> 376  1.091 1.088  0.807  0.617 1.060 0.887 0.563 0.134 0.190   NA    NA  0.246
#> 377  1.120 1.113  0.829  0.695 1.098 0.807 0.568 0.105 0.134   NA    NA  0.520
#> 378  1.228 1.224  0.946  0.855 1.218 0.727 0.557 0.079 0.091   NA    NA  0.597
#> 379  1.121 1.116  0.853  0.696 1.094 0.796 0.525 0.114 0.157   NA    NA  0.321
#> 380  1.034 1.033  0.775  0.576 0.990 0.827 0.516 0.112 0.199 4.34 10.25  0.173
#> 381  0.921 0.918  0.641  0.432 0.878 0.892 0.553 0.130 0.209   NA    NA -0.118
#> 382  0.836 0.832  0.537  0.385 0.812 0.854 0.590 0.112 0.152   NA    NA  0.090
#> 383  0.848 0.848  0.529  0.395 0.824 0.859 0.638 0.087 0.134   NA    NA  0.024
#> 384  0.975 0.978  0.666  0.509 0.944 0.871 0.625 0.089 0.157   NA    NA  0.270
#> 385  0.983 0.976  0.660  0.535 0.958 0.847 0.633 0.089 0.125   NA    NA  0.257
#> 386  1.021 1.019  0.744  0.547 0.983 0.872 0.550 0.125 0.197 4.52 10.46  0.284
#> 387  1.103 1.103  0.821  0.637 1.076 0.878 0.564 0.130 0.184 4.47 10.39  0.376
#> 388  1.111 1.098  0.810  0.649 1.086 0.875 0.577 0.137 0.161   NA    NA  0.315
#> 389  1.124 1.108  0.815  0.688 1.108 0.841 0.586 0.128 0.127   NA    NA  0.436
#> 390  1.230 1.222  0.936  0.819 1.208 0.778 0.572 0.089 0.117   NA    NA  0.666
#> 391  1.114 1.112  0.846  0.643 1.058 0.831 0.531 0.097 0.203 4.42 10.39  0.287
#> 392  1.026 1.018  0.737  0.533 0.986 0.905 0.563 0.138 0.204   NA    NA  0.175
#> 393  0.921 0.918  0.609  0.435 0.896 0.921 0.619 0.128 0.174   NA    NA  0.040
#> 394  0.930 0.919  0.596  0.477 0.916 0.877 0.646 0.112 0.119   NA    NA  0.040
#> 395  0.960 0.958  0.666  0.499 0.924 0.849 0.583 0.099 0.167   NA    NA  0.258
#> 396  1.028 1.022  0.748  0.570 0.994 0.849 0.549 0.122 0.178 4.50 10.33  0.345
#> 397  1.079 1.072  0.784  0.598 1.048 0.899 0.577 0.136 0.186 4.37 10.28  0.327
#> 398  1.145 1.138  0.848  0.722 1.126 0.807 0.580 0.101 0.126   NA    NA  0.456
#> 399  1.196 1.186  0.889  0.758 1.172 0.827 0.595 0.101 0.131   NA    NA  0.603
#> 400  1.089 1.084  0.805  0.636 1.047 0.822 0.557 0.096 0.169 4.30 10.27  0.463
#> 401  1.044 1.043  0.772  0.582 1.000 0.837 0.542 0.105 0.190 4.35 10.38  0.097
#> 402  0.884 0.876  0.602  0.395 0.846 0.903 0.548 0.148 0.207 4.52 10.50  0.162
#> 403  0.860 0.862  0.551  0.373 0.836 0.926 0.622 0.126 0.178   NA    NA  0.189
#> 404  0.855 0.852  0.531  0.409 0.850 0.881 0.643 0.116 0.122   NA    NA  0.172
#> 405  0.967 0.958  0.637  0.530 0.947 0.834 0.641 0.086 0.107   NA    NA  0.245
#> 406  0.989 0.984  0.696  0.540 0.954 0.828 0.576 0.096 0.156   NA    NA  0.267
#> 407  1.025 1.020  0.734  0.556 0.990 0.868 0.571 0.119 0.178 4.36 10.39  0.295
#> 408  1.062 1.053  0.756  0.580 1.034 0.907 0.594 0.137 0.176   NA    NA  0.255
#> 409  1.122 1.114  0.818  0.660 1.106 0.891 0.593 0.140 0.158 4.38 10.31  0.436
#> 410  1.136 1.127  0.808  0.704 1.130 0.852 0.638 0.110 0.104   NA    NA  0.467
#> 411  1.130 1.118  0.814  0.710 1.114 0.809 0.608 0.097 0.104   NA    NA  0.452
#> 412  1.070 1.068  0.783  0.641 1.048 0.815 0.569 0.104 0.142   NA    NA  0.318
#> 413  1.056 1.054  0.780  0.599 1.022 0.845 0.549 0.115 0.181 4.30 10.39  0.195
#> 414  0.987 0.988  0.721  0.530 0.944 0.829 0.533 0.105 0.191 4.03  9.91  0.197
#> 415  0.917 0.915  0.622  0.473 0.899 0.852 0.586 0.117 0.149   NA    NA  0.262
#> 416  0.968 0.960  0.666  0.521 0.946 0.850 0.588 0.117 0.145   NA    NA  0.294
#> 417  1.016 1.001  0.694  0.594 0.994 0.800 0.614 0.086 0.100   NA    NA  0.291
#> 418  1.068 1.061  0.782  0.636 1.040 0.809 0.558 0.105 0.146 4.23 10.41  0.361
#> 419  1.103 1.098  0.812  0.647 1.072 0.851 0.573 0.113 0.165 4.44 10.36  0.362
#> 420  1.211 1.207  0.918  0.741 1.182 0.883 0.578 0.128 0.177   NA    NA  0.323
#> 421  1.140 1.129  0.825  0.665 1.115 0.900 0.608 0.132 0.160 4.24 10.33  0.373
#> 422  1.151 1.143  0.856  0.754 1.137 0.766 0.574 0.090 0.102 4.29 10.25  0.607
#> 423  1.134 1.129  0.841  0.704 1.105 0.802 0.576 0.089 0.137 4.26 10.38  0.489
#> 424  1.126 1.120  0.837  0.664 1.086 0.843 0.565 0.105 0.173 4.32 10.37  0.381
#> 425  1.041 1.036  0.747  0.571 1.002 0.863 0.578 0.109 0.176   NA    NA  0.092
#> 426  0.978 0.971  0.672  0.512 0.960 0.896 0.598 0.138 0.160 4.13 10.17  0.293
#> 427  0.978 0.974  0.671  0.554 0.964 0.821 0.605 0.099 0.117   NA    NA  0.261
#> 428  0.972 0.957  0.656  0.556 0.958 0.803 0.602 0.101 0.100   NA    NA  0.297
#> 429  0.997 0.986  0.692  0.538 0.961 0.846 0.588 0.104 0.154 4.37 10.45  0.268
#> 430  1.019 1.016  0.744  0.560 0.976 0.832 0.544 0.104 0.184 4.33 10.49  0.243
#> 431  1.068 1.064  0.787  0.630 1.046 0.832 0.555 0.120 0.157 4.46 10.54  0.343
#> 432  1.134 1.126  0.860  0.727 1.116 0.778 0.531 0.114 0.133   NA    NA  0.427
#> 433  1.132 1.122  0.846  0.720 1.114 0.787 0.552 0.109 0.126 4.33 10.47  0.445
#> 434  1.180 1.176  0.893  0.780 1.161 0.762 0.566 0.083 0.113 4.46 10.44  0.665
#> 435  1.176 1.171  0.895  0.775 1.143 0.736 0.552 0.064 0.120 4.41 10.47  0.562
#> 436  1.024 1.021  0.749  0.552 0.984 0.863 0.544 0.122 0.197 4.28 10.35  0.259
#> 437  0.936 0.930  0.636  0.463 0.914 0.903 0.587 0.143 0.173 4.37 10.42  0.114
#> 438  0.991 0.983  0.691  0.566 0.970 0.809 0.584 0.100 0.125   NA    NA  0.382
#> 439  0.996 0.988  0.672  0.561 0.966 0.811 0.631 0.069 0.111   NA    NA  0.261
#> 440  1.056 1.050  0.755  0.615 1.022 0.814 0.590 0.084 0.140 4.42 10.51  0.435
#> 441  1.080 1.082  0.806  0.631 1.046 0.829 0.551 0.103 0.175 4.52 10.53  0.163
#> 442  1.136 1.127  0.843  0.727 1.124 0.793 0.568 0.109 0.116 4.40 10.45  0.457
#> 443  1.185 1.180  0.894  0.789 1.168 0.757 0.571 0.081 0.105   NA    NA  0.606
#> 444  1.168 1.162  0.891  0.753 1.130 0.754 0.543 0.073 0.138 4.28 10.34  0.527
#> 445  1.081 1.074  0.804  0.641 1.043 0.804 0.541 0.100 0.163 4.20 10.37  0.432
#> 446  1.110 1.102  0.826  0.650 1.065 0.830 0.553 0.101 0.176 4.38 10.50  0.429
#> 447  0.983 0.978  0.691  0.515 0.952 0.873 0.573 0.124 0.176 4.53 10.44  0.071
#> 448  1.052 1.048  0.758  0.624 1.033 0.818 0.579 0.105 0.134 4.33 10.31  0.286
#> 449  0.985 0.980  0.694  0.568 0.960 0.783 0.571 0.086 0.126 4.60 10.58  0.322
#> 450  1.071 1.066  0.780  0.625 1.042 0.833 0.571 0.107 0.155 4.43 10.50  0.433
#> 451  1.078 1.072  0.796  0.628 1.049 0.842 0.551 0.123 0.168 4.33 10.33  0.453
#> 452  1.119 1.110  0.819  0.663 1.090 0.855 0.581 0.118 0.156 4.35 10.38  0.387
#> 453  1.184 1.174  0.881  0.766 1.173 0.814 0.587 0.112 0.115 4.36 10.44  0.484
#> 454  1.199 1.192  0.910  0.818 1.189 0.742 0.563 0.087 0.092 4.21 10.43  0.698
#> 455  1.291 1.284  1.005  0.873 1.255 0.764 0.559 0.073 0.132 4.14 10.36  0.648
#> 456  1.177 1.169  0.897  0.736 1.132 0.792 0.544 0.087 0.161 4.33 10.47  0.353
#> 457  1.143 1.139  0.876  0.703 1.104 0.801 0.526 0.102 0.173 4.15 10.33  0.403
#> 458  1.092 1.085  0.817  0.669 1.078 0.819 0.536 0.135 0.148 4.19 10.31  0.240
#> 459  1.023 1.010  0.736  0.590 0.990 0.799 0.547 0.106 0.146 4.53 10.46  0.266
#> 460  1.026 1.020  0.737  0.616 1.003 0.774 0.566 0.087 0.121 4.45 10.32  0.309
#> 461  1.102 1.099  0.822  0.673 1.068 0.789 0.554 0.086 0.149 4.48 10.45  0.293
#> 462  1.133 1.128  0.855  0.708 1.097 0.778 0.547 0.084 0.147 4.53 10.48  0.481
#> 463  1.130 1.126  0.846  0.696 1.103 0.814 0.560 0.104 0.150 4.33 10.44  0.438
#> 464  1.117 1.104  0.822  0.665 1.082 0.834 0.564 0.113 0.157 4.46 10.45  0.385
#> 465  1.187 1.176  0.885  0.774 1.174 0.799 0.581 0.107 0.111 4.44 10.51  0.541
#> 466  1.237 1.228  0.945  0.842 1.216 0.748 0.566 0.079 0.103 4.40 10.42  0.661
#> 467  1.175 1.166  0.889  0.774 1.134 0.719 0.555 0.049 0.115 4.42 10.49  0.635
#> 468  1.172 1.169  0.896  0.732 1.127 0.790 0.546 0.080 0.164 4.27 10.41  0.518
#> 469  1.038 1.030  0.764  0.584 0.992 0.817 0.532 0.105 0.180 4.19 10.28  0.233
#> 470  1.046 1.037  0.760  0.595 1.016 0.843 0.554 0.124 0.165 4.30 10.48  0.052
#> 471  0.961 0.950  0.670  0.539 0.933 0.788 0.559 0.098 0.131 4.55 10.37  0.095
#> 472  0.960 0.950  0.644  0.529 0.925 0.792 0.611 0.066 0.115   NA    NA  0.355
#> 473  1.086 1.076  0.788  0.662 1.054 0.784 0.577 0.081 0.126   NA    NA  0.456
#> 474  1.074 1.070  0.793  0.617 1.023 0.812 0.555 0.081 0.176 4.37 10.45  0.256
#> 475  1.122 1.117  0.844  0.674 1.086 0.823 0.546 0.107 0.170 4.35 10.36  0.441
#> 476  1.121 1.112  0.838  0.690 1.098 0.815 0.549 0.118 0.148 4.27 10.37  0.399
#> 477  1.176 1.168  0.899  0.777 1.159 0.764 0.539 0.103 0.122 4.39 10.47  0.512
#> 478  1.191 1.182  0.894  0.798 1.179 0.762 0.576 0.090 0.096   NA    NA -0.092
#> 479  1.233 1.228  0.962  0.842 1.206 0.727 0.531 0.076 0.120   NA    NA  0.660
#> 480  1.113 1.108  0.831  0.669 1.066 0.795 0.555 0.078 0.162 4.23 10.35  0.433
#> 481  1.037 1.034  0.748  0.551 0.994 0.886 0.571 0.118 0.197 4.36 10.38  0.257
#> 482  0.880 0.872  0.587  0.397 0.837 0.880 0.569 0.121 0.190 4.40 10.40 -0.149
#> 483  0.976 0.966  0.678  0.536 0.946 0.821 0.577 0.102 0.142   NA    NA  0.265
#> 484  1.079 1.068  0.766  0.668 1.058 0.780 0.604 0.078 0.098   NA    NA  0.382
#> 485  1.045 1.034  0.736  0.599 1.001 0.804 0.597 0.070 0.137   NA    NA  0.352
#> 486  1.086 1.084  0.813  0.637 1.052 0.829 0.541 0.112 0.176 4.33 10.38  0.396
#> 487  1.049 1.046  0.769  0.585 1.011 0.852 0.554 0.114 0.184 4.32 10.40  0.320
#> 488  1.128 1.121  0.842  0.678 1.097 0.838 0.558 0.116 0.164 4.50 10.41  0.328
#> 489  1.173 1.166  0.876  0.744 1.146 0.805 0.580 0.093 0.132 4.38 10.41  0.449
#> 490  1.211 1.198  0.905  0.794 1.184 0.780 0.587 0.082 0.111   NA    NA  0.620
#> 491  1.211 1.202  0.928  0.800 1.176 0.751 0.549 0.074 0.128   NA    NA  0.360
#> 492  1.100 1.100  0.822  0.650 1.050 0.799 0.557 0.070 0.172   NA    NA  0.427
#> 493  1.086 1.083  0.824  0.651 1.052 0.801 0.518 0.110 0.173 4.53 10.53  0.188
#> 494  0.995 0.993  0.717  0.540 0.958 0.836 0.552 0.107 0.177   NA    NA  0.206
#> 495  1.035 1.028  0.730  0.571 1.002 0.863 0.596 0.108 0.159   NA    NA  0.282
#> 496  1.072 1.068  0.775  0.619 1.024 0.810 0.586 0.068 0.156   NA    NA  0.280
#> 497  1.112 1.103  0.809  0.688 1.080 0.784 0.588 0.075 0.121   NA    NA  0.382
#> 498  1.150 1.146  0.857  0.691 1.110 0.838 0.578 0.094 0.166   NA    NA  0.493
#> 499  1.175 1.172  0.898  0.696 1.131 0.870 0.548 0.120 0.202 4.43 10.45  0.473
#> 500  1.178 1.168  0.885  0.687 1.134 0.893 0.566 0.129 0.198 4.43 10.43  0.453
#> 501  1.185 1.179  0.886  0.735 1.164 0.859 0.586 0.122 0.151 4.40 10.42  0.427
#> 502  1.207 1.197  0.908  0.792 1.179 0.774 0.578 0.080 0.116   NA    NA  0.689
#> 503  1.362 1.356  1.079  0.937 1.324 0.775 0.555 0.078 0.142   NA    NA  0.683
#> 504  1.230 1.225  0.938  0.768 1.192 0.849 0.574 0.105 0.170   NA    NA  0.397
#> 505  1.097 1.088  0.816  0.620 1.050 0.860 0.544 0.120 0.196   NA    NA  0.345
#> 506  1.046 1.038  0.765  0.576 1.004 0.856 0.546 0.121 0.189 4.30 10.28  0.126
#> 507  1.006 1.001  0.722  0.573 0.982 0.819 0.558 0.112 0.149   NA    NA  0.176
#> 508  1.034 1.018  0.716  0.592 0.998 0.812 0.605 0.083 0.124   NA    NA  0.055
#> 509  1.149 1.143  0.850  0.702 1.107 0.810 0.586 0.076 0.148   NA    NA  0.458
#> 510  1.096 1.098  0.811  0.616 1.046 0.860 0.573 0.092 0.195 4.56 10.55  0.262
#> 511  1.177 1.180  0.896  0.712 1.146 0.868 0.568 0.116 0.184 4.48 10.56  0.496
#> 512  1.158 1.157  0.886  0.697 1.124 0.855 0.542 0.124 0.189 4.55 10.41  0.498
#> 513  1.207 1.203  0.926  0.766 1.182 0.832 0.554 0.118 0.160 4.46 10.42  0.503
#> 514  1.271 1.256  0.985  0.881 1.253 0.744 0.542 0.098 0.104   NA    NA  0.666
#> 515  1.296 1.284  1.003  0.874 1.251 0.754 0.563 0.062 0.129   NA    NA  0.589
#> 516  1.179 1.177  0.907  0.722 1.134 0.824 0.540 0.099 0.185   NA    NA  0.182
#> 517  1.022 1.024  0.760  0.548 0.986 0.876 0.527 0.137 0.212 4.46 10.31  0.212
#> 518  0.998 0.992  0.715  0.524 0.964 0.880 0.554 0.135 0.191 4.37 10.27  0.147
#> 519  1.041 1.046  0.754  0.590 1.006 0.833 0.585 0.084 0.164   NA    NA  0.339
#> 520  1.056 1.054  0.733  0.596 1.020 0.847 0.641 0.069 0.137   NA    NA  0.202
#> 521  1.108 1.112  0.803  0.624 1.071 0.894 0.619 0.096 0.179   NA    NA  0.221
#> 522  1.071 1.062  0.757  0.589 1.026 0.875 0.610 0.097 0.168   NA    NA  0.347
#> 523  1.142 1.142  0.866  0.666 1.104 0.875 0.552 0.123 0.200 4.40 10.45  0.303
#> 524  1.130 1.122  0.847  0.690 1.106 0.832 0.549 0.126 0.157   NA    NA  0.418
#> 525  1.211 1.200  0.908  0.777 1.186 0.817 0.584 0.102 0.131   NA    NA  0.555
#> 526  1.213 1.204  0.912  0.781 1.181 0.800 0.584 0.085 0.131   NA    NA  0.608
#> 527  1.275 1.264  0.975  0.848 1.244 0.792 0.579 0.086 0.127   NA    NA  0.681
#> 528  1.171 1.168  0.908  0.721 1.120 0.799 0.521 0.091 0.187 4.50 10.47  0.460
#> 529  1.116 1.114  0.838  0.621 1.068 0.895 0.553 0.125 0.217 4.37 10.44  0.335
#> 530  1.079 1.073  0.802  0.596 1.044 0.895 0.542 0.147 0.206 4.40 10.42  0.223
#> 531  1.040 1.035  0.738  0.579 1.012 0.866 0.594 0.113 0.159   NA    NA  0.248
#> 532  1.052 1.048  0.729  0.587 1.020 0.867 0.639 0.086 0.142   NA    NA  0.024
#> 533  1.097 1.096  0.794  0.629 1.059 0.860 0.603 0.092 0.165   NA    NA  0.303
#> 534  1.182 1.180  0.900  0.691 1.131 0.880 0.559 0.112 0.209 4.50 10.35  0.437
#> 535  1.168 1.166  0.900  0.696 1.137 0.882 0.531 0.147 0.204 4.50 10.28  0.357
#> 536  1.162 1.161  0.891  0.702 1.134 0.864 0.540 0.135 0.189 4.36 10.25  0.391
#> 537  1.218 1.211  0.933  0.789 1.195 0.812 0.556 0.112 0.144   NA    NA  0.494
#> 538  1.223 1.215  0.913  0.775 1.202 0.855 0.604 0.113 0.138   NA    NA -0.123
#> 539  1.224 1.218  0.930  0.781 1.190 0.817 0.577 0.091 0.149   NA    NA  0.612
#> 540  1.199 1.192  0.925  0.747 1.150 0.806 0.534 0.094 0.178   NA    NA  0.450
#> 541  1.146 1.143  0.876  0.669 1.104 0.870 0.534 0.129 0.207 4.29 10.39  0.180
#> 542  1.055 1.054  0.785  0.589 1.026 0.874 0.538 0.140 0.196   NA    NA  0.277
#> 543  1.013 1.008  0.715  0.545 0.972 0.854 0.587 0.097 0.170   NA    NA  0.111
#> 544  1.142 1.141  0.849  0.701 1.112 0.822 0.584 0.090 0.148   NA    NA  0.411
#> 545  1.153 1.138  0.837  0.674 1.104 0.859 0.603 0.093 0.163   NA    NA  0.417
#> 546  1.143 1.145  0.868  0.678 1.106 0.856 0.554 0.112 0.190   NA    NA  0.455
#> 547  1.222 1.220  0.937  0.734 1.193 0.918 0.566 0.149 0.203 4.41 10.24  0.368
#> 548  1.139 1.138  0.856  0.639 1.100 0.921 0.564 0.140 0.217 4.58 10.40  0.411
#> 549  1.211 1.192  0.887  0.735 1.184 0.899 0.609 0.138 0.152   NA    NA  0.410
#> 550  1.211 1.202  0.910  0.779 1.188 0.817 0.584 0.102 0.131   NA    NA  0.660
#> 551  1.266 1.260  0.978  0.820 1.228 0.815 0.565 0.092 0.158   NA    NA  0.522
#> 552  1.208 1.208  0.943  0.739 1.164 0.850 0.531 0.115 0.204 4.50 10.32  0.282
#> 553  1.117 1.113  0.839  0.618 1.080 0.924 0.548 0.155 0.221 4.39 10.24  0.216
#> 554  1.023 1.028  0.750  0.552 0.990 0.876 0.557 0.121 0.198   NA    NA  0.173
#> 555  1.044 1.050  0.766  0.594 1.023 0.858 0.569 0.117 0.172   NA    NA  0.295
#> 556  1.064 1.054  0.745  0.593 1.031 0.876 0.619 0.105 0.152   NA    NA  0.278
#> 557  1.100 1.094  0.781  0.651 1.075 0.848 0.626 0.092 0.130   NA    NA  0.448
#> 558  1.165 1.165  0.887  0.698 1.126 0.857 0.556 0.112 0.189   NA    NA  0.462
#> 559  1.179 1.181  0.907  0.729 1.156 0.853 0.548 0.127 0.178   NA    NA  0.520
#> 560  1.162 1.158  0.886  0.695 1.136 0.882 0.543 0.148 0.191 4.36 10.29  0.442
#> 561  1.205 1.204  0.922  0.763 1.186 0.845 0.565 0.121 0.159   NA    NA  0.536
#> 562  1.365 1.360  1.056  0.918 1.350 0.863 0.607 0.118 0.138   NA    NA  0.737
#> 563  1.238 1.230  0.940  0.789 1.198 0.818 0.581 0.086 0.151   NA    NA  0.382
#> 564  1.242 1.237  0.968  0.785 1.197 0.824 0.538 0.103 0.183   NA    NA  0.306
#> 565  1.020 1.020  0.758  0.528 0.976 0.895 0.523 0.142 0.230 4.47 10.22  0.070
#> 566  0.918 0.918  0.607  0.401 0.876 0.951 0.621 0.124 0.206   NA    NA  0.161
#> 567  0.970 0.980  0.677  0.501 0.946 0.890 0.606 0.108 0.176   NA    NA  0.292
#> 568  1.055 1.054  0.741  0.603 1.022 0.837 0.627 0.072 0.138   NA    NA  0.316
#> 569  1.073 1.065  0.758  0.597 1.038 0.883 0.614 0.108 0.161   NA    NA  0.339
#> 570  1.138 1.136  0.845  0.646 1.095 0.898 0.581 0.118 0.199   NA    NA  0.381
#> 571  1.174 1.172  0.901  0.696 1.140 0.888 0.542 0.141 0.205 4.38 10.29  0.374
#> 572  1.187 1.182  0.915  0.742 1.159 0.834 0.534 0.127 0.173 4.39 10.37  0.465
#> 573  1.235 1.230  0.955  0.812 1.226 0.829 0.549 0.137 0.143 4.26 10.28  0.567
#> 574  1.228 1.226  0.943  0.800 1.210 0.820 0.566 0.111 0.143   NA    NA  0.654
#> 575  1.263 1.257  0.979  0.835 1.222 0.775 0.556 0.075 0.144   NA    NA  0.567
#> 576  1.105 1.104  0.826  0.628 1.059 0.862 0.555 0.109 0.198   NA    NA  0.290
#> 577  0.849 0.841  0.564  0.414 0.804 0.779 0.554 0.075 0.150   NA    NA  0.134
#> 578  0.724 0.714  0.447  0.264 0.677 0.826 0.535 0.108 0.183   NA    NA -0.023
#> 579  0.602 0.596  0.346  0.145 0.558 0.825 0.499 0.125 0.201   NA    NA -0.159
#> 580  0.550 0.561  0.292  0.103 0.514 0.823 0.538 0.096 0.189   NA    NA -0.306
#> 581  0.517 0.496  0.220  0.090 0.482 0.785 0.551 0.104 0.130   NA    NA -0.345
#> 582  0.545 0.538  0.252  0.113 0.510 0.795 0.573 0.083 0.139   NA    NA -0.425
#> 583  0.666 0.646  0.346  0.230 0.628 0.796 0.601 0.079 0.116   NA    NA -0.030
#> 584  0.601 0.604  0.336  0.142 0.553 0.822 0.535 0.093 0.194   NA    NA -0.082
#> 585  0.695 0.688  0.412  0.238 0.662 0.849 0.552 0.123 0.174   NA    NA  0.109
#> 586  0.684 0.682  0.427  0.237 0.652 0.829 0.510 0.129 0.190   NA    NA  0.088
#> 587  0.722 0.710  0.436  0.282 0.690 0.816 0.548 0.114 0.154   NA    NA  0.062
#> 588  0.767 0.754  0.479  0.357 0.740 0.766 0.549 0.095 0.122   NA    NA  0.061
#> 589  0.781 0.761  0.478  0.349 0.726 0.753 0.566 0.058 0.129   NA    NA  0.063
#> 590  0.662 0.665  0.396  0.204 0.614 0.820 0.538 0.090 0.192   NA    NA -0.190
#> 591  0.542 0.552  0.278  0.059 0.498 0.877 0.548 0.110 0.219   NA    NA -0.188
#> 592  0.532 0.524  0.261  0.064 0.492 0.857 0.527 0.133 0.197   NA    NA -0.231
#> 593  0.571 0.570  0.277  0.128 0.534 0.812 0.585 0.078 0.149   NA    NA -0.278
#> 594  0.570 0.578  0.252  0.132 0.538 0.811 0.652 0.039 0.120   NA    NA -0.380
#> 595  0.620 0.636  0.335  0.150 0.580 0.860 0.603 0.072 0.185   NA    NA -0.310
#> 596  0.573 0.563  0.265  0.102 0.532 0.860 0.596 0.101 0.163   NA    NA -0.180
#> 597  0.667 0.667  0.399  0.213 0.639 0.852 0.536 0.130 0.186   NA    NA -0.022
#> 598  0.667 0.656  0.373  0.214 0.638 0.848 0.567 0.122 0.159   NA    NA -0.006
#> 599  0.739 0.722  0.428  0.291 0.708 0.835 0.588 0.110 0.137   NA    NA  0.156
#> 600  0.737 0.724  0.434  0.286 0.694 0.815 0.581 0.086 0.148   NA    NA  0.139
#> 601  0.780 0.766  0.475  0.338 0.732 0.789 0.582 0.070 0.137   NA    NA  0.199
#> 602  0.664 0.650  0.375  0.208 0.605 0.794 0.550 0.077 0.167   NA    NA -0.033
#> 603  0.634 0.626  0.354  0.146 0.579 0.866 0.545 0.113 0.208   NA    NA -0.025
#> 604  0.600 0.598  0.298  0.142 0.568 0.851 0.600 0.095 0.156   NA    NA -0.152
#> 605  0.558 0.562  0.272  0.111 0.528 0.835 0.580 0.094 0.161   NA    NA -0.275
#> 606  0.580 0.566  0.248  0.143 0.552 0.818 0.636 0.077 0.105   NA    NA -0.505
#> 607  0.608 0.608  0.309  0.177 0.578 0.803 0.597 0.074 0.132   NA    NA -0.117
#> 608  0.698 0.689  0.402  0.239 0.658 0.838 0.574 0.101 0.163   NA    NA  0.090
#> 609  0.693 0.686  0.405  0.228 0.664 0.871 0.563 0.131 0.177   NA    NA  0.017
#> 610  0.689 0.684  0.418  0.242 0.658 0.833 0.531 0.126 0.176   NA    NA  0.024
#> 611  0.736 0.726  0.436  0.309 0.710 0.801 0.579 0.095 0.127   NA    NA  0.103
#> 612  0.715 0.732  0.425  0.266 0.696 0.861 0.614 0.088 0.159   NA    NA -1.663
#> 613  0.738 0.724  0.423  0.274 0.690 0.833 0.602 0.082 0.149   NA    NA  0.129
#> 614  0.703 0.691  0.425  0.243 0.658 0.829 0.532 0.115 0.182   NA    NA -0.102
#> 615  0.655 0.659  0.399  0.190 0.608 0.837 0.520 0.108 0.209   NA    NA -0.232
#> 616  0.583 0.566  0.285  0.113 0.542 0.858 0.562 0.124 0.172   NA    NA -0.111
#> 617  0.544 0.528  0.198  0.078 0.496 0.837 0.660 0.057 0.120   NA    NA -0.320
#> 618  0.660 0.659  0.344  0.211 0.630 0.837 0.630 0.074 0.133   NA    NA -0.072
#> 619  0.663 0.652  0.346  0.204 0.614 0.821 0.613 0.066 0.142   NA    NA -0.102
#> 620  0.656 0.639  0.313  0.194 0.619 0.850 0.652 0.079 0.119   NA    NA  0.015
#> 621  0.754 0.742  0.439  0.287 0.728 0.881 0.606 0.123 0.152   NA    NA  0.065
#> 622  0.669 0.658  0.360  0.187 0.628 0.882 0.597 0.112 0.173   NA    NA  0.040
#> 623  0.730 0.698  0.384  0.256 0.698 0.884 0.628 0.128 0.128   NA    NA  0.041
#> 624  0.717 0.704  0.408  0.289 0.688 0.797 0.591 0.087 0.119   NA    NA  0.172
#> 625  0.751 0.742  0.475  0.326 0.709 0.766 0.533 0.084 0.149   NA    NA  0.035
#> 626  0.690 0.684  0.421  0.249 0.640 0.783 0.527 0.084 0.172   NA    NA -0.101
#> 627  0.620 0.610  0.329  0.167 0.591 0.848 0.563 0.123 0.162   NA    NA -0.202
#> 628  0.539 0.543  0.267  0.097 0.508 0.822 0.552 0.100 0.170   NA    NA -0.366
#> 629  0.566 0.560  0.267  0.138 0.542 0.808 0.587 0.092 0.129   NA    NA -0.171
#> 630  0.582 0.570  0.267  0.139 0.558 0.839 0.606 0.105 0.128   NA    NA -0.200
#> 631  0.619 0.597  0.291  0.180 0.595 0.830 0.612 0.107 0.111   NA    NA -0.039
#> 632  0.689 0.686  0.408  0.236 0.659 0.846 0.556 0.118 0.172   NA    NA  0.096
#> 633  0.694 0.692  0.419  0.246 0.668 0.844 0.546 0.125 0.173   NA    NA  0.129
#> 634  0.686 0.670  0.367  0.229 0.660 0.862 0.605 0.119 0.138   NA    NA  0.069
#> 635  0.749 0.754  0.457  0.290 0.716 0.851 0.593 0.091 0.167   NA    NA  0.065
#> 636  0.891 0.864  0.534  0.413 0.863 0.900 0.661 0.118 0.121   NA    NA  0.165
#> 637  0.725 0.707  0.394  0.212 0.654 0.883 0.626 0.075 0.182   NA    NA -0.849
#> 638  0.729 0.722  0.428  0.239 0.670 0.861 0.588 0.084 0.189   NA    NA -0.172
#> 639  0.525 0.506  0.187  0.020 0.472 0.904 0.639 0.098 0.167   NA    NA -0.445
#> 640  0.430 0.422  0.106 -0.065 0.392 0.914 0.632 0.111 0.171   NA    NA -0.339
#> 641  0.491 0.495  0.180  0.032 0.464 0.863 0.630 0.085 0.148   NA    NA -0.271
#> 642  0.578 0.568  0.261  0.136 0.546 0.819 0.614 0.080 0.125   NA    NA -0.135
#> 643  0.586 0.570  0.250  0.121 0.552 0.861 0.641 0.091 0.129   NA    NA -0.079
#> 644  0.663 0.656  0.347  0.174 0.624 0.900 0.619 0.108 0.173   NA    NA  0.022
#> 645  0.693 0.688  0.411  0.213 0.658 0.889 0.554 0.137 0.198   NA    NA  0.006
#> 646  0.706 0.692  0.395  0.255 0.676 0.843 0.595 0.108 0.140   NA    NA  0.031
#> 647  0.756 0.750  0.442  0.318 0.739 0.842 0.617 0.101 0.124   NA    NA  0.094
#> 648  0.720 0.716  0.415  0.284 0.693 0.818 0.603 0.084 0.131   NA    NA  0.142
#> 649  0.728 0.714  0.433  0.284 0.674 0.779 0.562 0.068 0.149   NA    NA  0.042
#> 650  0.603 0.600  0.327  0.144 0.564 0.840 0.545 0.112 0.183   NA    NA -0.198
#> 651  0.417    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 652  0.390    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 653  0.383    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 654  0.296    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 655  0.284    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 656  0.242    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 657  0.258    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 658  0.256    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 659  0.372    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 660  0.405 0.405  0.206  0.057 0.386 0.661 0.396 0.116 0.149 6.28 12.12     NA
#> 661  0.376    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 662  0.521    NA     NA     NA    NA    NA    NA    NA    NA   NA    NA     NA
#> 663  0.351 0.345  0.086 -0.021 0.345 0.732 0.518 0.110 0.107   NA    NA -0.188
#> 664  0.266 0.260  0.019 -0.066 0.263 0.658 0.485 0.088 0.085   NA    NA -0.316
#> 665  0.339 0.345  0.089 -0.008 0.324 0.664 0.512 0.055 0.094   NA    NA -0.280
#> 666  0.403 0.397  0.159  0.053 0.382 0.658 0.475 0.073 0.110   NA    NA -0.261
#> 667  0.461 0.458  0.208  0.086 0.446 0.716 0.500 0.094 0.122   NA    NA -0.051
#> 668  0.418 0.406  0.159  0.047 0.406 0.716 0.497 0.107 0.113   NA    NA -0.127
#> 669  0.453 0.452  0.208  0.111 0.450 0.679 0.487 0.095 0.097   NA    NA -0.066
#> 670  0.461 0.452  0.196  0.110 0.449 0.677 0.512 0.079 0.085   NA    NA -0.115
#> 671  0.370 0.368  0.157  0.011 0.348 0.675 0.421 0.108 0.146   NA    NA -0.088
#> 672  0.214 0.216 -0.017 -0.112 0.206 0.635 0.466 0.074 0.095   NA    NA -0.432
#> 673  0.327 0.332  0.102  0.026 0.324 0.597 0.459 0.062 0.076   NA    NA -0.405
#> 674  0.413 0.398  0.181  0.085 0.386 0.602 0.435 0.071 0.096   NA    NA -0.108
#> 675  0.458 0.458  0.253  0.099 0.435 0.672 0.410 0.108 0.154   NA    NA -0.086
#> 676  0.423 0.413  0.206  0.079 0.419 0.680 0.414 0.139 0.127   NA    NA -0.175
#> 677  0.453 0.448  0.234  0.124 0.445 0.642 0.429 0.103 0.110   NA    NA -0.028
#> 678  0.589 0.584  0.365  0.270 0.576 0.611 0.439 0.077 0.095   NA    NA  0.123
#> 679  0.271 0.266  0.039 -0.040 0.270 0.619 0.453 0.087 0.079   NA    NA -0.406
#> 680  0.331 0.332  0.116  0.005 0.313 0.616 0.431 0.074 0.111   NA    NA -0.205
#> 681  0.347 0.344  0.140  0.003 0.330 0.654 0.408 0.109 0.137   NA    NA -0.135
#> 682  0.350 0.348  0.139 -0.001 0.339 0.680 0.417 0.123 0.140   NA    NA -0.157
#> 683  0.402 0.397  0.190  0.067 0.398 0.663 0.414 0.126 0.123   NA    NA -0.167
#> 684  0.441 0.435  0.226  0.143 0.442 0.598 0.418 0.097 0.083   NA    NA -0.004
#> 685  0.377 0.361  0.131  0.019 0.366 0.694 0.460 0.122 0.112   NA    NA -0.256
#> 686  0.425 0.428  0.189  0.100 0.416 0.631 0.479 0.063 0.089   NA    NA -0.331
#> 687  0.405 0.395  0.170  0.091 0.389 0.596 0.450 0.067 0.079   NA    NA -0.147
#> 688  0.440 0.440  0.218  0.122 0.415 0.586 0.445 0.045 0.096   NA    NA -0.161
#> 689  0.467 0.455  0.236  0.118 0.446 0.656 0.438 0.100 0.118   NA    NA -0.068
#> 690  0.430 0.422  0.202  0.073 0.410 0.675 0.441 0.105 0.129   NA    NA -0.065
#> 691  0.471 0.468  0.257  0.121 0.454 0.667 0.421 0.110 0.136   NA    NA -0.010
#> 692  0.524 0.518  0.305  0.210 0.521 0.622 0.426 0.101 0.095   NA    NA  0.048
#> 693  0.613 0.604  0.387  0.301 0.600 0.598 0.435 0.077 0.086   NA    NA  0.161
#> 694  0.509 0.503  0.284  0.171 0.472 0.603 0.438 0.052 0.113   NA    NA -0.079
#> 695  0.436 0.428  0.215  0.081 0.394 0.626 0.427 0.065 0.134   NA    NA -0.074
#> 696  0.362 0.356  0.154  0.017 0.336 0.638 0.404 0.097 0.137   NA    NA -0.391
#> 697  0.314 0.301  0.073 -0.036 0.299 0.670 0.456 0.105 0.109   NA    NA -0.352
#> 698  0.303 0.286  0.056 -0.033 0.286 0.637 0.461 0.087 0.089   NA    NA -0.232
#> 699  0.404 0.394  0.165  0.085 0.390 0.611 0.458 0.073 0.080   NA    NA -0.148
#> 700  0.410 0.401  0.175  0.094 0.394 0.600 0.452 0.067 0.081   NA    NA     NA
#> 701  0.414 0.403  0.176  0.078 0.399 0.642 0.455 0.089 0.098   NA    NA     NA
#> 702  0.454 0.449  0.231  0.097 0.438 0.682 0.436 0.112 0.134   NA    NA -0.091
#> 703  0.471 0.465  0.242  0.100 0.452 0.704 0.447 0.115 0.142   NA    NA     NA
#> 704  0.494 0.488  0.264  0.167 0.492 0.649 0.447 0.105 0.097   NA    NA  0.062
#> 705  0.537 0.523  0.301  0.233 0.525 0.584 0.444 0.072 0.068   NA    NA  0.082
#> 706  0.486 0.475  0.270  0.162 0.452 0.579 0.410 0.061 0.108   NA    NA -0.082
#> 707  0.474 0.474  0.257  0.130 0.443 0.626 0.433 0.066 0.127   NA    NA -0.173
#> 708  0.322 0.315  0.078 -0.042 0.300 0.683 0.474 0.089 0.120   NA    NA -0.398
#> 709  0.221 0.218  0.007 -0.118 0.199 0.634 0.422 0.087 0.125   NA    NA -0.499
#> 710  0.235 0.235  0.002 -0.100 0.222 0.645 0.466 0.077 0.102   NA    NA -0.330
#> 711  0.344 0.345  0.111  0.023 0.339 0.632 0.468 0.076 0.088   NA    NA -0.268
#> 712  0.338 0.342  0.098 -0.016 0.310 0.653 0.487 0.052 0.114   NA    NA -0.341
#> 713  0.395 0.386  0.147  0.037 0.368 0.662 0.479 0.073 0.110   NA    NA -0.227
#> 714  0.363 0.356  0.143  0.010 0.345 0.670 0.427 0.110 0.133   NA    NA -0.190
#> 715  0.454 0.442  0.215  0.099 0.438 0.679 0.453 0.110 0.116   NA    NA -0.107
#> 716  0.474 0.468  0.247  0.134 0.459 0.650 0.441 0.096 0.113   NA    NA -0.037
#> 717  0.527 0.520  0.295  0.207 0.514 0.615 0.449 0.078 0.088   NA    NA  0.040
#> 718  0.521 0.516  0.297  0.189 0.487 0.596 0.439 0.049 0.108   NA    NA -0.048
#> 719  0.526 0.522  0.295  0.157 0.482 0.650 0.455 0.057 0.138   NA    NA -0.156
#> 720  0.477 0.468  0.234  0.088 0.441 0.706 0.469 0.091 0.146   NA    NA -0.141
#> 721  0.363 0.346  0.073 -0.021 0.336 0.714 0.546 0.074 0.094   NA    NA -0.213
#> 722  0.294 0.274  0.043 -0.050 0.276 0.652 0.461 0.098 0.093   NA    NA -0.255
#> 723  0.231 0.237  0.000 -0.098 0.214 0.623 0.474 0.051 0.098   NA    NA -0.469
#> 724  0.388 0.391  0.150  0.033 0.356 0.646 0.482 0.047 0.117   NA    NA -0.163
#> 725  0.420 0.406  0.158  0.043 0.398 0.711 0.495 0.101 0.115   NA    NA -0.220
#> 726  0.480 0.468  0.227  0.112 0.452 0.679 0.481 0.083 0.115   NA    NA -0.047
#> 727  0.455 0.444  0.206  0.102 0.434 0.665 0.476 0.085 0.104   NA    NA -0.051
#> 728  0.503 0.497  0.273  0.174 0.490 0.632 0.448 0.085 0.099   NA    NA -0.063
#> 729  0.599 0.594  0.368  0.266 0.572 0.612 0.452 0.058 0.102   NA    NA  0.123
#> 730  0.576 0.567  0.335  0.222 0.535 0.626 0.464 0.049 0.113   NA    NA  0.086
#> 731  0.419 0.408  0.166  0.048 0.378 0.660 0.484 0.058 0.118   NA    NA -0.249
#> 732  0.333 0.322  0.078 -0.042 0.306 0.697 0.488 0.089 0.120   NA    NA -0.306
#> 733  0.292 0.280  0.012 -0.102 0.269 0.742 0.535 0.093 0.114   NA    NA -0.340
#> 734  0.312 0.301  0.055 -0.042 0.287 0.658 0.492 0.069 0.097   NA    NA     NA
#> 735  0.422 0.412  0.157  0.056 0.395 0.678 0.510 0.067 0.101   NA    NA     NA
#> 736  0.444 0.422  0.154  0.080 0.421 0.682 0.536 0.072 0.074   NA    NA     NA
#> 737  0.457 0.444  0.180  0.067 0.422 0.709 0.528 0.068 0.113   NA    NA -0.130
#> 738  0.475 0.458  0.169  0.075 0.451 0.752 0.577 0.081 0.094   NA    NA -0.111
#> 739  0.512 0.502  0.252  0.116 0.488 0.744 0.501 0.107 0.136   NA    NA -0.046
#> 740  0.521 0.502  0.247  0.158 0.504 0.692 0.510 0.093 0.089   NA    NA  0.033
#> 741  0.583 0.569  0.316  0.225 0.562 0.675 0.506 0.078 0.091   NA    NA  0.102
#> 742  0.557 0.563  0.322  0.187 0.518 0.663 0.482 0.046 0.135   NA    NA -0.020
#> 743  0.501 0.499  0.263  0.121 0.462 0.682 0.472 0.068 0.142   NA    NA -0.285
#> 744  0.386 0.380  0.151  0.027 0.360 0.667 0.458 0.085 0.124   NA    NA -0.269
#> 745  0.373 0.350  0.090 -0.001 0.343 0.688 0.520 0.077 0.091   NA    NA -0.321
#> 746  0.336 0.338  0.083 -0.030 0.322 0.704 0.510 0.081 0.113   NA    NA -0.368
#> 747  0.371 0.354  0.094  0.006 0.350 0.687 0.521 0.078 0.088   NA    NA -0.130
#> 748  0.393 0.381  0.126  0.025 0.368 0.685 0.510 0.074 0.101   NA    NA -0.181
#> 749  0.439 0.430  0.176  0.071 0.418 0.693 0.507 0.081 0.105   NA    NA -0.146
#> 750  0.489 0.479  0.216  0.097 0.466 0.739 0.526 0.094 0.119   NA    NA -0.096
#> 751  0.472 0.458  0.193  0.079 0.452 0.746 0.530 0.102 0.114   NA    NA -0.107
#> 752  0.487 0.476  0.220  0.114 0.473 0.718 0.511 0.101 0.106   NA    NA -0.041
#> 753  0.551 0.541  0.302  0.182 0.526 0.687 0.478 0.089 0.120   NA    NA -0.169
#> 754  0.538 0.538  0.305  0.172 0.502 0.661 0.467 0.061 0.133   NA    NA  0.021
#> 755  0.512 0.506  0.241  0.123 0.472 0.698 0.529 0.051 0.118   NA    NA -0.192
#> 756  0.320 0.332  0.081 -0.057 0.294 0.702 0.503 0.061 0.138   NA    NA -0.547
#> 757  0.373 0.362  0.106  0.013 0.354 0.682 0.512 0.077 0.093   NA    NA -0.263
#> 758  0.443 0.442  0.179  0.070 0.424 0.708 0.526 0.073 0.109   NA    NA -0.154
#> 759  0.370 0.372  0.121  0.028 0.354 0.653 0.503 0.057 0.093   NA    NA -0.184
#> 760  0.433 0.438  0.174  0.048 0.406 0.715 0.527 0.062 0.126   NA    NA -0.226
#> 761  0.474 0.464  0.206  0.084 0.445 0.722 0.516 0.084 0.122   NA    NA -0.046
#> 762  0.509 0.505  0.258  0.120 0.476 0.711 0.494 0.079 0.138   NA    NA -0.103
#> 763  0.520 0.504  0.230  0.131 0.499 0.736 0.547 0.090 0.099   NA    NA -0.008
#> 764  0.520 0.509  0.259  0.155 0.506 0.702 0.500 0.098 0.104   NA    NA -0.129
#> 765  0.570 0.548  0.308  0.224 0.548 0.649 0.480 0.085 0.084   NA    NA  0.030
#> 766  0.511 0.496  0.266  0.175 0.484 0.617 0.460 0.066 0.091   NA    NA -0.087
#> 767  0.444 0.450  0.207  0.066 0.408 0.685 0.486 0.058 0.141   NA    NA -0.226
#> 768  0.353 0.339  0.078 -0.035 0.328 0.726 0.522 0.091 0.113   NA    NA -0.175
#> 769  0.329 0.322  0.058 -0.053 0.317 0.740 0.529 0.100 0.111   NA    NA -0.462
#> 770  0.329 0.315  0.065 -0.006 0.318 0.647 0.500 0.076 0.071   NA    NA -0.339
#> 771  0.385 0.382  0.122  0.044 0.372 0.657 0.519 0.060 0.078   NA    NA -0.256
#> 772  0.407 0.395  0.151  0.058 0.385 0.654 0.488 0.073 0.093   NA    NA -0.192
#> 773  0.476 0.476  0.225  0.108 0.450 0.684 0.503 0.064 0.117   NA    NA -0.066
#> 774  0.461 0.452  0.214  0.099 0.444 0.691 0.477 0.099 0.115   NA    NA -0.074
#> 775  0.433 0.420  0.176  0.087 0.426 0.678 0.489 0.100 0.089   NA    NA -0.092
#> 776  0.498 0.494  0.245  0.163 0.496 0.665 0.498 0.085 0.082   NA    NA -0.048
#> 777  0.576 0.566  0.310  0.224 0.559 0.670 0.513 0.071 0.086   NA    NA  0.078
#> 778  0.534 0.532  0.276  0.168 0.507 0.678 0.513 0.057 0.108   NA    NA -0.271
#> 779  0.438 0.436  0.210  0.079 0.399 0.640 0.453 0.056 0.131   NA    NA -0.236
#> 780  0.366 0.356  0.097 -0.019 0.338 0.714 0.519 0.079 0.116   NA    NA -0.363
#> 781  0.349 0.346  0.064 -0.027 0.334 0.722 0.563 0.068 0.091   NA    NA -0.228
#> 782  0.321 0.287  0.041 -0.016 0.310 0.653 0.492 0.104 0.057   NA    NA -0.237
#> 783  0.339 0.320  0.072 -0.006 0.322 0.655 0.495 0.082 0.078   NA    NA -0.198
#> 784  0.380 0.373  0.141  0.026 0.348 0.645 0.464 0.066 0.115   NA    NA -0.189
#> 785  0.500 0.496  0.238  0.126 0.484 0.715 0.517 0.086 0.112   NA    NA -0.112
#> 786  0.513 0.504  0.224  0.131 0.499 0.736 0.561 0.082 0.093   NA    NA -0.041
#> 787  0.505 0.493  0.231  0.140 0.494 0.709 0.524 0.094 0.091   NA    NA -0.035
#> 788  0.539 0.531  0.283  0.207 0.533 0.652 0.496 0.080 0.076   NA    NA  0.070
#> 789  0.539 0.536  0.306  0.216 0.532 0.633 0.459 0.084 0.090   NA    NA -0.091
#> 790  0.561 0.557  0.316  0.206 0.534 0.656 0.482 0.064 0.110   NA    NA -0.122
#> 791  0.457 0.455  0.215  0.091 0.423 0.664 0.480 0.060 0.124   NA    NA -0.181
#> 792  0.404 0.385  0.137  0.039 0.380 0.683 0.496 0.089 0.098   NA    NA -0.174
#> 793  0.323 0.331  0.066 -0.031 0.319 0.700 0.530 0.073 0.097   NA    NA -0.554
#> 794  0.331 0.332  0.076 -0.023 0.316 0.677 0.511 0.067 0.099   NA    NA -0.262
#> 795  0.323 0.318  0.062 -0.030 0.307 0.674 0.512 0.070 0.092   NA    NA -0.224
#> 796  0.422 0.409  0.159  0.061 0.396 0.669 0.500 0.071 0.098   NA    NA -0.114
#> 797  0.479 0.466  0.210  0.114 0.456 0.684 0.512 0.076 0.096   NA    NA -0.111
#> 798  0.459 0.450  0.187  0.073 0.438 0.731 0.525 0.092 0.114   NA    NA -0.101
#> 799  0.532 0.518  0.251  0.158 0.516 0.716 0.533 0.090 0.093   NA    NA -0.136
#> 800  0.555 0.540  0.294  0.207 0.546 0.679 0.493 0.099 0.087   NA    NA  0.045
#> 801  0.652 0.639  0.420  0.349 0.644 0.589 0.438 0.080 0.071   NA    NA  0.109
#> 802  0.540 0.546  0.314  0.200 0.519 0.638 0.465 0.059 0.114   NA    NA -0.094
#> 803  0.465 0.458  0.208  0.108 0.434 0.653 0.500 0.053 0.100   NA    NA -0.245
#> 804  0.280 0.280  0.038 -0.058 0.272 0.661 0.483 0.082 0.096   NA    NA -0.437
#> 805  0.408 0.420  0.160  0.058 0.396 0.675 0.519 0.054 0.102   NA    NA -0.261
#> 806  0.418 0.416  0.165  0.063 0.400 0.673 0.501 0.070 0.102   NA    NA -0.152
#> 807  0.458 0.446  0.193  0.085 0.430 0.690 0.506 0.076 0.108   NA    NA -0.088
#> 808  0.542 0.530  0.269  0.189 0.527 0.676 0.522 0.074 0.080   NA    NA  0.024
#> 809  0.552 0.532  0.268  0.194 0.542 0.696 0.529 0.093 0.074   NA    NA -0.037
#> 810  0.553 0.544  0.296  0.212 0.547 0.670 0.495 0.091 0.084   NA    NA  0.080
#> 811  0.663 0.649  0.408  0.322 0.638 0.633 0.482 0.065 0.086   NA    NA  0.181
#> 812  0.595 0.588  0.357  0.259 0.561 0.604 0.461 0.045 0.098   NA    NA -0.036
#> 813  0.549 0.550  0.319  0.180 0.504 0.649 0.461 0.049 0.139   NA    NA -0.162
#> 814  0.397 0.386  0.136  0.031 0.369 0.676 0.501 0.070 0.105   NA    NA -0.126
#> 815  0.463 0.448  0.209  0.100 0.445 0.690 0.478 0.103 0.109   NA    NA -0.039
#> 816  0.514 0.514  0.273  0.143 0.498 0.709 0.481 0.098 0.130   NA    NA -0.021
#> 817  0.525 0.518  0.282  0.190 0.518 0.657 0.473 0.092 0.092   NA    NA -0.121
#> 818  0.573 0.564  0.337  0.241 0.556 0.631 0.454 0.081 0.096   NA    NA  0.087
#> 819  0.622 0.622  0.396  0.282 0.602 0.640 0.452 0.074 0.114   NA    NA  0.162
#> 820  0.523 0.514  0.285  0.162 0.484 0.645 0.457 0.065 0.123   NA    NA -0.011
#> 821  0.477 0.481  0.266  0.120 0.440 0.640 0.430 0.064 0.146   NA    NA -0.292
#> 822  0.333 0.317  0.068 -0.030 0.312 0.685 0.498 0.089 0.098   NA    NA -0.248
#> 823  0.310 0.321  0.066 -0.050 0.304 0.707 0.510 0.081 0.116   NA    NA -0.248
#> 824  0.430 0.424  0.197  0.092 0.410 0.635 0.453 0.077 0.105   NA    NA -0.119
#> 825  0.465 0.462  0.236  0.107 0.447 0.680 0.453 0.098 0.129   NA    NA -0.119
#> 826  0.502 0.494  0.233  0.124 0.486 0.725 0.521 0.095 0.109   NA    NA -0.100
#> 827  0.558 0.552  0.318  0.200 0.549 0.698 0.469 0.111 0.118   NA    NA  0.040
#> 828  0.574 0.566  0.323  0.245 0.570 0.650 0.485 0.087 0.078   NA    NA  0.114
#> 829  0.565 0.545  0.312  0.236 0.548 0.623 0.466 0.081 0.076   NA    NA  0.102
#> 830  0.487 0.479  0.248  0.139 0.464 0.650 0.462 0.079 0.109   NA    NA -0.195
#> 831  0.480 0.476  0.269  0.122 0.450 0.656 0.413 0.096 0.147   NA    NA -0.192
#> 832  0.412 0.403  0.179  0.055 0.385 0.660 0.448 0.088 0.124   NA    NA -0.216
#> 833  0.344 0.346  0.114  0.015 0.336 0.642 0.463 0.080 0.099   NA    NA -0.162
#> 834  0.388 0.372  0.135  0.051 0.376 0.649 0.475 0.090 0.084   NA    NA -0.174
#> 835  0.430 0.419  0.178  0.099 0.419 0.640 0.482 0.079 0.079   NA    NA -0.227
#> 836  0.486 0.488  0.261  0.150 0.473 0.646 0.455 0.080 0.111   NA    NA -0.060
#> 837  0.526 0.522  0.310  0.172 0.503 0.662 0.423 0.101 0.138   NA    NA  0.046
#> 838  0.638 0.628  0.409  0.279 0.616 0.675 0.439 0.106 0.130   NA    NA -0.043
#> 839  0.567 0.564  0.329  0.215 0.561 0.692 0.470 0.108 0.114   NA    NA  0.053
#> 840  0.606 0.602  0.389  0.294 0.607 0.626 0.425 0.106 0.095   NA    NA -0.142
#> 841  0.562 0.554  0.327  0.246 0.548 0.605 0.455 0.069 0.081   NA    NA  0.078
#> 842  0.551 0.548  0.340  0.218 0.523 0.610 0.416 0.072 0.122   NA    NA  0.113
#> 843  0.549 0.550  0.350  0.192 0.518 0.652 0.400 0.094 0.158   NA    NA -0.013
#> 844  0.473 0.469  0.245  0.102 0.442 0.679 0.448 0.088 0.143   NA    NA -0.308
#> 845  0.405 0.415  0.175  0.063 0.398 0.670 0.480 0.078 0.112   NA    NA -0.091
#> 846  0.406 0.404  0.167  0.100 0.408 0.616 0.473 0.076 0.067   NA    NA -0.139
#> 847  0.418 0.414  0.184  0.111 0.416 0.609 0.459 0.077 0.073   NA    NA -0.098
#> 848  0.444 0.431  0.204  0.112 0.428 0.633 0.454 0.087 0.092   NA    NA -0.087
#> 849  0.467 0.466  0.256  0.112 0.440 0.656 0.420 0.092 0.144   NA    NA -0.106
#> 850  0.517 0.514  0.311  0.171 0.504 0.667 0.406 0.121 0.140   NA    NA -0.013
#> 851  0.580 0.576  0.367  0.255 0.573 0.636 0.419 0.105 0.112   NA    NA  0.106
#> 852  0.577 0.570  0.344  0.248 0.563 0.630 0.451 0.083 0.096   NA    NA  0.131
#> 853  0.617 0.615  0.395  0.291 0.594 0.606 0.440 0.062 0.104   NA    NA  0.090
#> 854  0.615 0.616  0.410  0.294 0.582 0.575 0.413 0.046 0.116   NA    NA  0.048
#> 855  0.529 0.530  0.340  0.177 0.486 0.617 0.379 0.075 0.163   NA    NA -0.106
#> 856  0.478 0.476  0.255  0.100 0.444 0.689 0.441 0.093 0.155   NA    NA -0.160
#> 857  0.392 0.374  0.149  0.032 0.380 0.697 0.450 0.130 0.117   NA    NA -0.273
#> 858  0.438 0.436  0.216  0.114 0.424 0.621 0.439 0.080 0.102   NA    NA -0.037
#> 859  0.430 0.431  0.198  0.109 0.414 0.611 0.466 0.056 0.089   NA    NA -0.131
#> 860  0.482 0.478  0.259  0.141 0.460 0.638 0.439 0.081 0.118   NA    NA -0.064
#> 861  0.506 0.504  0.297  0.140 0.478 0.676 0.415 0.104 0.157   NA    NA -0.233
#> 862  0.521 0.521  0.325  0.166 0.500 0.668 0.392 0.117 0.159 6.19 12.16  0.033
#> 863  0.516 0.515  0.305  0.170 0.500 0.660 0.420 0.105 0.135   NA    NA  0.000
#> 864  0.564 0.560  0.337  0.252 0.562 0.620 0.447 0.088 0.085   NA    NA  0.117
#> 865  0.603 0.598  0.380  0.281 0.585 0.608 0.436 0.073 0.099   NA    NA  0.167
#> 866  0.591 0.587  0.376  0.250 0.553 0.606 0.422 0.058 0.126   NA    NA  0.079
#> 867  0.511 0.506  0.313  0.167 0.478 0.623 0.385 0.092 0.146   NA    NA -0.103
#> 868  0.541 0.540  0.344  0.180 0.512 0.665 0.393 0.108 0.164 6.22 12.13  0.012
#> 869  0.420 0.425  0.189  0.057 0.402 0.690 0.472 0.086 0.132   NA    NA -0.381
#> 870  0.420 0.416  0.192  0.094 0.412 0.635 0.449 0.088 0.098   NA    NA -0.163
#> 871  0.400 0.392  0.165  0.074 0.380 0.612 0.455 0.066 0.091   NA    NA -0.108
#> 872  0.483 0.476  0.248  0.148 0.458 0.620 0.456 0.064 0.100   NA    NA  0.043
#> 873  0.490 0.488  0.272  0.143 0.474 0.662 0.431 0.102 0.129   NA    NA -0.010
#> 874  0.502 0.504  0.300  0.150 0.487 0.674 0.407 0.117 0.150   NA    NA  0.038
#> 875  0.556 0.549  0.333  0.197 0.541 0.688 0.432 0.120 0.136   NA    NA  0.007
#> 876  0.611 0.606  0.384  0.279 0.605 0.652 0.444 0.103 0.105   NA    NA  0.132
#> 877  0.620 0.617  0.395  0.301 0.604 0.607 0.444 0.069 0.094   NA    NA  0.181
#> 878  0.706 0.706  0.498  0.370 0.669 0.598 0.416 0.054 0.128   NA    NA  0.097
#> 879  0.589 0.582  0.376  0.232 0.548 0.632 0.412 0.076 0.144   NA    NA -0.104
#> 880  0.562 0.565  0.375  0.208 0.531 0.646 0.380 0.099 0.167   NA    NA -0.008
#> 881  0.523 0.530  0.303  0.185 0.514 0.658 0.454 0.086 0.118   NA    NA -0.150
#> 882  0.455 0.442  0.219  0.122 0.440 0.637 0.447 0.093 0.097   NA    NA -0.170
#> 883  0.452 0.448  0.218  0.123 0.436 0.626 0.461 0.070 0.095   NA    NA -0.110
#> 884  0.526 0.529  0.306  0.187 0.500 0.627 0.446 0.062 0.119   NA    NA -0.058
#> 885  0.567 0.564  0.349  0.236 0.546 0.620 0.430 0.077 0.113   NA    NA  0.028
#> 886  0.566 0.567  0.365  0.222 0.545 0.646 0.404 0.099 0.143   NA    NA -0.035
#> 887  0.548 0.546  0.341  0.201 0.533 0.664 0.409 0.115 0.140   NA    NA  0.017
#> 888  0.602 0.601  0.396  0.284 0.596 0.625 0.410 0.103 0.112 6.29 12.21  0.111
#> 889  0.655 0.654  0.441  0.334 0.632 0.595 0.425 0.063 0.107   NA    NA  0.190
#> 890  0.589 0.584  0.375  0.266 0.551 0.570 0.419 0.042 0.109   NA    NA  0.150
#> 891  0.593 0.598  0.398  0.244 0.556 0.623 0.400 0.069 0.154   NA    NA  0.021
#> 892  0.464 0.458  0.242  0.107 0.434 0.653 0.432 0.086 0.135   NA    NA -0.215
#> 893  0.470 0.473  0.252  0.119 0.452 0.665 0.442 0.090 0.133   NA    NA -0.373
#> 894  0.388 0.376  0.151  0.065 0.372 0.615 0.449 0.080 0.086   NA    NA -0.314
#> 895  0.378 0.373  0.153  0.067 0.362 0.590 0.440 0.064 0.086   NA    NA -0.124
#> 896  0.509 0.501  0.272  0.182 0.487 0.610 0.458 0.062 0.090   NA    NA  0.030
#> 897  0.509 0.504  0.289  0.164 0.478 0.627 0.429 0.073 0.125   NA    NA -0.078
#> 898  0.552 0.546  0.343  0.214 0.536 0.643 0.407 0.107 0.129   NA    NA  0.081
#> 899  0.554 0.550  0.354  0.233 0.551 0.636 0.391 0.124 0.121   NA    NA  0.086
#> 900  0.607 0.602  0.391  0.298 0.602 0.609 0.423 0.093 0.093   NA    NA  0.099
#> 901  0.619 0.596  0.368  0.297 0.606 0.617 0.457 0.089 0.071   NA    NA -0.519
#> 902  0.643 0.646  0.440  0.319 0.614 0.589 0.411 0.057 0.121   NA    NA  0.112
#> 903  0.535 0.532  0.325  0.183 0.492 0.619 0.413 0.064 0.142   NA    NA -0.004
#> 904  0.469 0.468  0.262  0.095 0.440 0.691 0.411 0.113 0.167   NA    NA -0.078
#> 905  0.313 0.326  0.100 -0.043 0.292 0.671 0.451 0.077 0.143   NA    NA -0.462
#> 906  0.403 0.385  0.150  0.063 0.384 0.641 0.470 0.084 0.087   NA    NA -0.134
#> 907  0.508 0.502  0.265  0.192 0.494 0.605 0.473 0.059 0.073   NA    NA -0.022
#> 908  0.472 0.460  0.233  0.148 0.448 0.600 0.455 0.060 0.085   NA    NA -0.038
#> 909  0.510 0.513  0.281  0.150 0.488 0.676 0.464 0.081 0.131   NA    NA -0.073
#> 910  0.488 0.486  0.279  0.125 0.465 0.680 0.413 0.113 0.154   NA    NA -0.014
#> 911  0.566 0.561  0.350  0.217 0.552 0.671 0.422 0.116 0.133   NA    NA  0.004
#> 912  0.594 0.590  0.374  0.260 0.578 0.636 0.432 0.090 0.114   NA    NA  0.104
#> 913  0.628 0.620  0.394  0.287 0.601 0.628 0.452 0.069 0.107   NA    NA  0.100
#> 914  0.622 0.630  0.412  0.288 0.588 0.601 0.435 0.042 0.124   NA    NA -0.101
#> 915  0.524 0.518  0.289  0.166 0.494 0.655 0.459 0.073 0.123   NA    NA -0.055
#> 916  0.517 0.524  0.302  0.178 0.491 0.626 0.443 0.059 0.124   NA    NA -0.173
#> 917  0.411 0.404  0.171  0.044 0.380 0.672 0.465 0.080 0.127   NA    NA -0.233
#> 918  0.456 0.442  0.197  0.092 0.433 0.682 0.491 0.086 0.105   NA    NA -0.098
#> 919  0.493 0.483  0.250  0.140 0.457 0.634 0.466 0.058 0.110   NA    NA -0.164
#> 920  0.536 0.528  0.296  0.198 0.511 0.626 0.464 0.064 0.098   NA    NA -0.034
#> 921  0.570 0.566  0.328  0.212 0.544 0.664 0.476 0.072 0.116   NA    NA  0.023
#> 922  0.605 0.598  0.380  0.230 0.575 0.690 0.435 0.105 0.150   NA    NA  0.091
#> 923  0.614 0.615  0.399  0.244 0.594 0.701 0.432 0.114 0.155   NA    NA  0.097
#> 924  0.621 0.619  0.389  0.261 0.606 0.689 0.460 0.101 0.128   NA    NA  0.109
#> 925  0.619 0.609  0.387  0.279 0.592 0.625 0.444 0.073 0.108   NA    NA  0.145
#> 926  0.771 0.768  0.558  0.428 0.735 0.614 0.421 0.063 0.130   NA    NA  0.161
#> 927  0.651 0.644  0.418  0.282 0.616 0.667 0.451 0.080 0.136   NA    NA -0.036
#> 928  0.519 0.503  0.275  0.146 0.491 0.690 0.456 0.105 0.129   NA    NA -0.139
#> 929  0.470 0.479  0.244  0.102 0.446 0.689 0.470 0.077 0.142   NA    NA -0.288
#> 930  0.415 0.401  0.165  0.072 0.400 0.656 0.472 0.091 0.093   NA    NA -0.309
#> 931  0.422 0.412  0.172  0.069 0.396 0.655 0.480 0.072 0.103   NA    NA -0.351
#> 932  0.534 0.524  0.284  0.177 0.504 0.653 0.480 0.066 0.107   NA    NA -0.066
#> 933  0.478 0.474  0.235  0.095 0.440 0.691 0.477 0.074 0.140   NA    NA -0.116
#> 934  0.560 0.552  0.322  0.194 0.542 0.696 0.461 0.107 0.128   NA    NA  0.060
#> 935  0.544 0.534  0.295  0.174 0.522 0.696 0.477 0.098 0.121   NA    NA  0.007
#> 936  0.611 0.607  0.363  0.265 0.599 0.668 0.488 0.082 0.098   NA    NA  0.055
#> 937  0.696 0.682  0.459  0.377 0.678 0.602 0.447 0.073 0.082   NA    NA  0.171
#> 938  0.721 0.694  0.472  0.386 0.680 0.588 0.445 0.057 0.086   NA    NA  0.146
#> 939  0.608 0.607  0.351  0.212 0.561 0.698 0.512 0.047 0.139   NA    NA -0.148
#> 940  0.466 0.456  0.172  0.078 0.440 0.723 0.568 0.061 0.094   NA    NA -0.189
#> 941  0.446 0.427  0.182  0.067 0.422 0.710 0.490 0.105 0.115   NA    NA -0.199
#> 942  0.483 0.483  0.248  0.129 0.465 0.672 0.470 0.083 0.119   NA    NA -0.206
#> 943  0.491 0.505  0.256  0.142 0.467 0.650 0.498 0.038 0.114   NA    NA -0.338
#> 944  0.542 0.548  0.294  0.165 0.512 0.695 0.508 0.058 0.129   NA    NA -0.243
#> 945  0.505 0.490  0.227  0.126 0.474 0.697 0.525 0.071 0.101   NA    NA -0.090
#> 946  0.571 0.566  0.297  0.213 0.556 0.686 0.537 0.065 0.084   NA    NA  0.030
#> 947  0.648 0.626  0.374  0.293 0.632 0.679 0.505 0.093 0.081   NA    NA  0.163
#> 948  0.648 0.638  0.399  0.291 0.619 0.656 0.477 0.071 0.108   NA    NA  0.140
#> 949  0.707 0.692  0.456  0.353 0.672 0.638 0.472 0.063 0.103   NA    NA  0.223
#> 950  0.611 0.605  0.369  0.239 0.566 0.654 0.472 0.052 0.130   NA    NA  0.034
#> 951  0.557 0.536  0.271  0.162 0.519 0.714 0.531 0.074 0.109   NA    NA -0.035
#> 952  0.525 0.520  0.248  0.147 0.503 0.712 0.543 0.068 0.101   NA    NA -0.140
#> 953  0.481 0.490  0.236  0.119 0.466 0.695 0.509 0.069 0.117   NA    NA -0.201
#> 954  0.495 0.490  0.229  0.142 0.480 0.677 0.523 0.067 0.087   NA    NA -0.442
#> 955  0.532 0.530  0.287  0.170 0.505 0.670 0.487 0.066 0.117   NA    NA -0.100
#> 956  0.617 0.613  0.370  0.240 0.586 0.691 0.486 0.075 0.130   NA    NA  0.095
#> 957  0.609 0.594  0.329  0.238 0.594 0.712 0.529 0.092 0.091   NA    NA  0.025
#> 958  0.602 0.594  0.346  0.238 0.588 0.700 0.495 0.097 0.108   NA    NA  0.050
#> 959  0.657 0.649  0.400  0.324 0.644 0.641 0.498 0.067 0.076   NA    NA  0.140
#> 960  0.660 0.672  0.435  0.317 0.650 0.667 0.475 0.074 0.118   NA    NA -0.620
#> 961  0.668 0.652  0.389  0.289 0.630 0.681 0.527 0.054 0.100   NA    NA  0.146
#> 962  0.646 0.620  0.370  0.273 0.610 0.674 0.500 0.077 0.097   NA    NA  0.030
#> 963  0.587 0.582  0.340  0.207 0.552 0.691 0.485 0.073 0.133   NA    NA -0.202
#> 964  0.498 0.478  0.216  0.118 0.472 0.708 0.525 0.085 0.098   NA    NA -0.097
#> 965  0.457 0.452  0.192  0.079 0.424 0.691 0.521 0.057 0.113   NA    NA -0.249
#> 966  0.576 0.570  0.319  0.218 0.553 0.670 0.502 0.067 0.101   NA    NA -0.023
#> 967  0.586 0.571  0.321  0.220 0.556 0.671 0.500 0.070 0.101   NA    NA -0.067
#> 968  0.584 0.574  0.319  0.211 0.558 0.693 0.510 0.075 0.108   NA    NA  0.029
#> 969  0.665 0.650  0.392  0.278 0.646 0.735 0.517 0.104 0.114   NA    NA  0.080
#> 970  0.582 0.570  0.295  0.197 0.561 0.728 0.550 0.080 0.098   NA    NA  0.068
#> 971  0.647 0.625  0.368  0.269 0.627 0.716 0.514 0.103 0.099   NA    NA  0.047
#> 972  0.642 0.632  0.400  0.307 0.626 0.639 0.464 0.082 0.093   NA    NA  0.209
#> 973  0.692 0.694  0.475  0.348 0.662 0.627 0.437 0.063 0.127   NA    NA  0.055
#> 974  0.634 0.632  0.389  0.268 0.599 0.662 0.487 0.054 0.121   NA    NA -0.094
#> 975  0.551 0.522  0.247  0.174 0.532 0.715 0.550 0.092 0.073   NA    NA -0.161
#> 976  0.459 0.465  0.226  0.096 0.442 0.692 0.478 0.084 0.130   NA    NA -0.302
#> 977  0.483 0.483  0.221  0.125 0.473 0.696 0.524 0.076 0.096   NA    NA -0.136
#> 978  0.501 0.498  0.247  0.141 0.488 0.694 0.502 0.086 0.106   NA    NA -0.127
#> 979  0.535 0.520  0.255  0.179 0.522 0.687 0.529 0.082 0.076   NA    NA -0.027
#> 980  0.604 0.592  0.340  0.232 0.581 0.698 0.505 0.085 0.108   NA    NA  0.101
#> 981  0.617 0.609  0.351  0.256 0.602 0.693 0.516 0.082 0.095   NA    NA  0.134
#> 982  0.602 0.588  0.330  0.232 0.588 0.712 0.516 0.098 0.098   NA    NA  0.088
#> 983  0.645 0.648  0.381  0.256 0.614 0.716 0.533 0.058 0.125   NA    NA  0.088
#> 984  0.793 0.773  0.509  0.390 0.764 0.747 0.528 0.100 0.119   NA    NA  0.249
#> 985  0.665 0.658  0.407  0.273 0.617 0.688 0.502 0.052 0.134   NA    NA -0.051
#> 986  0.660 0.639  0.379  0.256 0.611 0.710 0.520 0.067 0.123   NA    NA -0.113
#> 987  0.455 0.430  0.122  0.038 0.416 0.757 0.615 0.058 0.084   NA    NA -0.387
#> 988  0.356 0.348  0.077 -0.048 0.335 0.766 0.543 0.098 0.125   NA    NA -0.231
#> 989  0.409 0.415  0.158  0.041 0.394 0.705 0.514 0.074 0.117   NA    NA -0.180
#> 990  0.489 0.484  0.234  0.130 0.464 0.669 0.500 0.065 0.104   NA    NA -0.147
#> 991  0.502 0.490  0.223  0.125 0.480 0.710 0.533 0.079 0.098   NA    NA -0.072
#> 992  0.572 0.566  0.298  0.177 0.544 0.734 0.536 0.077 0.121   NA    NA  0.036
#> 993  0.604 0.596  0.337  0.217 0.582 0.729 0.519 0.090 0.120   NA    NA  0.002
#> 994  0.614 0.608  0.370  0.268 0.600 0.663 0.475 0.086 0.102   NA    NA  0.049
#> 995  0.667 0.672  0.415  0.322 0.664 0.683 0.514 0.076 0.093   NA    NA  0.145
#> 996  0.652 0.651  0.404  0.302 0.634 0.665 0.494 0.069 0.102   NA    NA  0.183
#> 997  0.677 0.671  0.433  0.319 0.639 0.640 0.476 0.050 0.114   NA    NA  0.089
#> 998  0.530 0.516  0.270  0.151 0.496 0.691 0.492 0.080 0.119   NA    NA -0.246
#> 999  1.231 1.237  1.036  0.856 1.210 0.707 0.405 0.122 0.180 7.78  0.68  0.335
#> 1000 1.161 1.167  0.954  0.799 1.158 0.716 0.427 0.134 0.155 7.32  0.65  0.488
#> 1001 1.183 1.195  0.978  0.805 1.161 0.713 0.433 0.107 0.174 7.42  0.85  0.518
#> 1002 1.207 1.216  0.994  0.808 1.177 0.735 0.445 0.104 0.186 7.59  0.64  0.610
#> 1003 1.311 1.317  1.085  0.899 1.274 0.747 0.460 0.101 0.186 7.37  0.69  0.701
#> 1004 1.366 1.372  1.155  0.942 1.335 0.783 0.433 0.137 0.213 7.53  0.56  0.792
#> 1005 1.305 1.311  1.103  0.896 1.274 0.759 0.418 0.134 0.207 7.77  0.52  0.732
#> 1006 1.347 1.350  1.125  0.978 1.335 0.716 0.451 0.119 0.146 7.38  0.63  0.823
#> 1007 1.286 1.289  1.085  0.957 1.277 0.640 0.408 0.104 0.128   NA    NA     NA
#> 1008 1.433 1.442  1.234  1.085 1.408 0.643 0.415 0.079 0.149   NA    NA     NA
#> 1009 1.426 1.433  1.222  1.045 1.393 0.695 0.421 0.098 0.177   NA    NA     NA
#> 1010 1.356 1.359  1.146  0.951 1.329 0.759 0.427 0.137 0.195   NA    NA     NA
#> 1011 1.219 1.225  1.015  0.841 1.204 0.725 0.424 0.128 0.174 7.46  0.56  0.457
#> 1012 1.247 1.250  1.036  0.856 1.225 0.738 0.427 0.131 0.180 7.62  0.55  0.732
#> 1013 1.405 1.420  1.207  1.024 1.384 0.716 0.427 0.107 0.183 7.48  0.66  0.792
#> 1014 1.344 1.347  1.140  0.972 1.323 0.704 0.418 0.119 0.168 7.08  0.25  0.671
#> 1015 1.378 1.384  1.192  1.015 1.347 0.664 0.387 0.101 0.177 7.72  0.74  0.853
#> 1016 1.390 1.393  1.201  1.030 1.372 0.686 0.384 0.131 0.171 7.59  0.36  0.853
#> 1017 1.393 1.396  1.192  1.015 1.372 0.710 0.405 0.128 0.177 7.47  0.53  0.823
#> 1018 1.384 1.390  1.183  1.012 1.362 0.701 0.418 0.113 0.171 7.71  0.61  0.823
#> 1019 1.402 1.405  1.195  1.042 1.384 0.683 0.421 0.110 0.152 7.68  0.70  0.732
#> 1020 1.405 1.417  1.207  1.058 1.372 0.631 0.421 0.061 0.149 7.27  0.76  0.792
#> 1021 1.369 1.378  1.177  1.003 1.341 0.674 0.399 0.101 0.174 7.47  0.47  0.671
#> 1022 1.262 1.262  1.061  0.869 1.241 0.744 0.402 0.149 0.192 7.46  0.06  0.579
#> 1023 1.216 1.222  1.024  0.847 1.207 0.719 0.396 0.146 0.177 7.59  0.44  0.610
#> 1024 1.222 1.225  1.030  0.881 1.213 0.664 0.393 0.122 0.149 7.39  0.41  0.457
#> 1025 1.228 1.231  1.027  0.896 1.222 0.652 0.405 0.116 0.131 7.43  0.55  0.701
#> 1026 1.268 1.271  1.070  0.908 1.256 0.692 0.402 0.128 0.162 7.28  0.55  0.671
#> 1027 1.286 1.292  1.091  0.890 1.256 0.735 0.405 0.128 0.201 7.67  0.64  0.732
#> 1028 1.369 1.369  1.167  0.969 1.341 0.741 0.402 0.140 0.198 7.54  0.24  0.732
#> 1029 1.369 1.366  1.173  1.024 1.359 0.668 0.387 0.131 0.149 7.56  0.41  0.792
#> 1030 1.399 1.396  1.198  1.052 1.402 0.698 0.393 0.158 0.146 7.29  0.24  0.762
#> 1031 1.430 1.436  1.213  1.055 1.408 0.704 0.445 0.101 0.158 7.41  0.56  0.945
#> 1032 1.460 1.469  1.253  1.082 1.417 0.671 0.430 0.070 0.171 7.34  0.59  0.975
#> 1033 1.292 1.298  1.097  0.917 1.262 0.692 0.402 0.110 0.180 7.54  0.67  0.488
#> 1034 1.198 1.204  1.006  0.808 1.170 0.728 0.396 0.134 0.198 7.61  0.06  0.549
#> 1035 1.286 1.295  1.088  0.899 1.271 0.744 0.415 0.140 0.189 7.60  0.36  0.640
#> 1036 1.228 1.237  1.033  0.869 1.219 0.698 0.405 0.128 0.165 7.38  0.48  0.518
#> 1037 1.207 1.210  1.009  0.860 1.201 0.680 0.402 0.128 0.149 7.36  0.53  0.457
#> 1038 1.253 1.262  1.052  0.896 1.234 0.677 0.421 0.101 0.155 7.40  0.64  0.427
#> 1039 1.298 1.305  1.091  0.896 1.271 0.750 0.427 0.128 0.195 7.49  0.44  0.792
#> 1040 1.286 1.292  1.082  0.884 1.268 0.765 0.421 0.146 0.198 7.41  0.53  0.732
#> 1041 1.332 1.329  1.128  0.963 1.326 0.725 0.399 0.162 0.165 7.35  0.21  0.762
#> 1042 1.408 1.408  1.201  1.070 1.402 0.664 0.411 0.122 0.131 7.38  0.30  0.853
#> 1043 1.423 1.426  1.207  1.067 1.420 0.704 0.439 0.125 0.140 7.57  0.73  0.762
#> 1044 1.350 1.362  1.155  0.978 1.317 0.677 0.415 0.085 0.177 7.62  0.67  0.427
#> 1045 1.305 1.311  1.103  0.924 1.280 0.716 0.415 0.122 0.180 7.45  0.40  0.701
#> 1046 1.268 1.271  1.067  0.893 1.256 0.728 0.408 0.146 0.174 7.64  0.52  0.579
#> 1047 1.201 1.201  0.997  0.826 1.189 0.728 0.411 0.146 0.171 7.65  0.56  0.488
#> 1048 1.167 1.177  0.960  0.786 1.158 0.747 0.430 0.143 0.174 7.44  0.50  0.335
#> 1049 1.262 1.262  1.058  0.908 1.250 0.683 0.411 0.122 0.149 7.30  0.44  0.610
#> 1050 1.231 1.244  1.030  0.856 1.207 0.704 0.424 0.107 0.174 7.52  0.88  0.671
#> 1051 1.247 1.256  1.049  0.860 1.216 0.713 0.415 0.110 0.189 7.49  0.60  0.610
#> 1052 1.320 1.323  1.109  0.914 1.298 0.765 0.424 0.146 0.195 7.53  0.37  0.732
#> 1053 1.317 1.317  1.103  0.924 1.305 0.762 0.427 0.155 0.180 7.48  0.36  0.762
#> 1054 1.347 1.341  1.128  0.994 1.344 0.701 0.427 0.140 0.134 7.24  0.35  0.823
#> 1055 1.396 1.402  1.192  1.061 1.384 0.649 0.418 0.101 0.131 7.34  0.44  0.945
#> 1056 1.362 1.366  1.167  0.997 1.320 0.646 0.399 0.076 0.171 7.26  0.50  0.823
#> 1057 1.283 1.286  1.079  0.902 1.274 0.741 0.418 0.146 0.177 7.19  0.38  0.579
#> 1058 1.280 1.286  1.082  0.896 1.256 0.722 0.408 0.128 0.186 7.25  0.44  0.427
#> 1059 1.222 1.225  1.021  0.878 1.216 0.677 0.405 0.128 0.143 7.26  0.51  0.457
#> 1060 1.228 1.228  1.024  0.881 1.225 0.692 0.408 0.140 0.143 7.18  0.56  0.549
#> 1061 1.262 1.262  1.064  0.908 1.244 0.674 0.396 0.122 0.155 7.18  0.30  0.732
#> 1062 1.225 1.231  1.033  0.884 1.219 0.668 0.396 0.122 0.149 7.21  0.36  0.610
#> 1063 1.308 1.314  1.113  0.920 1.268 0.698 0.402 0.104 0.192 7.56  0.50  0.610
#> 1064 1.292 1.295  1.094  0.924 1.274 0.701 0.402 0.128 0.171 7.50  0.62  0.792
#> 1065 1.280 1.283     NA     NA    NA    NA 0.427    NA 0.107   NA    NA     NA
#> 1066 1.326 1.329     NA     NA    NA    NA 0.439    NA 0.152   NA    NA     NA
#> 1067 1.341 1.344     NA     NA    NA    NA    NA    NA 1.311   NA    NA     NA
#> 1068 1.250 1.253     NA     NA    NA    NA    NA 0.104 1.554   NA    NA     NA
#> 1069 1.250 1.253     NA     NA    NA    NA    NA 0.046    NA   NA    NA     NA
#> 1070 1.308 1.308  1.100  0.917 1.286 0.741 0.415 0.143 0.183 7.58  0.47  0.671
#> 1071 1.241 1.244  1.042  0.875 1.234 0.719 0.405 0.146 0.168 7.51  0.46     NA
#> 1072 1.222 1.219  1.012  0.853 1.213 0.719 0.415 0.146 0.158 7.09  0.33     NA
#> 1073 1.234 1.231  1.018  0.896 1.225 0.661 0.427 0.113 0.122 7.30  0.55     NA
#> 1074 1.277 1.277  1.076  0.917 1.256 0.680 0.402 0.119 0.158 7.34  0.27     NA
#> 1075 1.301 1.301  1.097  0.911 1.277 0.732 0.408 0.137 0.186 7.42  0.20     NA
#> 1076 1.390 1.384  1.186  1.000 1.366 0.735 0.399 0.149 0.186 7.33  0.22     NA
#> 1077 1.301 1.298  1.103  0.951 1.286 0.674 0.393 0.128 0.152 7.66  0.61     NA
#> 1078 1.344 1.347  1.149  1.015 1.341 0.652 0.399 0.119 0.134 7.46  0.39     NA
#> 1079 1.436 1.439  1.231  1.079 1.411 0.664 0.411 0.101 0.152 7.56  0.43  0.884
#> 1080 1.350 1.347  1.149  0.988 1.317 0.658 0.399 0.098 0.162 7.48  0.39  0.792
#> 1081 1.295 1.292  1.091  0.930 1.268 0.680 0.402 0.116 0.162 7.23  0.54  0.701
#> 1082 1.259 1.256  1.058  0.875 1.237 0.728 0.396 0.149 0.183 7.37  0.40  0.457
#> 1083 1.219 1.219  1.006  0.826 1.204 0.756 0.427 0.149 0.180 7.38  0.39  0.549
#> 1084 1.244 1.244  1.030  0.890 1.237 0.695 0.424 0.131 0.140 7.20  0.28  0.579
#> 1085 1.183 1.177  0.972  0.835 1.170 0.668 0.408 0.122 0.137 7.19  0.17  0.518
#> 1086 1.274 1.280  1.073  0.920 1.262 0.683 0.415 0.116 0.152 7.51  0.60  0.610
#> 1087 1.359 1.362  1.164  0.978 1.332 0.707 0.393 0.128 0.186 7.58  0.60  0.823
#> 1088 1.320 1.317  1.122  0.942 1.305 0.722 0.393 0.149 0.180 7.56  0.33  0.762
#> 1089 1.332 1.320  1.128  0.994 1.329 0.671 0.384 0.152 0.134 7.38  0.20  0.884
#> 1090 1.344 1.341  1.143  1.030 1.341 0.622 0.399 0.110 0.113 7.36  0.44  0.823
#> 1091 1.417 1.420  1.222  1.094 1.402 0.619 0.396 0.094 0.128 7.37  0.49  0.884
#> 1092 1.301 1.308  1.122  0.969 1.274 0.613 0.372 0.088 0.152 7.37  0.42  0.732
#> 1093 1.283 1.289  1.103  0.936 1.268 0.668 0.372 0.128 0.168 7.43  0.44  0.640
#> 1094 1.186 1.183  1.000  0.850 1.180 0.658 0.366 0.143 0.149 7.41  0.51  0.457
#> 1095 1.219 1.219  1.021  0.878 1.219 0.680 0.393 0.143 0.143 7.56  0.59  0.579
#> 1096 1.177 1.170  0.972  0.817 1.158 0.686 0.399 0.131 0.155 7.40  0.55  0.457
#> 1097 1.167 1.167  0.969  0.838 1.152 0.628 0.396 0.101 0.131 7.42  0.59  0.579
#> 1098 1.262 1.265  1.073  0.933 1.247 0.628 0.384 0.104 0.140 7.40  0.43  0.792
#> 1099 1.298 1.298  1.113  0.972 1.286 0.628 0.369 0.119 0.140 7.49  0.52  0.853
#> 1100 1.366 1.362  1.180  1.027 1.356 0.658 0.366 0.140 0.152 7.25  0.71  0.853
#> 1101 1.378 1.372  1.183  1.045 1.372 0.649 0.378 0.134 0.137 7.52  0.55  0.914
#> 1102 1.372 1.369  1.170  1.052 1.366 0.631 0.396 0.116 0.119 7.54  0.52  0.792
#> 1103 1.399 1.396  1.195  1.091 1.387 0.591 0.399 0.088 0.104 7.21  0.43  0.975
#> 1104 1.366 1.366  1.177  1.052 1.341 0.582 0.381 0.076 0.125 7.45  0.54  0.853
#> 1105 1.305 1.308  1.116  0.957 1.292 0.674 0.384 0.131 0.158 7.31  0.34  0.457
#> 1106 1.210 1.210  1.018  0.853 1.195 0.680 0.384 0.131 0.165 7.57  0.51  0.579
#> 1107 1.207 1.207  1.006  0.860 1.201 0.683 0.402 0.134 0.146 7.39  0.44  0.610
#> 1108 1.204 1.201  1.003  0.878 1.201 0.649 0.399 0.125 0.125 7.30  0.54  0.549
#> 1109 1.186 1.183  0.985  0.856 1.183 0.649 0.399 0.122 0.128 7.14  0.31  0.549
#> 1110 1.247 1.250  1.061  0.917 1.234 0.634 0.378 0.113 0.143 7.34  0.49  0.701
#> 1111 1.237 1.241  1.055  0.887 1.219 0.661 0.372 0.122 0.168 7.38  0.34  0.701
#> 1112 1.283 1.280  1.085  0.933 1.259 0.652 0.387 0.113 0.152 7.13  0.61  0.732
#> 1113 1.268 1.262  1.067  0.945 1.265 0.640 0.390 0.128 0.122 7.23  0.33  0.853
#> 1114 1.338 1.335  1.128  1.009 1.335 0.652 0.418 0.116 0.119 7.29  0.33  0.853
#> 1115 1.378 1.372  1.164  1.055 1.362 0.616 0.415 0.091 0.110 7.35  0.60  0.823
#> 1116 1.320 1.317  1.119  1.003 1.298 0.588 0.393 0.079 0.116 7.21  0.59  0.853
#> 1117 1.292 1.298  1.106  0.954 1.274 0.640 0.381 0.107 0.152 7.35  0.82  0.579
#> 1118 1.170 1.167  0.975  0.820 1.158 0.674 0.384 0.134 0.155 7.34  0.72  0.640
#> 1119 1.137 1.134  0.942  0.805 1.131 0.652 0.387 0.128 0.137 7.40  0.77  0.366
#> 1120 1.225 1.225  1.021  0.902 1.225 0.643 0.405 0.119 0.119 7.16  0.47  0.610
#> 1121 1.271 1.268  1.073  0.985 1.262 0.552 0.387 0.076 0.088 7.17  0.86  0.732
#> 1122 1.256 1.256  1.055  0.914 1.237 0.646 0.402 0.104 0.140 7.27  0.61  0.640
#> 1123 1.356 1.353  1.143  0.972 1.323 0.704 0.421 0.113 0.171 7.22  0.66  0.762
#> 1124 1.423 1.420  1.210  1.049 1.405 0.713 0.424 0.128 0.162 7.07  0.52  0.853
#> 1125 1.414 1.414  1.204  1.064 1.402 0.680 0.424 0.116 0.140 7.27  0.65  0.914
#> 1126 1.436 1.433  1.213  1.106 1.433 0.649 0.439 0.104 0.107 7.15  0.33  0.975
#> 1127 1.445 1.442  1.225  1.103 1.420 0.637 0.433 0.082 0.122 7.11  0.60  0.975
#> 1128 1.399 1.402  1.195  1.055 1.359 0.610 0.415 0.055 0.140 7.13  0.77  0.640
#> 1129 1.387 1.387  1.186  1.036 1.359 0.646 0.402 0.094 0.149 7.11  0.63  0.579
#> 1130 1.201 1.195  0.994  0.844 1.195 0.698 0.402 0.146 0.149 7.10  0.58  0.457
#> 1131 1.180 1.186  0.988  0.844 1.183 0.680 0.396 0.140 0.143 7.46  0.56  0.305
#> 1132 1.122 1.122  0.920  0.811 1.116 0.607 0.402 0.094 0.110 7.27  0.61  0.518
#> 1133 1.234 1.237  1.021  0.890 1.213 0.649 0.433 0.085 0.131 7.35  0.79  0.610
#> 1134 1.286 1.280  1.058  0.911 1.253 0.683 0.445 0.091 0.146 7.08  0.63  0.701
#> 1135 1.256 1.256  1.027  0.875 1.237 0.722 0.454 0.116 0.152 7.09  0.49  0.732
#> 1136 1.369 1.372  1.161  0.978 1.341 0.728 0.418 0.128 0.183 7.37  0.58  0.792
#> 1137 1.329 1.326  1.109  0.963 1.314 0.701 0.433 0.122 0.146 7.23  0.66  0.792
#> 1138 1.359 1.353  1.140  1.036 1.353 0.634 0.427 0.104 0.104 7.22  0.67  0.914
#> 1139 1.408 1.414  1.198  1.091 1.390 0.600 0.433 0.061 0.107 7.19  0.73  1.006
#> 1140 1.445 1.433  1.237  1.113 1.414 0.604 0.390 0.088 0.125 7.17  0.75  0.914
#> 1141 1.369 1.369  1.164  1.030 1.353 0.646 0.408 0.104 0.134 7.17  0.76  0.640
#> 1142 1.244 1.247  1.049  0.896 1.231 0.668 0.396 0.119 0.152 7.29  0.78  0.640
#> 1143 1.219 1.213  1.009  0.899 1.231 0.661 0.411 0.140 0.110 7.40  0.58  0.518
#> 1144 1.225 1.222  1.015  0.896 1.222 0.652 0.415 0.119 0.119 7.49  0.64  0.579
#> 1145 1.259 1.256  1.033  0.887 1.231 0.689 0.445 0.098 0.146 7.10  0.72  0.518
#> 1146 1.274 1.274  1.045  0.890 1.244 0.704 0.454 0.094 0.155 7.21  0.81  0.610
#> 1147 1.308 1.314  1.091  0.939 1.286 0.698 0.445 0.101 0.152 7.08  0.65  0.762
#> 1148 1.378 1.378  1.140  0.972 1.347 0.750 0.472 0.110 0.168 7.07  0.70  0.853
#> 1149 1.366 1.366  1.140  0.985 1.347 0.725 0.454 0.116 0.155 7.18  0.71  0.884
#> 1150 1.387 1.384  1.155  1.039 1.378 0.677 0.454 0.107 0.116 7.18  0.49  0.853
#> 1151 1.426 1.420  1.195  1.091 1.408 0.631 0.451 0.076 0.104 7.26  0.82  0.975
#> 1152 1.454 1.451  1.228  1.109 1.420 0.622 0.448 0.055 0.119 7.16  0.93  0.853
#> 1153 1.311 1.308  1.094  0.939 1.265 0.652 0.427 0.070 0.155 7.18  0.96  0.457
#> 1154 1.268 1.262  1.058  0.902 1.253 0.701 0.411 0.134 0.155 7.25  0.87  0.701
#> 1155 1.271 1.265  1.055  0.914 1.265 0.701 0.421 0.140 0.140 7.18  0.52  0.671
#> 1156 1.237 1.241  1.036  0.930 1.237 0.613 0.408 0.098 0.107 7.31  0.80  0.640
#> 1157 1.198 1.195  0.963  0.847 1.177 0.664 0.463 0.082 0.116 7.25  0.42  0.579
#> 1158 1.228 1.234  1.000  0.853 1.207 0.710 0.469 0.094 0.146 7.11  0.53  0.549
#> 1159 1.298 1.305  1.091  0.914 1.262 0.692 0.427 0.088 0.177 7.30  0.71  0.732
#> 1160 1.362 1.369  1.155  0.985 1.344 0.719 0.427 0.122 0.171 7.29  0.58  0.701
#> 1161 1.439 1.439  1.216  1.097 1.448 0.701 0.448 0.134 0.119 7.07  0.65  0.884
#> 1162 1.399 1.402  1.167  1.042 1.390 0.698 0.466 0.107 0.125 7.05  0.68  0.853
#> 1163 1.399 1.405  1.177  1.070 1.396 0.652 0.457 0.088 0.107 7.04  0.57  0.457
#> 1164 1.417 1.423  1.198  1.064 1.390 0.655 0.451 0.070 0.134 7.00  0.58  0.884
#> 1165 1.298 1.298  1.091  0.942 1.268 0.649 0.415 0.085 0.149 7.02  0.55  0.701
#> 1166 1.237 1.231  1.030  0.841 1.198 0.713 0.402 0.122 0.189 7.00  0.47  0.488
#> 1167 1.152 1.152  0.942  0.783 1.140 0.710 0.424 0.128 0.158 7.17  0.58  0.427
#> 1168 1.231 1.231  1.024  0.893 1.216 0.646 0.411 0.104 0.131 7.27  0.70  0.701
#> 1169 1.308 1.311  1.094  0.969 1.280 0.622 0.430 0.067 0.125 7.39  0.70  0.671
#> 1170 1.280 1.274  1.061  0.920 1.250 0.661 0.430 0.091 0.140 7.25  0.70  0.732
#> 1171 1.298 1.298  1.076  0.902 1.262 0.719 0.442 0.104 0.174 7.12  0.49  0.701
#> 1172 1.311 1.305  1.091  0.896 1.274 0.756 0.430 0.131 0.195 7.19  0.60  0.732
#> 1173 1.366 1.359  1.140  0.997 1.350 0.707 0.442 0.122 0.143 7.06  0.53  0.853
#> 1174 1.393 1.390  1.167  1.055 1.384 0.661 0.448 0.101 0.113 7.02  0.56  0.884
#> 1175 1.396 1.396  1.167  1.067 1.384 0.634 0.454 0.079 0.101 7.17  0.62  0.853
#> 1176 1.350 1.350  1.140  1.015 1.317 0.600 0.421 0.055 0.125 7.24  0.72  0.762
#> 1177 1.375 1.378  1.180  1.030 1.338 0.616 0.393 0.073 0.149 7.10  0.70  0.762
#> 1178 1.286 1.286  1.094  0.945 1.274 0.661 0.387 0.125 0.149 7.19  0.61  0.732
#> 1179 1.149 1.158  0.942  0.808 1.134 0.649 0.433 0.082 0.134 7.16  0.56  0.610
#> 1180 1.231 1.219  0.985  0.884 1.213 0.661 0.469 0.091 0.101   NA    NA  0.610
#> 1181 1.323 1.311  1.076  0.978 1.280 0.604 0.469 0.037 0.098   NA    NA  0.732
#> 1182 1.207 1.201  0.960  0.863 1.183 0.637 0.479 0.061 0.098   NA    NA  0.610
#> 1183 1.274 1.274  1.045  0.902 1.250 0.698 0.460 0.094 0.143 7.05  0.49  0.701
#> 1184 1.353 1.350  1.125  0.954 1.320 0.732 0.448 0.113 0.171 7.04  0.64  0.762
#> 1185 1.356 1.353  1.134  0.960 1.329 0.741 0.439 0.128 0.174 7.17  0.65  0.762
#> 1186 1.396 1.396  1.167  1.036 1.387 0.701 0.460 0.110 0.131 7.22  0.74  0.884
#> 1187 1.439 1.439  1.204  1.100 1.423 0.646 0.466 0.076 0.104 7.17  0.75  0.945
#> 1188 1.366 1.372  1.140  0.994 1.329 0.671 0.460 0.064 0.146 7.18  0.69  0.823
#> 1189 1.292 1.298  1.079  0.911 1.262 0.701 0.439 0.094 0.168 7.41  0.80  0.579
#> 1190 1.268 1.262  1.045  0.866 1.241 0.750 0.436 0.134 0.180 7.40  0.81  0.457
#> 1191 1.250 1.219  0.942  0.881 1.237 0.710 0.558 0.091 0.061   NA    NA  0.579
#> 1192 1.201 1.195  0.905  0.844 1.189 0.689 0.579 0.049 0.061   NA    NA  0.549
#> 1193 1.213 1.198  0.899  0.841 1.189 0.695 0.607 0.030 0.058   NA    NA  0.457
#> 1194 1.283 1.280  1.033  0.899 1.241 0.683 0.494 0.055 0.134   NA    NA  0.732
#> 1195 1.268 1.256  1.018  0.893 1.231 0.680 0.472 0.082 0.125   NA    NA  0.732
#> 1196 1.326 1.317  1.091  0.963 1.301 0.677 0.454 0.094 0.128   NA    NA  0.762
#> 1197 1.347 1.347  1.137  0.988 1.323 0.674 0.421 0.104 0.149   NA    NA  0.853
#> 1198 1.344 1.341  1.113  0.991 1.329 0.677 0.454 0.101 0.122   NA    NA  0.823
#> 1199 1.414 1.408  1.192  1.091 1.408 0.634 0.436 0.098 0.101   NA    NA  0.762
#> 1200 1.344 1.335  1.131  1.021 1.314 0.585 0.411 0.064 0.110   NA    NA  0.701
#> 1201 1.347 1.329  1.091  0.991 1.308 0.634 0.472 0.061 0.101   NA    NA  0.579
#> 1202 1.183 1.189  0.975  0.832 1.164 0.668 0.421 0.104 0.143   NA    NA  0.457
#> 1203 1.140 1.149  0.927  0.792 1.137 0.686 0.442 0.110 0.134 7.43  0.56  0.366
#> 1204 1.149 1.164  0.933  0.820 1.149 0.655 0.463 0.079 0.113 7.17  0.54  0.457
#> 1205 1.167 1.167  0.942  0.823 1.137 0.631 0.448 0.064 0.119 7.14  0.81  0.579
#> 1206 1.210 1.210  0.981  0.832 1.180 0.695 0.454 0.091 0.149   NA    NA  0.579
#> 1207 1.274 1.277  1.042  0.884 1.244 0.719 0.469 0.091 0.158 7.11  0.30  0.762
#> 1208 1.311 1.314  1.091  0.924 1.283 0.722 0.442 0.113 0.168 7.13  0.53  0.762
#> 1209 1.311 1.311  1.106  0.948 1.295 0.692 0.408 0.125 0.158   NA    NA  0.701
#> 1210 1.347 1.344  1.116  0.991 1.332 0.683 0.454 0.104 0.125   NA    NA  0.823
#> 1211 1.417 1.417  1.183  1.064 1.393 0.658 0.469 0.070 0.119   NA    NA  0.823
#> 1212 1.338 1.338  1.128  0.997 1.308 0.625 0.424 0.070 0.131 7.72  0.63  0.701
#> 1213 1.305 1.295  1.076  0.960 1.277 0.634 0.439 0.079 0.116 7.43  0.64  0.579
#> 1214 1.231 1.234  1.024  0.881 1.216 0.668 0.418 0.107 0.146 7.55  0.44  0.579
#> 1215 1.228 1.231  0.969  0.878 1.219 0.680 0.524 0.064 0.091   NA    NA     NA
#> 1216 1.244 1.234  0.997  0.917 1.222 0.610 0.475 0.055 0.079   NA    NA     NA
#> 1217 1.219 1.219  0.991  0.872 1.189 0.631 0.460 0.052 0.119   NA    NA  0.549
#> 1218 1.250 1.244  1.003  0.917 1.231 0.628 0.485 0.058 0.085   NA    NA  0.762
#> 1219 1.292 1.274  1.015  0.902 1.262 0.716 0.518 0.085 0.113   NA    NA  0.762
#> 1220 1.359 1.353  1.094  0.966 1.335 0.738 0.515 0.094 0.128   NA    NA  0.792
#> 1221 1.362 1.356  1.109  0.988 1.344 0.713 0.494 0.098 0.122   NA    NA  0.823
#> 1222 1.439 1.423  1.158  1.070 1.417 0.695 0.530 0.076 0.088   NA    NA  0.914
#> 1223 1.454 1.454  1.204  1.113 1.439 0.649 0.500 0.058 0.091   NA    NA  0.274
#> 1224 1.414 1.414  1.186  1.058 1.378 0.637 0.457 0.052 0.128   NA    NA  0.792
#> 1225 1.375 1.378  1.143  1.015 1.347 0.661 0.466 0.067 0.128   NA    NA  0.823
#> 1226 1.271 1.268  1.055  0.917 1.241 0.646 0.427 0.082 0.137   NA    NA  0.579
#> 1227 1.301 1.283  1.030  0.939 1.283 0.686 0.509 0.085 0.091   NA    NA  0.610
#> 1228 1.250 1.222  0.948  0.881 1.228 0.698 0.549 0.082 0.067   NA    NA  0.579
#> 1229 1.228 1.201  0.933  0.881 1.213 0.664 0.536 0.076 0.052   NA    NA  0.701
#> 1230 1.292 1.277  1.018  0.911 1.256 0.689 0.518 0.064 0.107   NA    NA  0.732
#> 1231 1.402 1.384  1.113  1.018 1.369 0.701 0.543 0.064 0.094   NA    NA  0.823
#> 1232 1.326 1.317  1.049  0.936 1.308 0.747 0.536 0.098 0.113   NA    NA  0.366
#> 1233 1.359 1.344  1.058  0.972 1.341 0.738 0.576 0.076 0.085   NA    NA  0.792
#> 1234 1.381 1.369  1.100  1.021 1.375 0.707 0.533 0.094 0.079   NA    NA  0.853
#> 1235 1.460 1.451  1.201  1.109 1.442 0.661 0.500 0.070 0.091   NA    NA  0.884
#> 1236 1.381 1.362  1.113  1.018 1.347 0.658 0.500 0.064 0.094   NA    NA  0.701
#> 1237 1.286 1.301  1.061  0.902 1.247 0.689 0.479 0.052 0.158   NA    NA  0.610
#> 1238 1.274 1.283  1.018  0.893 1.259 0.728 0.533 0.070 0.125   NA    NA  0.610
#> 1239 1.234 1.222  0.930  0.860 1.222 0.725 0.585 0.070 0.070   NA    NA  0.610
#> 1240 1.244 1.195  0.930  0.860 1.225 0.735 0.533 0.131 0.070   NA    NA  0.457
#> 1241 1.231 1.219  0.951  0.847 1.195 0.692 0.539 0.049 0.104   NA    NA  0.610
#> 1242 1.329 1.320  1.039  0.930 1.295 0.732 0.561 0.061 0.110   NA    NA  0.671
#> 1243 1.384 1.366  1.091  0.978 1.338 0.719 0.552 0.055 0.113   NA    NA  0.732
#> 1244 1.423 1.405  1.137  1.015 1.384 0.741 0.536 0.082 0.122   NA    NA  0.853
#> 1245 1.399 1.396  1.134  1.021 1.384 0.722 0.524 0.085 0.113   NA    NA  0.884
#> 1246 1.451 1.445  1.173  1.067 1.426 0.716 0.546 0.064 0.107   NA    NA  0.853
#> 1247 1.399 1.390  1.128  1.018 1.372 0.710 0.527 0.073 0.110   NA    NA  0.823
#> 1248 1.335 1.317  1.061  0.966 1.298 0.668 0.509 0.064 0.094   NA    NA  0.762
#> 1249 1.323 1.323  1.082  0.945 1.286 0.683 0.482 0.064 0.137   NA    NA  0.579
#> 1250 1.362 1.353  1.073  0.960 1.338 0.756 0.564 0.079 0.113   NA    NA  0.518
#> 1251 1.228 1.210  0.948  0.841 1.210 0.738 0.527 0.104 0.107   NA    NA  0.579
#> 1252 1.216 1.192  0.936  0.860 1.198 0.680 0.509 0.094 0.076   NA    NA  0.579
#> 1253 1.198 1.180  0.930  0.853 1.186 0.661 0.497 0.088 0.076   NA    NA  0.457
#> 1254 1.283 1.283  1.039  0.927 1.268 0.686 0.488 0.085 0.113   NA    NA  0.762
#> 1255 1.271 1.262  0.994  0.890 1.244 0.710 0.533 0.073 0.104   NA    NA  0.732
#> 1256 1.295 1.280  1.003  0.896 1.268 0.741 0.552 0.082 0.107   NA    NA  0.732
#> 1257 1.405 1.390  1.122  1.073 1.393 0.640 0.536 0.055 0.049   NA    NA  0.914
#> 1258 1.420 1.417  1.143  1.058 1.405 0.695 0.549 0.061 0.085   NA    NA     NA
#> 1259 1.417 1.408  1.149  1.033 1.390 0.713 0.521 0.076 0.116   NA    NA  0.823
#> 1260 1.390 1.393  1.137  1.021 1.362 0.683 0.512 0.055 0.116   NA    NA  0.671
#> 1261 1.301 1.311  1.055  0.920 1.280 0.719 0.512 0.073 0.134   NA    NA  0.488
#> 1262 1.231 1.213  0.939  0.847 1.213 0.728 0.546 0.091 0.091   NA    NA  0.579
#> 1263 1.219 1.219  0.930  0.829 1.207 0.759 0.579 0.079 0.101   NA    NA  0.518
#> 1264 1.253 1.250  0.969  0.887 1.244 0.710 0.564 0.064 0.082   NA    NA  0.396
#> 1265 1.268 1.280  1.033  0.914 1.253 0.677 0.497 0.061 0.119   NA    NA  0.640
#> 1266 1.256 1.259  0.991  0.863 1.213 0.704 0.536 0.040 0.128   NA    NA  0.701
#> 1267 1.247 1.228  0.936  0.832 1.216 0.771 0.582 0.085 0.104   NA    NA  0.701
#> 1268 1.372 1.353  1.033  0.927 1.332 0.814 0.640 0.067 0.107   NA    NA  0.732
#> 1269 1.347 1.335  1.058  0.942 1.326 0.768 0.555 0.098 0.116   NA    NA  0.792
#> 1270 1.405 1.396  1.137  1.045 1.399 0.704 0.518 0.094 0.091   NA    NA  0.884
#> 1271 1.366 1.359  1.103  1.000 1.338 0.680 0.512 0.064 0.104   NA    NA  0.914
#> 1272 1.381 1.375  1.109  1.003 1.350 0.695 0.527 0.061 0.107   NA    NA  0.732
#> 1273 1.308 1.295  1.021  0.924 1.277 0.710 0.552 0.061 0.098   NA    NA     NA
#> 1274 1.277 1.283  1.021  0.902 1.259 0.713 0.521 0.073 0.119   NA    NA     NA
#> 1275 1.167 1.177  0.905  0.799 1.161 0.728 0.543 0.079 0.107   NA    NA  0.396
#> 1276 1.183 1.170  0.914  0.835 1.177 0.683 0.512 0.091 0.079   NA    NA  0.335
#> 1277 1.298 1.289  1.000  0.905 1.277 0.747 0.582 0.070 0.094   NA    NA  0.701
#> 1278 1.323 1.308  1.030  0.924 1.280 0.713 0.558 0.049 0.107   NA    NA  0.732
#> 1279 1.362 1.350  1.064  0.957 1.332 0.750 0.576 0.067 0.107   NA    NA  0.610
#> 1280 1.375 1.381  1.113  0.969 1.359 0.780 0.533 0.104 0.143   NA    NA  0.792
#> 1281 1.381 1.366  1.079  0.969 1.353 0.768 0.573 0.085 0.110   NA    NA  0.823
#> 1282 1.472 1.463  1.216  1.122 1.466 0.686 0.494 0.098 0.094   NA    NA  0.914
#> 1283 1.430 1.417  1.170  1.073 1.408 0.668 0.494 0.076 0.098   NA    NA  0.914
#> 1284 1.460 1.445  1.204  1.091 1.426 0.668 0.482 0.073 0.113   NA    NA  0.792
#> 1285 1.268 1.262  0.997  0.884 1.244 0.719 0.533 0.073 0.113   NA    NA  0.549
#> 1286 1.244 1.231  0.936  0.838 1.225 0.774 0.594 0.082 0.098   NA    NA  0.610
#> 1287 1.183 1.170  0.908  0.814 1.164 0.701 0.527 0.079 0.094   NA    NA  0.518
#> 1288 1.216 1.189  0.924  0.844 1.201 0.719 0.527 0.110 0.079   NA    NA  0.488
#> 1289 1.192 1.189  0.927  0.841 1.183 0.686 0.524 0.076 0.085   NA    NA  0.549
#> 1290 1.210 1.186  0.920  0.832 1.186 0.707 0.530 0.088 0.088   NA    NA  0.701
#> 1291 1.280 1.265  1.018  0.890 1.244 0.707 0.494 0.085 0.128   NA    NA  0.762
#> 1292 1.295 1.286  1.045  0.899 1.268 0.735 0.482 0.107 0.146   NA    NA  0.732
#> 1293 1.317 1.289  1.033  0.966 1.301 0.671 0.512 0.091 0.067   NA    NA     NA
#> 1294 1.378 1.366  1.079  1.027 1.372 0.689 0.576 0.061 0.052   NA    NA  0.853
#> 1295 1.417 1.378  1.049  1.042 1.378 0.668 0.658 0.003 0.006   NA    NA  0.945
#> 1296 1.463 1.423  1.094  1.091 1.426 0.668 0.658 0.006 0.003   NA    NA  0.914
#> 1297 1.457 1.423  1.094  1.076 1.426 0.704 0.658 0.027 0.018   NA    NA  0.732
#> 1298 1.347 1.317  0.951  0.951 1.329 0.756 0.732 0.024 0.000   NA    NA  0.640
#> 1299 1.311 1.289  1.052  0.942 1.298 0.710 0.479 0.122 0.110   NA    NA  0.274
#> 1300 1.219 1.225  0.972  0.860 1.222 0.725 0.506 0.107 0.113   NA    NA  0.518
#> 1301 1.301 1.320  1.064  0.966 1.298 0.668 0.512 0.058 0.098   NA    NA  0.610
#> 1302 1.314 1.301  1.082  0.951 1.286 0.671 0.439 0.101 0.131   NA    NA  0.762
#> 1303 1.408 1.408  1.155  1.012 1.375 0.725 0.506 0.076 0.143   NA    NA  0.823
#> 1304 1.469 1.472  1.216  1.079 1.457 0.756 0.512 0.107 0.137   NA    NA     NA
#> 1305 1.396 1.396  1.155  1.042 1.390 0.692 0.485 0.094 0.113   NA    NA  0.762
#> 1306 1.390 1.378  1.116  1.027 1.381 0.707 0.527 0.091 0.088   NA    NA  0.884
#> 1307 1.442 1.433  1.183  1.085 1.414 0.661 0.503 0.061 0.098   NA    NA  0.975
#> 1308 1.433 1.408  1.164  1.082 1.396 0.628 0.485 0.061 0.082   NA    NA  0.853
#> 1309 1.411 1.408  1.177  1.042 1.384 0.683 0.463 0.085 0.134   NA    NA  0.762
#> 1310 1.298 1.298  1.024  0.911 1.277 0.735 0.549 0.073 0.113   NA    NA  0.335
#> 1311 1.314 1.292  1.024  0.933 1.301 0.738 0.533 0.113 0.091   NA    NA     NA
#> 1312 1.289 1.283  1.030  0.942 1.283 0.683 0.503 0.091 0.088   NA    NA  0.500
#> 1313 1.405 1.405  1.170  1.058 1.387 0.661 0.469 0.079 0.113   NA    NA  0.786
#> 1314 1.387 1.378  1.122  1.033 1.366 0.664 0.512 0.064 0.088   NA    NA  0.774
#> 1315 1.375 1.378  1.137  0.972 1.344 0.747 0.482 0.101 0.165   NA    NA  0.747
#> 1316 1.375 1.366  1.100  0.957 1.344 0.771 0.530 0.098 0.143   NA    NA  0.799
#> 1317 1.372 1.359  1.100  0.985 1.356 0.744 0.518 0.110 0.116   NA    NA  0.835
#> 1318 1.414 1.411  1.161  1.073 1.411 0.674 0.500 0.085 0.088   NA    NA  0.924
#> 1319 1.460 1.457  1.216  1.116 1.442 0.652 0.482 0.070 0.101   NA    NA  0.966
#> 1320 1.433 1.430  1.213  1.088 1.402 0.628 0.436 0.067 0.125   NA    NA  0.869
#> 1321 1.417 1.414  1.164  1.042 1.387 0.692 0.500 0.070 0.122   NA    NA  0.582
#> 1322 1.301 1.329  1.079  0.945 1.280 0.671 0.500 0.037 0.134   NA    NA  0.570
#> 1323 1.289 1.280  1.015  0.927 1.283 0.716 0.530 0.098 0.088   NA    NA  0.765
#> 1324 1.262 1.241  0.985  0.914 1.250 0.671 0.509 0.091 0.070   NA    NA  0.506
#> 1325 1.262 1.262  1.000  0.893 1.237 0.689 0.524 0.058 0.107   NA    NA  0.716
#> 1326 1.277 1.271  1.036  0.920 1.259 0.674 0.469 0.088 0.116   NA    NA  0.573
#> 1327 1.381 1.378  1.155  1.039 1.362 0.646 0.445 0.085 0.116   NA    NA  0.902
#> 1328 1.445 1.448  1.222  1.082 1.439 0.713 0.454 0.119 0.140   NA    NA  0.832
#> 1329 1.393 1.384  1.131  1.018 1.381 0.722 0.506 0.104 0.113   NA    NA  0.838
#> 1330 1.393 1.393  1.152  1.042 1.387 0.686 0.479 0.098 0.110 7.19  0.50  0.856
#> 1331 1.484 1.484  1.253  1.161 1.475 0.628 0.463 0.073 0.091   NA    NA  0.942
#> 1332 1.402 1.408  1.192  1.070 1.372 0.604 0.433 0.049 0.122   NA    NA  0.716
#> 1333 1.332 1.326  1.097  0.963 1.305 0.683 0.454 0.094 0.134   NA    NA  0.728
#> 1334 1.283 1.283  1.058  0.924 1.277 0.710 0.448 0.128 0.134   NA    NA  0.728
#> 1335 1.271 1.268  1.064  0.920 1.250 0.661 0.405 0.113 0.143 7.19  0.58  0.680
#> 1336 1.350 1.350  1.149  1.030 1.335 0.613 0.402 0.091 0.119 7.44  0.78  0.811
#> 1337 1.326 1.323  1.125  1.003 1.311 0.619 0.399 0.098 0.122 7.20  0.66  0.771
#> 1338 1.323 1.323  1.125  0.978 1.308 0.658 0.396 0.116 0.146 7.46  0.86  0.753
#> 1339 1.411 1.408  1.216  1.058 1.384 0.655 0.387 0.110 0.158 7.42  0.81  0.945
#> 1340 1.402 1.402  1.204  1.055 1.384 0.655 0.393 0.113 0.149 7.32  0.87  0.920
#> 1341 1.472 1.469  1.268  1.146 1.469 0.646 0.405 0.119 0.122 7.26  0.67  0.951
#> 1342 1.457 1.451  1.237  1.119 1.445 0.649 0.424 0.107 0.119 7.36  0.68  1.024
#> 1343 1.521 1.521  1.320  1.204 1.506 0.607 0.402 0.088 0.116 7.32  0.55  1.030
#> 1344 1.417 1.417  1.231  1.097 1.384 0.573 0.372 0.067 0.134 7.21  0.76  0.887
#> 1345 1.366 1.366  1.164  1.000 1.329 0.661 0.399 0.098 0.165 7.12  0.65  0.823
#> 1346 1.344 1.353  1.164  0.991 1.332 0.683 0.381 0.128 0.174 7.21  0.55     NA
#> 1347 1.155 1.152  0.951  0.799 1.140 0.686 0.399 0.134 0.152 7.29  0.40  0.494
#> 1348 1.167 1.152  0.948  0.829 1.152 0.649 0.408 0.122 0.119 7.31  0.56  0.485
#> 1349 1.250 1.244  1.039  0.930 1.234 0.610 0.408 0.091 0.110 7.42  0.84  0.649
#> 1350 1.326 1.329  1.131  1.000 1.317 0.631 0.399 0.101 0.131 7.38  0.75  0.792
#> 1351 1.387 1.390  1.189  1.018 1.372 0.704 0.399 0.134 0.171 7.14  0.52  0.771
#> 1352 1.399 1.396  1.186  1.027 1.384 0.710 0.424 0.128 0.158 7.12  0.64  0.866
#> 1353 1.375 1.372  1.158  1.030 1.366 0.671 0.430 0.113 0.128 7.10  0.60  0.893
#> 1354 1.356 1.353  1.140  1.036 1.359 0.646 0.427 0.116 0.104 7.00  0.45  0.908
#> 1355 1.423 1.420  1.204  1.088 1.408 0.637 0.430 0.091 0.116 7.13  0.52  1.003
#> 1356 1.338 1.338  1.143  1.009 1.311 0.604 0.390 0.079 0.134 7.14  0.66  0.689
#> 1357 1.268 1.268  1.082  0.933 1.244 0.619 0.372 0.098 0.149 7.12  0.74  0.591
#> 1358 1.268 1.268  1.073  0.914 1.253 0.677 0.387 0.131 0.158 7.24  0.55  0.555
#> 1359 1.198 1.192  0.994  0.856 1.195 0.674 0.396 0.140 0.137 7.52  0.54  0.457
#> 1360 1.137 1.137  0.939  0.826 1.134 0.619 0.396 0.110 0.113 7.20  0.59  0.549
#> 1361 1.228 1.231  1.027  0.911 1.225 0.625 0.408 0.101 0.116 7.37  0.65  0.518
#> 1362 1.225 1.225  1.030  0.920 1.210 0.579 0.393 0.076 0.110 7.35  0.88  0.610
#> 1363 1.344 1.341  1.152  1.018 1.326 0.616 0.381 0.101 0.134 7.86  1.28  0.853
#> 1364 1.384 1.384  1.177  1.018 1.366 0.695 0.418 0.119 0.158 7.30  0.79  0.853
#> 1365 1.356 1.353  1.134  1.006 1.356 0.701 0.439 0.134 0.128 7.11  0.64  0.792
#> 1366 1.426 1.426  1.216  1.125 1.426 0.600 0.418 0.091 0.091 7.17  1.04  0.975
#> 1367 1.503 1.503  1.289  1.192 1.490 0.597 0.427 0.073 0.098 7.59  0.77  1.067
#> 1368 1.362 1.362  1.155  1.036 1.335 0.600 0.415 0.067 0.119 7.08  0.70  0.823
#> 1369 1.375 1.378  1.180  1.027 1.347 0.637 0.399 0.085 0.152 7.25  0.71  0.549
#> 1370 1.283 1.283  1.085  0.930 1.256 0.649 0.396 0.098 0.155 7.30  0.72  0.579
#> 1371 1.180 1.183  0.988  0.817 1.152 0.668 0.390 0.107 0.171 7.26  0.47  0.518
#> 1372 1.204 1.207  1.006  0.872 1.195 0.643 0.405 0.104 0.134 7.34  0.88  0.558
#> 1373 1.241 1.231  1.009  0.887 1.207 0.640 0.442 0.076 0.122 7.14  0.44  0.570
#> 1374 1.292 1.292  1.073  0.945 1.268 0.649 0.439 0.082 0.128 7.11  0.67  0.722
#> 1375 1.347 1.347  1.137  1.000 1.329 0.658 0.421 0.101 0.137 7.20  0.81  0.817
#> 1376 1.350 1.350  1.134  0.985 1.335 0.701 0.433 0.119 0.149 7.29  0.85  0.872
#> 1377 1.390 1.390  1.180  1.042 1.381 0.677 0.418 0.122 0.137 7.40  1.03  0.902
#> 1378 1.353 1.353  1.119  0.997 1.347 0.698 0.469 0.107 0.122   NA    NA  0.927
#> 1379 1.436 1.436  1.204  1.082 1.408 0.652 0.463 0.067 0.122   NA    NA     NA
#> 1380 1.430 1.426  1.213  1.100 1.396 0.594 0.427 0.055 0.113 7.08  0.78  0.890
#> 1381 1.433 1.433  1.225  1.070 1.393 0.649 0.415 0.079 0.155 6.99  0.55  0.881
#> 1382 1.301 1.305  1.103  0.930 1.277 0.695 0.399 0.122 0.174 7.30  0.67  0.668
#> 1383 1.277 1.277  1.067  0.899 1.259 0.716 0.424 0.125 0.168 7.02  0.51  0.393
#> 1384 1.234 1.231  1.027  0.908 1.219 0.622 0.411 0.091 0.119 7.23  0.60  0.463
#> 1385 1.329 1.326  1.116  1.009 1.317 0.613 0.421 0.085 0.107 7.26  0.69  0.799
#> 1386 1.387 1.390  1.180  1.052 1.366 0.628 0.418 0.082 0.128 7.18  0.36  0.829
#> 1387 1.359 1.362  1.149  0.988 1.338 0.701 0.430 0.110 0.162 7.08  0.61  0.668
#> 1388 1.356 1.353  1.137  0.975 1.335 0.722 0.436 0.125 0.162 7.13  0.69  0.838
#> 1389 1.420 1.414  1.198  1.073 1.411 0.677 0.433 0.119 0.125 7.05  0.64  0.902
#> 1390 1.436 1.430  1.204  1.088 1.430 0.680 0.454 0.110 0.116 7.07  0.64  0.942
#> 1391 1.524 1.515  1.277  1.183 1.512 0.655 0.475 0.085 0.094   NA    NA  0.853
#> 1392 1.423 1.420  1.189  1.064 1.390 0.652 0.466 0.061 0.125   NA    NA  0.893
#> 1393 1.320 1.317  1.109  0.969 1.286 0.634 0.411 0.082 0.140   NA    NA  0.732
#> 1394 1.298 1.295  1.088  0.917 1.271 0.707 0.415 0.122 0.171   NA    NA  0.546
#> 1395 1.323 1.317  1.097  0.963 1.308 0.692 0.442 0.116 0.134   NA    NA  0.735
#> 1396 1.286 1.274  1.045  0.951 1.274 0.646 0.460 0.091 0.091   NA    NA  0.652
#> 1397 1.295 1.286  1.049  0.948 1.271 0.643 0.475 0.070 0.098   NA    NA  0.594
#> 1398 1.347 1.344  1.116  0.994 1.311 0.634 0.457 0.055 0.122   NA    NA  0.762
#> 1399 1.381 1.381  1.161  0.991 1.347 0.716 0.436 0.107 0.174 7.13  0.71  0.866
#> 1400 1.390 1.387  1.152  0.985 1.359 0.747 0.472 0.107 0.165   NA    NA  0.802
#> 1401 1.399 1.396  1.167  1.021 1.384 0.725 0.457 0.122 0.146   NA    NA  0.899
#> 1402 1.390 1.387  1.158  1.049 1.384 0.664 0.457 0.101 0.107   NA    NA  0.942
#> 1403 1.402 1.398  1.174  1.062 1.385 0.646 0.448 0.086 0.112 6.95  0.59  0.936
#> 1404 1.344 1.332  1.103  0.994 1.308 0.625 0.454 0.064 0.110   NA    NA  0.692
#> 1405 1.378 1.369  1.155  1.021 1.338 0.628 0.430 0.067 0.131   NA    NA  0.649
#> 1406 1.289 1.292  1.082  0.948 1.274 0.655 0.418 0.101 0.134   NA    NA  0.661
#> 1407 1.232 1.238  1.008  0.879 1.219 0.680 0.460 0.091 0.129   NA    NA  0.418
#> 1408 1.228 1.241  1.000  0.881 1.216 0.674 0.479 0.073 0.119   NA    NA  0.418
#> 1409 1.265 1.250  1.003  0.924 1.250 0.652 0.494 0.079 0.079   NA    NA  0.701
#> 1410 1.292 1.289  1.052  0.939 1.262 0.649 0.472 0.061 0.113   NA    NA  0.695
#> 1411 1.362 1.366  1.131  0.997 1.338 0.680 0.469 0.076 0.134   NA    NA  0.802
#> 1412 1.378 1.375  1.143  0.988 1.347 0.722 0.466 0.104 0.155   NA    NA  0.829
#> 1413 1.420 1.417  1.195  1.015 1.393 0.759 0.448 0.131 0.180 7.08  0.59  0.887
#> 1414 1.414 1.411  1.177  1.064 1.408 0.686 0.469 0.107 0.113   NA    NA  0.884
#> 1415 1.408 1.399  1.155  1.073 1.393 0.640 0.494 0.067 0.082   NA    NA  0.805
#> 1416 1.362 1.356  1.137  1.012 1.329 0.634 0.445 0.064 0.125   NA    NA  0.780
#> 1417 1.407 1.398  1.169  1.033 1.370 0.674 0.459 0.079 0.136   NA    NA  0.750
#> 1418 1.280 1.274  1.036  0.899 1.262 0.722 0.479 0.110 0.137   NA    NA  0.628
#> 1419 1.227 1.232  1.010  0.870 1.212 0.683 0.443 0.107 0.140   NA    NA  0.610
#> 1420 1.268 1.262  1.021  0.905 1.247 0.686 0.479 0.091 0.116   NA    NA  0.646
#> 1421 1.298 1.289  1.042  0.942 1.277 0.668 0.494 0.076 0.098   NA    NA  0.591
#> 1422 1.292 1.289  1.042  0.914 1.262 0.695 0.497 0.070 0.128   NA    NA  0.649
#> 1423 1.320 1.301  1.049  0.939 1.289 0.701 0.512 0.082 0.110   NA    NA  0.735
#> 1424 1.405 1.402  1.164  1.015 1.384 0.738 0.472 0.116 0.149   NA    NA  0.802
#> 1425 1.366 1.359  1.119  0.969 1.344 0.747 0.482 0.116 0.149   NA    NA  0.814
#> 1426 1.384 1.387  1.152  1.012 1.369 0.713 0.472 0.104 0.140   NA    NA  0.814
#> 1427 1.430 1.426  1.180  1.070 1.411 0.680 0.494 0.079 0.107   NA    NA  0.890
#> 1428 1.439 1.433  1.207  1.085 1.405 0.640 0.457 0.064 0.122   NA    NA  0.899
#> 1429 1.414 1.417  1.186  1.036 1.375 0.677 0.466 0.064 0.149   NA    NA  0.585
#> 1430 1.408 1.405  1.158  1.009 1.381 0.744 0.491 0.104 0.152   NA    NA  0.680
#> 1431 1.344 1.344  1.106  0.960 1.320 0.719 0.475 0.101 0.146   NA    NA  0.759
#> 1432 1.338 1.323  1.070  0.969 1.320 0.701 0.503 0.098 0.101   NA    NA  0.485
#> 1433 1.420 1.405  1.152  1.049 1.399 0.704 0.509 0.088 0.104   NA    NA  0.698
#> 1434 1.350 1.338  1.082  0.963 1.320 0.713 0.515 0.079 0.119   NA    NA  0.783
#> 1435 1.402 1.390  1.116  0.994 1.366 0.744 0.546 0.073 0.125   NA    NA  0.841
#> 1436 1.396 1.393  1.125  1.000 1.375 0.750 0.539 0.088 0.122   NA    NA  0.789
#> 1437 1.405 1.399  1.149  1.003 1.381 0.753 0.500 0.107 0.146   NA    NA  0.811
#> 1438 1.414 1.408  1.155  1.039 1.399 0.719 0.503 0.098 0.116   NA    NA  0.866
#> 1439 1.430 1.405  1.152  1.061 1.402 0.683 0.509 0.085 0.088   NA    NA  0.930
#> 1440 1.478 1.475  1.228  1.088 1.439 0.698 0.491 0.064 0.140   NA    NA  0.811
#> 1441 1.475 1.457  1.192  1.094 1.442 0.698 0.530 0.070 0.098   NA    NA  0.844
#> 1442 1.292 1.301  1.061  0.887 1.256 0.735 0.482 0.079 0.174   NA    NA  0.472
#> 1443 1.289 1.280  1.012  0.875 1.262 0.777 0.533 0.104 0.140   NA    NA  0.463
#> 1444 1.283 1.271  1.015  0.899 1.268 0.741 0.512 0.110 0.119   NA    NA  0.658
#> 1445 1.308 1.301  1.052  0.930 1.280 0.701 0.497 0.079 0.122   NA    NA  0.613
#> 1446 1.369 1.359  1.103  1.006 1.341 0.674 0.515 0.061 0.098   NA    NA  0.829
#> 1447 1.356 1.341  1.070  0.957 1.329 0.744 0.539 0.091 0.113   NA    NA  0.671
#> 1448 1.426 1.423  1.146  1.021 1.408 0.774 0.555 0.094 0.125   NA    NA  0.786
#> 1449 1.448 1.439  1.195  1.045 1.426 0.762 0.491 0.122 0.149   NA    NA  0.847
#> 1450 1.430 1.426  1.183  1.067 1.414 0.695 0.491 0.091 0.113   NA    NA  0.878
#> 1451 1.454 1.445  1.198  1.094 1.430 0.668 0.494 0.070 0.104   NA    NA  0.951
#> 1452 1.472 1.457  1.207  1.100 1.433 0.668 0.503 0.058 0.107   NA    NA  0.872
#> 1453 1.399 1.390  1.146  1.030 1.359 0.655 0.488 0.052 0.116   NA    NA  0.509
#> 1454 1.378 1.375  1.131  0.994 1.347 0.710 0.485 0.088 0.137   NA    NA  0.637
#> 1455 1.338 1.332  1.076  0.963 1.326 0.722 0.512 0.098 0.113   NA    NA  0.549
#> 1456 1.268 1.253  0.981  0.899 1.244 0.686 0.539 0.067 0.082   NA    NA  0.668
#> 1457 1.298 1.274  1.009  0.933 1.274 0.680 0.530 0.073 0.076   NA    NA  0.722
#> 1458 1.301 1.292  1.039  0.936 1.280 0.689 0.503 0.079 0.104   NA    NA  0.677
#> 1459 1.381 1.372  1.113  0.994 1.350 0.713 0.521 0.073 0.119   NA    NA  0.802
#> 1460 1.390 1.390  1.119  0.985 1.366 0.762 0.543 0.088 0.131   NA    NA  0.783
#> 1461 1.411 1.405  1.125  1.012 1.393 0.762 0.561 0.088 0.116   NA    NA  0.796
#> 1462 1.518 1.500  1.241  1.167 1.518 0.698 0.518 0.107 0.070   NA    NA  0.945
#> 1463 1.472 1.460  1.216  1.106 1.442 0.674 0.488 0.076 0.113   NA    NA  0.814
#> 1464 1.561 1.561  1.314  1.186 1.518 0.661 0.491 0.043 0.128   NA    NA  0.924
#> 1465 1.472 1.469  1.216  1.070 1.436 0.732 0.506 0.079 0.149   NA    NA  0.838
#> 1466 1.305 1.283  1.015  0.905 1.277 0.744 0.539 0.098 0.107   NA    NA  0.530
#> 1467 1.256 1.247  0.985  0.875 1.231 0.713 0.524 0.079 0.107   NA    NA  0.533
#> 1468 1.308 1.298  1.042  0.945 1.286 0.686 0.512 0.073 0.101   NA    NA  0.725
#> 1469 1.228 1.231  0.960  0.850 1.210 0.722 0.543 0.070 0.110   NA    NA  0.488
#> 1470 1.372 1.369  1.094  0.975 1.338 0.728 0.549 0.061 0.119   NA    NA  0.786
#> 1471 1.466 1.460  1.189  1.061 1.433 0.744 0.546 0.073 0.125   NA    NA  0.881
#> 1472 1.454 1.448  1.189  1.055 1.433 0.756 0.515 0.104 0.134   NA    NA  0.875
#> 1473 1.414 1.402  1.134  1.018 1.393 0.750 0.533 0.101 0.119   NA    NA  0.777
#> 1474 1.417 1.399  1.143  1.036 1.393 0.710 0.512 0.094 0.104   NA    NA  0.853
#> 1475 1.509 1.494  1.231  1.131 1.484 0.707 0.527 0.079 0.101   NA    NA  0.997
#> 1476 1.484 1.460  1.216  1.116 1.439 0.646 0.488 0.058 0.101   NA    NA  0.805
#> 1477 1.463 1.457  1.201  1.061 1.420 0.725 0.512 0.070 0.140   NA    NA  0.792
#> 1478 1.369 1.366  1.091  0.951 1.329 0.750 0.546 0.067 0.140   NA    NA  0.701
#> 1479 1.344 1.347  1.064  0.963 1.347 0.768 0.564 0.101 0.104   NA    NA  0.664
#> 1480 1.344 1.350  1.076  0.969 1.332 0.728 0.546 0.073 0.107   NA    NA  0.607
#> 1481 1.439 1.433  1.164  1.042 1.411 0.735 0.536 0.079 0.119   NA    NA  0.677
#> 1482 1.308 1.295  1.036  0.924 1.280 0.713 0.521 0.079 0.110   NA    NA  0.774
#> 1483 1.350 1.332  1.039  0.920 1.320 0.796 0.585 0.091 0.119   NA    NA  0.759
#> 1484 1.442 1.420  1.137  1.030 1.405 0.756 0.567 0.079 0.110   NA    NA  0.911
#> 1485 1.475 1.463  1.198  1.085 1.454 0.735 0.530 0.094 0.113   NA    NA  0.936
#> 1486 1.430 1.420  1.158  1.052 1.414 0.725 0.527 0.091 0.107   NA    NA  0.899
#> 1487 1.466 1.454  1.183  1.082 1.439 0.710 0.543 0.064 0.101   NA    NA  0.978
#> 1488 1.329 1.326  1.085  0.954 1.286 0.661 0.482 0.049 0.131   NA    NA  0.728
#> 1489 1.420 1.417  1.152  1.036 1.378 0.686 0.524 0.043 0.119   NA    NA  0.616
#> 1490 1.375 1.372  1.094  0.969 1.341 0.747 0.552 0.070 0.128   NA    NA  0.512
#> 1491 1.268 1.265  0.963  0.866 1.244 0.759 0.600 0.058 0.098   NA    NA  0.561
#> 1492 1.265 1.253  0.975  0.887 1.244 0.713 0.558 0.067 0.088   NA    NA  0.671
#> 1493 1.286 1.274  1.021  0.920 1.262 0.686 0.503 0.082 0.104   NA    NA  0.664
#> 1494 1.384 1.372  1.113  1.012 1.356 0.692 0.521 0.070 0.098   NA    NA  0.847
#> 1495 1.341 1.335  1.076  0.957 1.314 0.713 0.515 0.079 0.119   NA    NA  0.716
#> 1496 1.396 1.393  1.106  0.997 1.378 0.759 0.570 0.079 0.110   NA    NA  0.832
#> 1497 1.396 1.384  1.109  1.006 1.387 0.762 0.546 0.110 0.104   NA    NA  0.860
#> 1498 1.408 1.399  1.134  1.042 1.396 0.707 0.530 0.085 0.091   NA    NA  0.893
#> 1499 1.524 1.503  1.237  1.146 1.497 0.704 0.527 0.082 0.091   NA    NA  0.899
#> 1500 1.414 1.402  1.158  1.033 1.372 0.680 0.488 0.067 0.125   NA    NA  0.756
#> 1501 1.426 1.430  1.180  1.049 1.399 0.698 0.497 0.070 0.134   NA    NA  0.774
#> 1502 1.295 1.286  1.052  0.933 1.259 0.652 0.466 0.070 0.119   NA    NA  0.780
#> 1503 1.323 1.308  1.052  0.969 1.305 0.664 0.512 0.073 0.079   NA    NA  0.765
#> 1504 1.317 1.295  1.036  0.942 1.295 0.707 0.521 0.091 0.091   NA    NA  0.786
#> 1505 1.366 1.341  1.070  0.985 1.341 0.713 0.543 0.085 0.082   NA    NA  0.753
#> 1506 1.344 1.341  1.064  0.954 1.317 0.725 0.552 0.061 0.110   NA    NA  0.683
#> 1507 1.356 1.350  1.094  0.969 1.332 0.728 0.509 0.091 0.125   NA    NA  0.765
#> 1508 1.478 1.469  1.210  1.079 1.457 0.756 0.518 0.107 0.131   NA    NA  0.869
#> 1509 1.463 1.451  1.161  1.061 1.451 0.777 0.582 0.094 0.101   NA    NA  0.939
#> 1510 1.490 1.484  1.228  1.128 1.487 0.716 0.509 0.107 0.101   NA    NA  0.954
#> 1511 1.524 1.518  1.271  1.195 1.512 0.634 0.497 0.061 0.076   NA    NA  0.945
#> 1512 1.426 1.420  1.183  1.064 1.390 0.652 0.475 0.058 0.119   NA    NA  0.668
#> 1513 1.390 1.393  1.140  0.991 1.353 0.725 0.506 0.070 0.149   NA    NA  0.539
#> 1514 1.241 1.244  0.978  0.844 1.216 0.741 0.530 0.076 0.134   NA    NA  0.332
#> 1515 1.237 1.219  0.942  0.847 1.222 0.747 0.552 0.104 0.094   NA    NA  0.561
#> 1516 1.271 1.253  0.985  0.908 1.268 0.719 0.539 0.107 0.073   NA    NA  0.677
#> 1517 1.393 1.387  1.113  1.015 1.375 0.725 0.549 0.076 0.098   NA    NA  0.640
#> 1518 1.359 1.341  1.070  0.981 1.338 0.713 0.546 0.079 0.088   NA    NA  0.805
#> 1519 1.460 1.457  1.201  1.070 1.433 0.725 0.506 0.088 0.131   NA    NA  0.893
#> 1520 1.411 1.408  1.173  1.024 1.390 0.735 0.466 0.119 0.152   NA    NA  0.841
#> 1521 1.442 1.439  1.183  1.070 1.430 0.722 0.512 0.094 0.116   NA    NA  0.902
#> 1522 1.484 1.481  1.210  1.116 1.472 0.710 0.536 0.076 0.094   NA    NA  0.920
#> 1523 1.451 1.445  1.207  1.097 1.433 0.671 0.479 0.085 0.110   NA    NA  0.942
#> 1524 1.457 1.457  1.234  1.113 1.430 0.637 0.445 0.070 0.122   NA    NA  0.942
#> 1525 1.442 1.442  1.210  1.052 1.405 0.710 0.460 0.091 0.158   NA    NA  0.552
#> 1526 1.335 1.320  1.061  0.933 1.311 0.753 0.518 0.107 0.128   NA    NA  0.604
#> 1527 1.375 1.353  1.079  0.991 1.362 0.741 0.546 0.107 0.088   NA    NA  0.808
#> 1528 1.274 1.265  1.012  0.924 1.265 0.686 0.506 0.088 0.088   NA    NA  0.661
#> 1529 1.353 1.359  1.100  0.994 1.335 0.683 0.515 0.061 0.107   NA    NA  0.671
#> 1530 1.402 1.393  1.152  1.042 1.378 0.671 0.482 0.079 0.110   NA    NA  0.771
#> 1531 1.475 1.475  1.216  1.085 1.457 0.744 0.515 0.098 0.131   NA    NA  0.960
#> 1532 1.426 1.414  1.161  1.039 1.411 0.744 0.509 0.116 0.119   NA    NA  0.884
#> 1533 1.466 1.466  1.216  1.103 1.460 0.713 0.500 0.098 0.113   NA    NA  0.930
#> 1534 1.463 1.460  1.198  1.097 1.454 0.710 0.524 0.085 0.101   NA    NA  0.887
#> 1535 1.503 1.494  1.241  1.137 1.481 0.689 0.506 0.079 0.104   NA    NA  0.957
#> 1536 1.469 1.457  1.219  1.106 1.439 0.664 0.475 0.076 0.113   NA    NA  0.890
#> 1537 1.390 1.399  1.177  1.021 1.359 0.677 0.442 0.079 0.155   NA    NA  0.482
#> 1538 1.280 1.283  1.015  0.896 1.259 0.725 0.536 0.070 0.119   NA    NA  0.518
#> 1539 1.314 1.295  1.027  0.936 1.298 0.725 0.533 0.101 0.091   NA    NA  0.692
#> 1540 1.338 1.335  1.085  0.972 1.326 0.707 0.500 0.094 0.113   NA    NA  0.786
#> 1541 1.265 1.256  1.006  0.927 1.247 0.637 0.497 0.061 0.079   NA    NA  0.753
#> 1542 1.323 1.308  1.061  0.975 1.308 0.664 0.494 0.085 0.085   NA    NA  0.838
#> 1543 1.353 1.356  1.122  0.969 1.332 0.722 0.472 0.101 0.152   NA    NA  0.789
#> 1544 1.487 1.466  1.213  1.085 1.463 0.753 0.506 0.119 0.125   NA    NA  0.872
#> 1545 1.411 1.411  1.167  1.018 1.390 0.744 0.488 0.110 0.149   NA    NA  0.875
#> 1546 1.433 1.423  1.158  1.073 1.423 0.701 0.530 0.085 0.088   NA    NA  0.664
#> 1547 1.463 1.463  1.234  1.113 1.439 0.655 0.460 0.073 0.122   NA    NA  1.027
#> 1548 1.524 1.512  1.286  1.167 1.500 0.671 0.451 0.098 0.119   NA    NA  0.972
#> 1549 1.387 1.384  1.180  1.015 1.353 0.677 0.415 0.098 0.165   NA    NA  0.686
#> 1550 1.335 1.332  1.109  0.972 1.317 0.686 0.442 0.104 0.137   NA    NA  0.802
#> 1551 1.341 1.332  1.073  0.991 1.338 0.695 0.518 0.091 0.082   NA    NA  0.832
#> 1552 1.350 1.347  1.106  1.006 1.341 0.677 0.482 0.091 0.104   NA    NA  0.719
#> 1553 1.286 1.253  0.981  0.911 1.271 0.716 0.543 0.104 0.070   NA    NA  0.552
#> 1554 1.329 1.326  1.079  0.957 1.311 0.707 0.494 0.091 0.122   NA    NA  0.689
#> 1555 1.387 1.384  1.143  1.018 1.372 0.707 0.479 0.101 0.125   NA    NA  0.808
#> 1556 1.381 1.381  1.158  1.003 1.369 0.735 0.445 0.134 0.158   NA    NA  0.844
#> 1557 1.384 1.378  1.137  1.009 1.369 0.716 0.485 0.107 0.128   NA    NA  0.856
#> 1558 1.423 1.417  1.170  1.067 1.417 0.701 0.494 0.104 0.104   NA    NA  0.981
#> 1559 1.463 1.460  1.213  1.125 1.448 0.646 0.494 0.061 0.088   NA    NA  0.991
#> 1560 1.509 1.503  1.280  1.161 1.481 0.643 0.445 0.079 0.119   NA    NA  0.981
#> 1561 1.353 1.353  1.137  0.960 1.314 0.704 0.436 0.091 0.177   NA    NA  0.716
#> 1562 1.341 1.341  1.109  0.960 1.311 0.701 0.463 0.088 0.149   NA    NA  0.689
#> 1563 1.241 1.258  0.991  0.875 1.221 0.692 0.533 0.043 0.116   NA    NA  0.482
#> 1564 1.287 1.278  1.036  0.943 1.280 0.674 0.484 0.097 0.093   NA    NA  0.677
#> 1565 1.346 1.338  1.101  1.005 1.329 0.648 0.475 0.077 0.096   NA    NA  0.570
#> 1566 1.364 1.366  1.118  1.005 1.348 0.686 0.496 0.077 0.113   NA    NA  0.789
#> 1567 1.374 1.374  1.163  1.004 1.354 0.700 0.423 0.118 0.159   NA    NA  0.884
#> 1568 1.400 1.398  1.178  1.038 1.388 0.699 0.440 0.119 0.140   NA    NA  0.930
#> 1569 1.425 1.416  1.182  1.079 1.419 0.680 0.469 0.108 0.103   NA    NA  0.899
#> 1570 1.467 1.465  1.241  1.132 1.454 0.645 0.448 0.088 0.109   NA    NA  1.021
#> 1571 1.494 1.492  1.266  1.155 1.472 0.634 0.452 0.071 0.111   NA    NA  0.978
#> 1572 1.508 1.506  1.296  1.164 1.474 0.619 0.420 0.067 0.132   NA    NA  0.994
#> 1573 1.409 1.408  1.205  1.051 1.376 0.651 0.407 0.090 0.154 6.96  0.63  0.780
#> 1574 1.378 1.378  1.151  0.988 1.350 0.725 0.454 0.108 0.163   NA    NA  0.789
#> 1575 1.303 1.295  1.058  0.935 1.292 0.713 0.474 0.116 0.123   NA    NA  0.719
#> 1576 1.200 1.202  0.958  0.874 1.198 0.648 0.488 0.076 0.084   NA    NA  0.604
#> 1577 1.324 1.328  1.090  0.988 1.310 0.644 0.476 0.066 0.102   NA    NA  0.536
#> 1578 1.411 1.404  1.185  1.074 1.383 0.618 0.439 0.068 0.111   NA    NA  0.874
#> 1579 1.459 1.460  1.244  1.098 1.439 0.682 0.432 0.104 0.146   NA    NA  0.913
#> 1580 1.424 1.414  1.188  1.059 1.420 0.722 0.452 0.141 0.129   NA    NA  0.845
#> 1581 1.455 1.451  1.216  1.103 1.448 0.689 0.470 0.106 0.113   NA    NA  0.972
#> 1582 1.589 1.584  1.357  1.249 1.576 0.655 0.455 0.092 0.108   NA    NA  1.094
#> 1583 1.605 1.606  1.373  1.264 1.585 0.642 0.467 0.066 0.109   NA    NA  1.091
#> 1584 1.577 1.584  1.370  1.230 1.544 0.628 0.427 0.061 0.140   NA    NA  0.844
#> 1585 1.392 1.394  1.173  1.037 1.368 0.662 0.443 0.083 0.136   NA    NA  0.674
#> 1586 1.344 1.343  1.137  0.982 1.324 0.685 0.412 0.118 0.155   NA    NA  0.637
#> 1587 1.310 1.312  1.096  0.950 1.298 0.697 0.433 0.118 0.146   NA    NA  0.686
#> 1588 1.253 1.240  1.012  0.926 1.240 0.629 0.456 0.087 0.086   NA    NA  0.414
#> 1589 1.258 1.254  1.035  0.943 1.253 0.620 0.437 0.091 0.092   NA    NA  0.533
#> 1590 1.329 1.330  1.108  0.987 1.307 0.640 0.444 0.075 0.121   NA    NA  0.759
#> 1591 1.348 1.344  1.129  0.991 1.328 0.675 0.431 0.106 0.138   NA    NA  0.875
#> 1592 1.352 1.352  1.133  0.988 1.342 0.707 0.438 0.124 0.145   NA    NA  0.847
#> 1593 1.405 1.404  1.184  1.055 1.401 0.692 0.439 0.124 0.129   NA    NA  0.842
#> 1594 1.445 1.442  1.222  1.126 1.444 0.635 0.439 0.100 0.096 6.92  0.54  0.973
#> 1595 1.481 1.478  1.261  1.176 1.472 0.593 0.434 0.074 0.085   NA    NA  1.078
#> 1596 1.506 1.506  1.296  1.177 1.484 0.614 0.421 0.074 0.119   NA    NA  0.993
#> 1597 1.413 1.414  1.208  1.087 1.389 0.604 0.411 0.072 0.121   NA    NA  0.744
#> 1598 1.331 1.343  1.141  0.987 1.308 0.643 0.404 0.085 0.154   NA    NA  0.607
#> 1599 1.299 1.307  1.096  0.974 1.290 0.633 0.422 0.089 0.122   NA    NA  0.779
#> 1600 1.292 1.302  1.084  0.969 1.280 0.622 0.437 0.070 0.115   NA    NA  0.625
#> 1601 1.360 1.356  1.132  1.046 1.350 0.608 0.448 0.074 0.086   NA    NA  0.683
#> 1602 1.396 1.386  1.157  1.056 1.370 0.629 0.459 0.069 0.101   NA    NA  0.741
#> 1603 1.392 1.390  1.173  1.048 1.372 0.649 0.434 0.090 0.125   NA    NA  0.884
#> 1604 1.439 1.438  1.227  1.087 1.428 0.682 0.422 0.120 0.140   NA    NA  0.906
#> 1605 1.446 1.445  1.238  1.087 1.430 0.685 0.414 0.120 0.151 7.10  0.56  0.980
#> 1606 1.460 1.458  1.244  1.124 1.450 0.651 0.428 0.103 0.120 6.99  0.63  1.003
#> 1607 1.518 1.514  1.296  1.201 1.500 0.597 0.436 0.066 0.095   NA    NA  1.094
#> 1608 1.478 1.472  1.254  1.152 1.448 0.592 0.437 0.053 0.102   NA    NA  0.991
#> 1609 1.398 1.404  1.193  1.044 1.371 0.654 0.421 0.084 0.149   NA    NA  0.650
#> 1610 1.338 1.337  1.121  0.980 1.318 0.676 0.432 0.103 0.141   NA    NA  0.658
#> 1611 1.333 1.332  1.108  0.961 1.304 0.685 0.447 0.091 0.147   NA    NA  0.448
#> 1612 1.416 1.411  1.180  1.072 1.400 0.655 0.462 0.085 0.108   NA    NA  0.800
#> 1613 1.348 1.331  1.087  0.993 1.318 0.651 0.488 0.069 0.094   NA    NA  0.657
#> 1614 1.383 1.378  1.158  1.027 1.348 0.642 0.441 0.070 0.131   NA    NA  0.757
#> 1615 1.438 1.442  1.220  1.061 1.400 0.678 0.443 0.076 0.159   NA    NA  0.944
#> 1616 1.400 1.402  1.185  1.025 1.374 0.698 0.433 0.105 0.160 7.08  0.66  0.866
#> 1617 1.398 1.400  1.185  1.052 1.388 0.673 0.430 0.110 0.133   NA    NA  0.908
#> 1618 1.428 1.426  1.202  1.091 1.416 0.651 0.448 0.092 0.111   NA    NA  0.961
#> 1619 1.576 1.563  1.339  1.246 1.558 0.625 0.448 0.084 0.093   NA    NA  0.908
#> 1620 1.444 1.455  1.228  1.096 1.407 0.622 0.454 0.036 0.132   NA    NA  0.620
#> 1621 1.377 1.379  1.165  1.029 1.342 0.627 0.428 0.063 0.136   NA    NA  0.778
#> 1622 1.340 1.338  1.130  0.975 1.315 0.680 0.417 0.108 0.155   NA    NA  0.788
#> 1623 1.345 1.340  1.115  0.981 1.336 0.709 0.450 0.125 0.134   NA    NA  0.694
#> 1624 1.393 1.396  1.152  1.056 1.382 0.653 0.488 0.069 0.096   NA    NA  0.600
#> 1625 1.373 1.370  1.134  1.048 1.356 0.616 0.471 0.059 0.086   NA    NA  0.809
#> 1626 1.410 1.410  1.182  1.075 1.383 0.616 0.457 0.052 0.107   NA    NA  0.809
#> 1627 1.439 1.428  1.197  1.078 1.418 0.681 0.461 0.101 0.119   NA    NA  0.903
#> 1628 1.408 1.407  1.185  1.036 1.388 0.704 0.444 0.111 0.149   NA    NA  0.895
#> 1629 1.448 1.447  1.225  1.074 1.428 0.708 0.444 0.113 0.151   NA    NA  0.967
#> 1630 1.503 1.498  1.277  1.168 1.497 0.658 0.442 0.107 0.109   NA    NA  1.005
#> 1631 1.583 1.576  1.354  1.257 1.572 0.630 0.445 0.088 0.097   NA    NA  1.106
#> 1632 1.476 1.474  1.254  1.132 1.441 0.618 0.441 0.055 0.122   NA    NA  0.889
#> 1633 1.400 1.398  1.187  1.042 1.361 0.638 0.423 0.070 0.145   NA    NA  0.897
#> 1634 1.331 1.328  1.115  0.983 1.308 0.650 0.427 0.091 0.132   NA    NA  0.596
#> 1635 1.279 1.270  1.037  0.926 1.265 0.678 0.466 0.101 0.111   NA    NA  0.584
#> 1636 1.271 1.254  1.023  0.932 1.254 0.644 0.463 0.090 0.091   NA    NA  0.737
#> 1637 1.378 1.367  1.134  1.049 1.362 0.626 0.466 0.075 0.085   NA    NA  0.798
#> 1638 1.398 1.390  1.160  1.068 1.376 0.615 0.460 0.063 0.092   NA    NA  0.825
#> 1639 1.410 1.398  1.166  1.063 1.392 0.658 0.463 0.092 0.103   NA    NA  0.882
#> 1640 1.439 1.438  1.219  1.071 1.423 0.704 0.439 0.117 0.148   NA    NA  0.896
#> 1641 1.493 1.489  1.264  1.110 1.474 0.727 0.450 0.123 0.154   NA    NA  0.887
#> 1642 1.474 1.468  1.234  1.135 1.470 0.671 0.468 0.104 0.099   NA    NA  1.042
#> 1643 1.519 1.506  1.277  1.203 1.508 0.611 0.459 0.078 0.074   NA    NA  1.044
#> 1644 1.453 1.442  1.228  1.119 1.418 0.597 0.427 0.061 0.109   NA    NA  0.838
#> 1645 1.450 1.454  1.224  1.101 1.423 0.644 0.460 0.061 0.123   NA    NA  0.755
#> 1646 1.289 1.288  1.040  0.920 1.266 0.693 0.497 0.076 0.120   NA    NA  0.555
#> 1647 1.187 1.188  0.979  0.851 1.170 0.638 0.418 0.092 0.128   NA    NA  0.484
#> 1648 1.211 1.210  0.976  0.873 1.200 0.653 0.468 0.082 0.103   NA    NA  0.641
#> 1649 1.318 1.315  1.081  0.988 1.310 0.644 0.468 0.083 0.093   NA    NA  0.676
#> 1650 1.312 1.314  1.064  0.949 1.284 0.670 0.501 0.054 0.115   NA    NA  0.628
#> 1651 1.375 1.368  1.124  1.008 1.348 0.680 0.488 0.076 0.116   NA    NA  0.740
#> 1652 1.350 1.344  1.126  0.985 1.331 0.692 0.436 0.115 0.141   NA    NA  0.796
#> 1653 1.442 1.430  1.208  1.074 1.427 0.706 0.444 0.128 0.134   NA    NA  0.895
#> 1654 1.458 1.456  1.221  1.102 1.442 0.680 0.469 0.092 0.119   NA    NA  0.961
#> 1655 1.491 1.482  1.245  1.156 1.472 0.631 0.474 0.068 0.089   NA    NA  0.952
#> 1656 1.443 1.442  1.214  1.112 1.418 0.613 0.457 0.054 0.102   NA    NA  0.875
#> 1657 1.444 1.440  1.205  1.071 1.402 0.662 0.471 0.057 0.134   NA    NA  0.783
#> 1658 1.386 1.380  1.144  0.993 1.352 0.717 0.472 0.094 0.151   NA    NA  0.780
#> 1659 1.266 1.254  0.998  0.881 1.240 0.719 0.513 0.089 0.117   NA    NA  0.633
#> 1660 1.270 1.246  1.002  0.922 1.252 0.661 0.487 0.094 0.080   NA    NA  0.677
#> 1661 1.287 1.292  1.045  0.950 1.271 0.642 0.495 0.052 0.095   NA    NA  0.530
#> 1662 1.378 1.380  1.136  1.013 1.344 0.661 0.487 0.051 0.123   NA    NA  0.812
#> 1663 1.400 1.387  1.133  1.009 1.378 0.738 0.508 0.106 0.124   NA    NA  0.772
#> 1664 1.465 1.452  1.207  1.088 1.436 0.695 0.491 0.085 0.119   NA    NA  0.943
#> 1665 1.439 1.426  1.185  1.073 1.420 0.695 0.481 0.102 0.112   NA    NA  0.929
#> 1666 1.492 1.488  1.257  1.145 1.478 0.666 0.461 0.093 0.112   NA    NA  0.956
#> 1667 1.590 1.588  1.357  1.239 1.561 0.644 0.463 0.063 0.118   NA    NA  1.081
#> 1668 1.559 1.548  1.303  1.193 1.519 0.652 0.491 0.051 0.110   NA    NA  1.073
#> 1669 1.392 1.382  1.134  1.022 1.354 0.665 0.496 0.057 0.112   NA    NA  0.700
#> 1670 1.315 1.307  1.067  0.918 1.279 0.722 0.480 0.093 0.149   NA    NA  0.678
#> 1671 1.262 1.251  0.976  0.854 1.237 0.766 0.550 0.094 0.122   NA    NA  0.609
#> 1672 1.286 1.277  1.033  0.921 1.260 0.678 0.488 0.078 0.112   NA    NA  0.677
#> 1673 1.399 1.394  1.145  1.024 1.371 0.694 0.499 0.074 0.121   NA    NA  0.606
#> 1674 1.423 1.405  1.143  1.050 1.398 0.696 0.524 0.079 0.093   NA    NA  0.773
#> 1675 1.438 1.426  1.154  1.036 1.403 0.734 0.543 0.073 0.118   NA    NA  0.869
#> 1676 1.463 1.448  1.167  1.052 1.438 0.771 0.563 0.093 0.115   NA    NA  0.867
#> 1677 1.499 1.493  1.236  1.090 1.477 0.774 0.514 0.114 0.146   NA    NA  0.925
#> 1678 1.511 1.494  1.229  1.133 1.494 0.723 0.529 0.098 0.096   NA    NA  1.009
#> 1679 1.569 1.552  1.288  1.193 1.546 0.706 0.529 0.082 0.095   NA    NA  1.080
#> 1680 1.536 1.541  1.297  1.155 1.498 0.685 0.488 0.055 0.142   NA    NA  0.961
#> 1681 1.477 1.476  1.227  1.092 1.440 0.697 0.498 0.064 0.135   NA    NA  0.653
#> 1682 1.357 1.360  1.122  0.992 1.330 0.675 0.475 0.070 0.130   NA    NA  0.696
#> 1683 1.346 1.320  1.058  0.960 1.312 0.703 0.524 0.081 0.098   NA    NA  0.617
#> 1684 1.311 1.312  1.051  0.937 1.295 0.716 0.522 0.080 0.114   NA    NA  0.576
#> 1685 1.342 1.328  1.068  0.972 1.322 0.700 0.519 0.085 0.096   NA    NA  0.829
#> 1686 1.365 1.354  1.097  0.995 1.342 0.693 0.515 0.076 0.102   NA    NA  0.770
#> 1687 1.418 1.407  1.144  1.036 1.392 0.712 0.526 0.078 0.108   NA    NA  0.819
#> 1688 1.473 1.468  1.203  1.073 1.452 0.757 0.531 0.096 0.130   NA    NA  0.896
#> 1689 1.461 1.444  1.148  1.051 1.439 0.776 0.591 0.088 0.097   NA    NA  0.881
#> 1690 1.475 1.462  1.196  1.081 1.458 0.753 0.533 0.105 0.115   NA    NA  0.906
#> 1691 1.523 1.516  1.266  1.139 1.502 0.727 0.499 0.101 0.127   NA    NA  0.796
#> 1692 1.522 1.523  1.277  1.147 1.490 0.687 0.492 0.065 0.130   NA    NA  0.992
#> 1693 1.493 1.491  1.220  1.092 1.453 0.722 0.542 0.052 0.128   NA    NA  0.796
#> 1694 1.289 1.284  1.039  0.902 1.256 0.709 0.490 0.082 0.137   NA    NA  0.376
#> 1695 1.340 1.334  1.071  0.964 1.320 0.711 0.527 0.077 0.107   NA    NA  0.684
#> 1696 1.421 1.422  1.154  1.041 1.404 0.725 0.535 0.077 0.113   NA    NA  0.789
#> 1697 1.345 1.344  1.086  0.994 1.328 0.668 0.517 0.059 0.092   NA    NA  0.770
#> 1698 1.409 1.420  1.149  1.015 1.382 0.734 0.541 0.059 0.134   NA    NA  0.717
#> 1699 1.454 1.443  1.174  1.053 1.424 0.743 0.538 0.084 0.121   NA    NA  0.923
#> 1700 1.496 1.492  1.234  1.093 1.460 0.735 0.517 0.077 0.141   NA    NA  0.880
#> 1701 1.511 1.493  1.219  1.105 1.486 0.763 0.548 0.101 0.114   NA    NA  0.977
#> 1702 1.507 1.495  1.227  1.120 1.488 0.736 0.536 0.093 0.107   NA    NA  0.860
#> 1703 1.549 1.534  1.284  1.184 1.524 0.679 0.499 0.080 0.100   NA    NA  0.994
#> 1704 1.482 1.462  1.229  1.134 1.456 0.645 0.467 0.083 0.095   NA    NA  0.646
#> 1705 1.421 1.429  1.178  1.038 1.387 0.698 0.502 0.056 0.140   NA    NA  0.745
#> 1706 1.328 1.304  1.030  0.932 1.301 0.738 0.547 0.093 0.098   NA    NA  0.788
#> 1707 1.306 1.306  1.024  0.916 1.292 0.752 0.563 0.081 0.108   NA    NA  0.520
#> 1708 1.303 1.296  1.052  0.962 1.292 0.660 0.488 0.082 0.090   NA    NA  0.649
#> 1709 1.361 1.357  1.090  1.013 1.351 0.676 0.534 0.065 0.077   NA    NA  0.699
#> 1710 1.382 1.370  1.117  1.024 1.360 0.672 0.506 0.073 0.093   NA    NA     NA
#> 1711 1.450 1.452  1.194  1.075 1.424 0.699 0.515 0.065 0.119   NA    NA  0.915
#> 1712 1.445 1.436  1.192  1.072 1.428 0.713 0.487 0.106 0.120   NA    NA  0.907
#> 1713 1.418 1.404  1.156  1.061 1.410 0.698 0.497 0.106 0.095   NA    NA  0.903
#> 1714 1.482 1.476  1.220  1.131 1.476 0.690 0.511 0.090 0.089   NA    NA  0.953
#> 1715 1.560 1.556  1.292  1.192 1.541 0.698 0.527 0.071 0.100   NA    NA  1.044
#> 1716 1.511 1.510  1.243  1.138 1.484 0.693 0.534 0.054 0.105   NA    NA  0.658
#> 1717 1.410 1.408  1.176  1.041 1.370 0.659 0.463 0.061 0.135   NA    NA  0.733
#> 1718 1.345 1.327  1.064  0.951 1.316 0.729 0.526 0.090 0.113   NA    NA  0.613
#> 1719 1.324 1.314  1.026  0.943 1.310 0.733 0.575 0.075 0.083   NA    NA  0.731
#> 1720 1.290 1.252  0.998  0.949 1.282 0.666 0.508 0.109 0.049   NA    NA  0.713
#> 1721 1.315 1.300  1.051  0.964 1.299 0.670 0.498 0.085 0.087   NA    NA  0.762
#> 1722 1.353 1.349  1.108  0.995 1.324 0.657 0.482 0.062 0.113   NA    NA  0.771
#> 1723 1.477 1.479  1.221  1.091 1.458 0.735 0.516 0.089 0.130   NA    NA  0.850
#> 1724 1.495 1.490  1.207  1.104 1.480 0.752 0.567 0.082 0.103   NA    NA  0.956
#> 1725 1.486 1.476  1.212  1.107 1.474 0.733 0.527 0.101 0.105   NA    NA  0.944
#> 1726 1.521 1.514  1.260  1.176 1.512 0.673 0.508 0.081 0.084   NA    NA  1.023
#> 1727 1.520 1.519  1.276  1.187 1.513 0.652 0.486 0.077 0.089   NA    NA  0.900
#> 1728 1.536 1.533  1.284  1.173 1.509 0.672 0.498 0.063 0.111   NA    NA  0.837
#> 1729 1.426 1.422  1.174  1.054 1.394 0.680 0.497 0.063 0.120   NA    NA  0.782
#> 1730 1.382 1.360  1.104  1.007 1.360 0.705 0.513 0.095 0.097   NA    NA  0.807
#> 1731 1.283 1.290  1.010  0.906 1.272 0.733 0.560 0.069 0.104   NA    NA  0.308
#> 1732 1.300 1.302  1.038  0.938 1.286 0.696 0.528 0.068 0.100   NA    NA  0.710
#> 1733 1.298 1.291  1.028  0.937 1.281 0.688 0.526 0.071 0.091   NA    NA  0.714
#> 1734 1.396 1.382  1.119  1.023 1.367 0.688 0.526 0.066 0.096   NA    NA  0.849
#> 1735 1.459 1.446  1.189  1.082 1.434 0.703 0.514 0.082 0.107   NA    NA  0.865
#> 1736 1.440 1.433  1.168  1.042 1.416 0.749 0.530 0.093 0.126   NA    NA  0.865
#> 1737 1.512 1.497  1.224  1.122 1.493 0.742 0.546 0.094 0.102   NA    NA  0.842
#> 1738 1.530 1.516  1.263  1.169 1.520 0.701 0.506 0.101 0.094   NA    NA  1.007
#> 1739 1.626 1.622  1.385  1.306 1.616 0.619 0.473 0.067 0.079   NA    NA  1.072
#> 1740 1.513 1.515  1.287  1.161 1.488 0.654 0.456 0.072 0.126   NA    NA  0.823
#> 1741 1.433 1.426  1.168  1.072 1.405 0.666 0.517 0.053 0.096   NA    NA  0.703
#> 1742 1.335 1.323  1.077  0.951 1.312 0.722 0.492 0.104 0.126   NA    NA  0.518
#> 1743 1.245 1.232  0.983  0.901 1.232 0.663 0.498 0.083 0.082   NA    NA  0.602
#> 1744 1.250 1.250  1.004  0.909 1.244 0.669 0.491 0.083 0.095   NA    NA  0.505
#> 1745 1.381 1.392  1.128  1.023 1.368 0.689 0.528 0.056 0.105   NA    NA  0.695
#> 1746 1.394 1.388  1.131  1.030 1.375 0.690 0.514 0.075 0.101   NA    NA  0.826
#> 1747 1.433 1.418  1.154  1.053 1.406 0.705 0.529 0.075 0.101   NA    NA  0.893
#> 1748 1.518 1.509  1.255  1.149 1.501 0.704 0.508 0.090 0.106   NA    NA  0.985
#> 1749 1.529 1.510  1.236  1.153 1.516 0.727 0.547 0.097 0.083   NA    NA  0.936
#> 1750 1.533 1.524  1.274  1.175 1.523 0.696 0.499 0.098 0.099   NA    NA  1.042
#> 1751 1.637 1.622  1.371  1.280 1.610 0.661 0.501 0.069 0.091   NA    NA  1.147
#> 1752 1.567 1.562  1.326  1.222 1.535 0.626 0.473 0.049 0.104   NA    NA  0.900
#> 1753 1.521 1.528  1.302  1.147 1.478 0.662 0.452 0.055 0.155   NA    NA  0.813
#> 1754 1.338 1.342  1.088  0.972 1.328 0.712 0.507 0.089 0.116   NA    NA  0.575
#> 1755 1.338 1.324  1.059  0.993 1.331 0.676 0.529 0.081 0.066   NA    NA  0.719
#> 1756 1.363 1.353  1.099  1.019 1.348 0.657 0.508 0.069 0.080   NA    NA  0.829
#> 1757 1.372 1.364  1.107  1.002 1.348 0.691 0.513 0.073 0.105   NA    NA  0.852
#> 1758 1.442 1.428  1.182  1.065 1.422 0.714 0.492 0.105 0.117   NA    NA  0.941
#> 1759 1.496 1.502  1.255  1.114 1.480 0.732 0.493 0.098 0.141   NA    NA  0.969
#> 1760 1.506 1.501  1.263  1.144 1.492 0.696 0.476 0.101 0.119   NA    NA  0.853
#> 1761 1.558 1.552  1.309  1.211 1.540 0.659 0.486 0.075 0.098   NA    NA  1.089
#> 1762 1.605 1.604  1.368  1.251 1.586 0.671 0.471 0.083 0.117   NA    NA  1.134
#> 1763 1.496 1.493  1.262  1.128 1.458 0.660 0.462 0.064 0.134   NA    NA  0.948
#> 1764 1.452 1.462  1.249  1.089 1.416 0.654 0.426 0.068 0.160   NA    NA  0.666
#> 1765 1.295 1.284  1.029  0.923 1.273 0.700 0.511 0.083 0.106   NA    NA  0.669
#> 1766 1.285 1.290  1.014  0.911 1.273 0.724 0.553 0.068 0.103   NA    NA  0.665
#> 1767 1.276 1.274  1.007  0.928 1.272 0.687 0.535 0.073 0.079   NA    NA  0.625
#> 1768 1.370 1.366  1.122  1.030 1.355 0.650 0.487 0.071 0.092   NA    NA  0.848
#> 1769 1.400 1.396  1.163  1.049 1.377 0.656 0.465 0.077 0.114   NA    NA  0.863
#> 1770 1.428 1.427  1.198  1.057 1.410 0.707 0.458 0.108 0.141   NA    NA  0.821
#> 1771 1.469 1.463  1.210  1.076 1.452 0.753 0.506 0.113 0.134   NA    NA  0.867
#> 1772 1.532 1.526  1.282  1.154 1.520 0.733 0.488 0.117 0.128   NA    NA  0.993
#> 1773 1.548 1.540  1.288  1.201 1.544 0.687 0.504 0.096 0.087   NA    NA  1.065
#> 1774 1.544 1.528  1.287  1.205 1.528 0.646 0.482 0.082 0.082   NA    NA  1.089
#> 1775 1.470 1.462  1.230  1.115 1.448 0.666 0.465 0.086 0.115   NA    NA  0.804
#> 1776 1.465 1.467  1.251  1.100 1.438 0.675 0.432 0.092 0.151   NA    NA  0.813
#> 1777 1.399 1.388  1.159  1.034 1.372 0.676 0.458 0.093 0.125   NA    NA  0.710
#> 1778 1.332 1.338  1.094  0.995 1.324 0.659 0.489 0.071 0.099   NA    NA  0.758
#> 1779 1.381 1.365  1.121  1.036 1.368 0.665 0.488 0.092 0.085   NA    NA  0.804
#> 1780 1.430 1.418  1.170  1.086 1.416 0.659 0.497 0.078 0.084   NA    NA  0.766
#> 1781 1.479 1.481  1.236  1.126 1.464 0.675 0.490 0.075 0.110   NA    NA  0.952
#> 1782 1.516 1.512  1.290  1.145 1.492 0.693 0.443 0.105 0.145   NA    NA  1.003
#> 1783 1.635 1.621  1.400  1.262 1.613 0.702 0.442 0.122 0.138   NA    NA  0.936
#> 1784 1.557 1.556  1.315  1.186 1.549 0.726 0.483 0.114 0.129   NA    NA  1.028
#> 1785 1.602 1.598  1.371  1.273 1.602 0.658 0.453 0.107 0.098   NA    NA  0.820
#> 1786 1.557 1.550  1.315  1.226 1.544 0.637 0.469 0.079 0.089   NA    NA  1.039
#> 1787 1.538 1.532  1.302  1.188 1.510 0.645 0.460 0.071 0.114   NA    NA  1.061
#> 1788 1.539 1.542  1.329  1.159 1.506 0.695 0.427 0.098 0.170   NA    NA  0.974
#> 1789 1.466 1.472  1.241  1.101 1.443 0.684 0.462 0.082 0.140   NA    NA  0.681
#> 1790 1.399 1.409  1.166  1.053 1.394 0.682 0.486 0.083 0.113   NA    NA  0.873
#> 1791 1.393 1.389  1.145  1.064 1.387 0.646 0.488 0.077 0.081   NA    NA  0.806
#> 1792 1.372 1.370  1.139  1.053 1.370 0.633 0.463 0.084 0.086   NA    NA  0.827
#> 1793 1.406 1.395  1.161  1.058 1.390 0.663 0.468 0.092 0.103   NA    NA  0.885
#> 1794 1.427 1.425  1.198  1.055 1.400 0.689 0.454 0.092 0.143   NA    NA  0.866
#> 1795 1.483 1.478  1.257  1.119 1.469 0.700 0.443 0.119 0.138   NA    NA  0.944
#> 1796 1.549 1.546  1.332  1.202 1.538 0.673 0.428 0.115 0.130   NA    NA  1.054
#> 1797 1.543 1.540  1.309  1.193 1.528 0.671 0.462 0.093 0.116   NA    NA  1.070
#> 1798 1.584 1.584  1.355  1.239 1.560 0.642 0.458 0.068 0.116   NA    NA  1.083
#> 1799 1.578 1.581  1.359  1.240 1.546 0.612 0.444 0.049 0.119   NA    NA  0.979
#> 1800 1.487 1.490  1.285  1.118 1.444 0.652 0.409 0.076 0.167   NA    NA  0.839
#> 1801 1.442 1.444  1.221  1.054 1.411 0.714 0.446 0.101 0.167   NA    NA  0.799
#> 1802 1.347 1.334  1.098  0.981 1.340 0.717 0.472 0.128 0.117   NA    NA  0.695
#> 1803 1.416 1.416  1.185  1.079 1.403 0.648 0.461 0.081 0.106   NA    NA  0.917
#> 1804 1.411 1.413  1.173  1.074 1.392 0.635 0.480 0.056 0.099   NA    NA  0.794
#> 1805 1.467 1.464  1.234  1.114 1.445 0.662 0.461 0.081 0.120   NA    NA  0.890
#> 1806 1.490 1.492  1.271  1.109 1.462 0.705 0.441 0.102 0.162   NA    NA  0.741
#> 1807 1.506 1.506  1.296  1.135 1.484 0.697 0.421 0.115 0.161 6.92  0.53  1.001
#> 1808 1.495 1.494  1.268  1.129 1.476 0.695 0.452 0.104 0.139   NA    NA  0.975
#> 1809 1.543 1.542  1.312  1.212 1.541 0.658 0.459 0.099 0.100   NA    NA  1.069
#> 1810 1.585 1.584  1.354  1.245 1.566 0.642 0.459 0.074 0.109   NA    NA  1.138
#> 1811 1.569 1.568  1.342  1.212 1.536 0.649 0.451 0.068 0.130   NA    NA  1.044
#> 1812 1.483 1.492  1.283  1.124 1.450 0.652 0.418 0.075 0.159   NA    NA  0.855
#> 1813 1.520 1.521  1.309  1.145 1.493 0.696 0.424 0.108 0.164 7.00  0.52  0.970
#> 1814 1.396 1.400  1.163  1.022 1.376 0.709 0.475 0.093 0.141   NA    NA  0.594
#> 1815 1.390 1.386  1.152  1.051 1.382 0.661 0.468 0.092 0.101   NA    NA  0.802
#> 1816 1.374 1.370  1.140  1.032 1.353 0.642 0.459 0.075 0.108   NA    NA  0.843
#> 1817 1.458 1.452  1.220  1.109 1.430 0.643 0.463 0.069 0.111   NA    NA  0.991
#> 1818 1.463 1.466  1.243  1.098 1.446 0.696 0.446 0.105 0.145   NA    NA  0.963
#> 1819 1.479 1.480  1.263  1.104 1.462 0.715 0.434 0.122 0.159   NA    NA  0.985
#> 1820 1.531 1.529  1.306  1.157 1.517 0.720 0.446 0.125 0.149 7.03  0.44  0.975
#> 1821 1.592 1.588  1.347  1.238 1.586 0.695 0.482 0.104 0.109   NA    NA  1.135
#> 1822 1.600 1.598  1.362  1.259 1.584 0.651 0.472 0.076 0.103 6.88  0.53  1.139
#> 1823 1.683 1.684  1.461  1.333 1.650 0.633 0.446 0.059 0.128 6.87  0.43  1.067
#> 1824 1.569 1.572  1.359  1.202 1.531 0.658 0.427 0.074 0.157   NA    NA  0.871
#> 1825 1.540 1.545  1.342  1.175 1.510 0.670 0.406 0.097 0.167   NA    NA  0.963
#> 1826 1.489 1.497  1.264  1.141 1.480 0.677 0.466 0.088 0.123   NA    NA  0.818
#> 1827 1.423 1.412  1.178  1.081 1.412 0.661 0.469 0.095 0.097   NA    NA  0.760
#> 1828 1.425 1.421  1.179  1.080 1.408 0.655 0.484 0.072 0.099   NA    NA  0.842
#> 1829 1.497 1.502  1.269  1.141 1.469 0.656 0.465 0.063 0.128   NA    NA  0.904
#> 1830 1.536 1.536  1.315  1.185 1.515 0.660 0.441 0.089 0.130   NA    NA  0.989
#> 1831 1.535 1.536  1.317  1.170 1.515 0.690 0.439 0.104 0.147   NA    NA  0.921
#> 1832 1.516 1.514  1.296  1.147 1.498 0.703 0.436 0.118 0.149 7.04  0.49  0.963
#> 1833 1.573 1.574  1.352  1.228 1.563 0.671 0.444 0.103 0.124 7.01  0.57  1.069
#> 1834 1.630 1.632  1.405  1.298 1.611 0.626 0.453 0.066 0.107   NA    NA  1.141
#> 1835 1.547 1.544  1.314  1.210 1.512 0.603 0.459 0.040 0.104   NA    NA  1.090
#> 1836 1.558 1.564  1.348  1.198 1.524 0.651 0.431 0.070 0.150   NA    NA  0.972
#> 1837 1.432 1.432  1.216  1.060 1.400 0.680 0.432 0.092 0.156   NA    NA  0.715
#> 1838 1.444 1.448  1.216  1.084 1.428 0.689 0.463 0.094 0.132   NA    NA  0.563
#> 1839 1.366 1.358  1.126  1.035 1.351 0.632 0.465 0.076 0.091   NA    NA  0.671
#> 1840 1.352 1.347  1.125  1.032 1.336 0.607 0.444 0.070 0.093   NA    NA  0.825
#> 1841 1.484 1.474  1.237  1.151 1.464 0.625 0.475 0.064 0.086   NA    NA  0.967
#> 1842 1.483 1.478  1.255  1.131 1.454 0.647 0.446 0.077 0.124   NA    NA  0.902
#> 1843 1.542 1.542  1.341  1.194 1.531 0.674 0.403 0.124 0.147 6.96  0.47  1.061
#> 1844 1.521 1.516  1.306  1.179 1.516 0.673 0.421 0.125 0.127   NA    NA  1.056
#> 1845 1.574 1.572  1.360  1.247 1.570 0.645 0.425 0.107 0.113   NA    NA  1.071
#> 1846 1.574 1.590  1.348  1.223 1.560 0.675 0.484 0.066 0.125   NA    NA -0.052
#> 1847 1.609 1.615  1.403  1.265 1.579 0.628 0.424 0.066 0.138   NA    NA  1.056
#> 1848 1.499 1.500  1.281  1.135 1.460 0.651 0.439 0.066 0.146   NA    NA  0.949
#> 1849 1.451 1.453  1.236  1.066 1.424 0.717 0.434 0.113 0.170   NA    NA  0.877
#> 1850 1.285 1.302  1.064  0.913 1.262 0.699 0.475 0.073 0.151   NA    NA  0.441
#> 1851 1.390 1.386  1.160  1.042 1.372 0.661 0.452 0.091 0.118   NA    NA  0.844
#> 1852 1.483 1.480  1.242  1.161 1.472 0.623 0.475 0.067 0.081   NA    NA  0.921
#> 1853 1.450 1.438  1.198  1.114 1.428 0.628 0.479 0.065 0.084   NA    NA  0.930
#> 1854 1.494 1.502  1.268  1.127 1.474 0.695 0.468 0.086 0.141   NA    NA  0.921
#> 1855 1.464 1.464  1.244  1.084 1.442 0.716 0.440 0.116 0.160   NA    NA  0.959
#> 1856 1.546 1.543  1.319  1.177 1.532 0.711 0.448 0.121 0.142   NA    NA  0.980
#> 1857 1.577 1.576  1.344  1.221 1.560 0.679 0.464 0.092 0.123   NA    NA  1.068
#> 1858 1.610 1.607  1.366  1.252 1.586 0.667 0.482 0.071 0.114   NA    NA  1.078
#> 1859 1.604 1.612  1.380  1.254 1.573 0.638 0.465 0.047 0.126   NA    NA  0.874
#> 1860 1.501 1.499  1.266  1.137 1.476 0.677 0.466 0.082 0.129   NA    NA  0.902
#> 1861 1.500 1.509  1.292  1.146 1.477 0.662 0.434 0.082 0.146   NA    NA  0.807
#> 1862 1.388 1.379  1.136  1.009 1.356 0.695 0.486 0.082 0.127   NA    NA  0.769
#> 1863 1.437 1.422  1.170  1.066 1.416 0.700 0.504 0.092 0.104   NA    NA  0.863
#> 1864 1.466 1.464  1.232  1.104 1.430 0.653 0.465 0.060 0.128   NA    NA  0.777
#> 1865 1.512 1.506  1.266  1.166 1.488 0.645 0.479 0.066 0.100   NA    NA  0.936
#> 1866 1.547 1.544  1.297  1.180 1.522 0.684 0.494 0.073 0.117   NA    NA  0.987
#> 1867 1.581 1.580  1.360  1.193 1.551 0.716 0.440 0.109 0.167   NA    NA  1.050
#> 1868 1.591 1.590  1.363  1.199 1.572 0.745 0.453 0.128 0.164   NA    NA  1.053
#> 1869 1.596 1.596  1.359  1.212 1.580 0.736 0.475 0.114 0.147   NA    NA  1.063
#> 1870 1.592 1.587  1.353  1.234 1.565 0.662 0.468 0.075 0.119   NA    NA  1.118
#> 1871 1.751 1.750  1.525  1.396 1.719 0.646 0.449 0.068 0.129   NA    NA  1.121
#> 1872 1.626 1.626  1.388  1.246 1.594 0.695 0.477 0.076 0.142   NA    NA  0.955
#> 1873 1.499 1.484  1.247  1.119 1.474 0.709 0.474 0.107 0.128   NA    NA  0.832
#> 1874 1.447 1.454  1.215  1.077 1.428 0.701 0.477 0.086 0.138   NA    NA  0.648
#> 1875 1.408 1.394  1.150  1.061 1.394 0.666 0.489 0.088 0.089   NA    NA  0.676
#> 1876 1.430 1.420  1.175  1.076 1.406 0.659 0.490 0.070 0.099   NA    NA  0.634
#> 1877 1.546 1.534  1.287  1.186 1.514 0.656 0.495 0.060 0.101   NA    NA  0.943
#> 1878 1.490 1.490  1.251  1.108 1.455 0.694 0.478 0.073 0.143   NA    NA  0.894
#> 1879 1.581 1.574  1.342  1.205 1.561 0.712 0.465 0.110 0.137   NA    NA  1.075
#> 1880 1.562 1.558  1.322  1.182 1.538 0.713 0.471 0.102 0.140   NA    NA  1.070
#> 1881 1.607 1.606  1.370  1.246 1.592 0.691 0.472 0.095 0.124   NA    NA  1.064
#> 1882 1.662 1.653  1.424  1.326 1.643 0.634 0.458 0.078 0.098   NA    NA  1.122
#> 1883 1.683 1.660  1.424  1.327 1.640 0.625 0.472 0.056 0.097   NA    NA  1.106
#> 1884 1.571 1.572  1.308  1.186 1.535 0.698 0.527 0.049 0.122   NA    NA  0.832
#> 1885 1.432 1.432  1.155  1.037 1.404 0.735 0.555 0.062 0.118   NA    NA  0.789
#> 1886 1.415 1.412  1.176  1.028 1.394 0.732 0.472 0.112 0.148   NA    NA  0.774
#> 1887 1.450 1.451  1.211  1.083 1.430 0.695 0.480 0.087 0.128   NA    NA  0.737
#> 1888 1.456 1.470  1.211  1.099 1.434 0.669 0.518 0.039 0.112   NA    NA  0.616
#> 1889 1.505 1.516  1.260  1.120 1.478 0.716 0.513 0.063 0.140   NA    NA  0.715
#> 1890 1.467 1.462  1.197  1.074 1.438 0.727 0.531 0.073 0.123   NA    NA  0.848
#> 1891 1.548 1.548  1.313  1.168 1.528 0.719 0.471 0.103 0.145   NA    NA  0.940
#> 1892 1.540 1.534  1.270  1.164 1.525 0.722 0.528 0.088 0.106   NA    NA  0.972
#> 1893 1.616 1.606  1.353  1.243 1.600 0.713 0.505 0.098 0.110   NA    NA  1.117
#> 1894 1.617 1.611  1.365  1.243 1.586 0.687 0.492 0.073 0.122   NA    NA  1.086
#> 1895 1.673 1.667  1.427  1.303 1.638 0.671 0.480 0.067 0.124   NA    NA  1.168
#> 1896 1.566 1.561  1.312  1.184 1.522 0.676 0.498 0.050 0.128   NA    NA  0.968
#> 1897 1.525 1.518  1.266  1.120 1.489 0.738 0.503 0.089 0.146   NA    NA  0.943
#> 1898 1.489 1.488  1.213  1.105 1.470 0.730 0.550 0.072 0.108   NA    NA  0.829
#> 1899 1.449 1.458  1.195  1.078 1.434 0.712 0.527 0.068 0.117   NA    NA  0.728
#> 1900 1.464 1.458  1.186  1.103 1.448 0.690 0.543 0.064 0.083   NA    NA  0.498
#> 1901 1.497 1.501  1.245  1.138 1.477 0.678 0.512 0.059 0.107   NA    NA  0.870
#> 1902 1.581 1.576  1.317  1.194 1.550 0.712 0.517 0.072 0.123   NA    NA  1.059
#> 1903 1.573 1.568  1.278  1.186 1.557 0.742 0.580 0.070 0.092   NA    NA  0.978
#> 1904 1.568 1.559  1.303  1.188 1.552 0.729 0.512 0.102 0.115   NA    NA  1.012
#> 1905 1.621 1.616  1.379  1.272 1.609 0.674 0.475 0.092 0.107   NA    NA  1.090
#> 1906 1.612 1.630  1.381  1.250 1.604 0.708 0.499 0.078 0.131   NA    NA -0.137
#> 1907 1.628 1.618  1.351  1.236 1.590 0.707 0.534 0.058 0.115   NA    NA  1.103
#> 1908 1.602 1.576  1.327  1.213 1.566 0.707 0.497 0.096 0.114   NA    NA  0.956
#> 1909 1.551 1.550  1.297  1.163 1.520 0.714 0.506 0.074 0.134   NA    NA  0.750
#> 1910 1.467 1.448  1.185  1.075 1.442 0.734 0.526 0.098 0.110   NA    NA  0.882
#> 1911 1.425 1.418  1.149  1.039 1.393 0.708 0.539 0.059 0.110   NA    NA  0.693
#> 1912 1.540 1.539  1.282  1.168 1.514 0.691 0.514 0.063 0.114   NA    NA  0.934
#> 1913 1.550 1.540  1.277  1.161 1.512 0.703 0.525 0.062 0.116   NA    NA  0.905
#> 1914 1.543 1.535  1.269  1.163 1.521 0.716 0.532 0.078 0.106   NA    NA  1.004
#> 1915 1.626 1.614  1.351  1.229 1.606 0.755 0.526 0.107 0.122   NA    NA  1.039
#> 1916 1.543 1.528  1.239  1.142 1.520 0.756 0.579 0.080 0.097   NA    NA  1.001
#> 1917 1.611 1.589  1.318  1.217 1.590 0.747 0.542 0.104 0.101   NA    NA  1.015
#> 1918 1.606 1.594  1.345  1.254 1.589 0.670 0.497 0.082 0.091   NA    NA  1.142
#> 1919 1.651 1.648  1.416  1.294 1.620 0.651 0.465 0.064 0.122   NA    NA  1.005
#> 1920 1.592 1.599  1.365  1.217 1.555 0.676 0.468 0.060 0.148   NA    NA  0.886
#> 1921 1.515 1.484  1.200  1.129 1.495 0.732 0.567 0.094 0.071   NA    NA  0.797
#> 1922 1.427 1.418  1.169  1.056 1.409 0.706 0.498 0.095 0.113   NA    NA  0.643
#> 1923 1.449 1.448  1.183  1.087 1.438 0.701 0.531 0.074 0.096   NA    NA  0.804
#> 1924 1.466 1.463  1.209  1.101 1.452 0.703 0.508 0.087 0.108   NA    NA  0.821
#> 1925 1.501 1.487  1.220  1.135 1.488 0.705 0.534 0.086 0.085   NA    NA  0.915
#> 1926 1.567 1.560  1.301  1.183 1.544 0.722 0.517 0.087 0.118   NA    NA  1.047
#> 1927 1.582 1.572  1.300  1.206 1.566 0.720 0.544 0.082 0.094   NA    NA  1.085
#> 1928 1.566 1.552  1.275  1.180 1.550 0.740 0.553 0.092 0.095   NA    NA  1.056
#> 1929 1.616 1.622  1.348  1.210 1.586 0.752 0.547 0.067 0.138   NA    NA  1.023
#> 1930 1.768 1.746  1.467  1.334 1.732 0.797 0.558 0.106 0.133   NA    NA  1.152
#> 1931 1.624 1.612  1.343  1.219 1.578 0.718 0.538 0.056 0.124   NA    NA  0.908
#> 1932 1.633 1.622  1.353  1.221 1.588 0.733 0.537 0.064 0.132   NA    NA  0.845
#> 1933 1.422 1.404  1.106  0.998 1.388 0.781 0.596 0.077 0.108   NA    NA  0.575
#> 1934 1.324 1.330  1.047  0.913 1.305 0.784 0.566 0.084 0.134   NA    NA  0.622
#> 1935 1.377 1.382  1.117  0.998 1.361 0.726 0.531 0.076 0.119   NA    NA  0.711
#> 1936 1.455 1.448  1.194  1.093 1.432 0.679 0.509 0.069 0.101   NA    NA  0.811
#> 1937 1.468 1.458  1.188  1.082 1.446 0.727 0.541 0.080 0.106   NA    NA  0.918
#> 1938 1.539 1.535  1.260  1.130 1.511 0.762 0.550 0.082 0.130   NA    NA  1.010
#> 1939 1.570 1.570  1.313  1.168 1.548 0.759 0.514 0.100 0.145   NA    NA  0.967
#> 1940 1.574 1.567  1.313  1.199 1.558 0.718 0.508 0.096 0.114   NA    NA  0.984
#> 1941 1.623 1.626  1.362  1.255 1.616 0.721 0.527 0.087 0.107   NA    NA  1.044
#> 1942 1.605 1.608  1.354  1.240 1.588 0.696 0.507 0.075 0.114   NA    NA  1.117
#> 1943 1.626 1.618  1.381  1.256 1.588 0.664 0.475 0.064 0.125   NA    NA  1.037
#> 1944 1.485 1.477  1.236  1.098 1.452 0.709 0.482 0.089 0.138   NA    NA  0.710
#>      inferred
#> 1           0
#> 2           0
#> 3           0
#> 4           0
#> 5           0
#> 6           0
#> 7           0
#> 8           0
#> 9           0
#> 10          0
#> 11         11
#> 12          0
#> 13          0
#> 14          0
#> 15          0
#> 16          0
#> 17          0
#> 18          0
#> 19          0
#> 20          0
#> 21          0
#> 22          0
#> 23          0
#> 24          0
#> 25          0
#> 26          0
#> 27          0
#> 28         11
#> 29         11
#> 30          0
#> 31          0
#> 32          0
#> 33          0
#> 34         11
#> 35         11
#> 36          0
#> 37          0
#> 38          0
#> 39          0
#> 40          0
#> 41         11
#> 42          0
#> 43         11
#> 44          1
#> 45          1
#> 46          1
#> 47          1
#> 48          1
#> 49          1
#> 50          0
#> 51          0
#> 52          1
#> 53          1
#> 54          0
#> 55          1
#> 56         11
#> 57          1
#> 58          0
#> 59          0
#> 60          0
#> 61          0
#> 62          0
#> 63         13
#> 64         11
#> 65         11
#> 66          0
#> 67          0
#> 68          1
#> 69          1
#> 70          1
#> 71          0
#> 72          0
#> 73          0
#> 74          0
#> 75          0
#> 76          1
#> 77          1
#> 78          0
#> 79          0
#> 80          1
#> 81         11
#> 82          0
#> 83          0
#> 84          0
#> 85          0
#> 86          0
#> 87          0
#> 88          0
#> 89          0
#> 90          0
#> 91          0
#> 92          0
#> 93          0
#> 94          0
#> 95          0
#> 96          0
#> 97          0
#> 98          0
#> 99          0
#> 100         0
#> 101         0
#> 102         0
#> 103         0
#> 104         0
#> 105         0
#> 106         0
#> 107         0
#> 108         0
#> 109         0
#> 110         0
#> 111         0
#> 112         0
#> 113         0
#> 114         0
#> 115         0
#> 116         0
#> 117         0
#> 118         0
#> 119         0
#> 120         0
#> 121         0
#> 122         0
#> 123         0
#> 124         0
#> 125         0
#> 126         0
#> 127         0
#> 128         0
#> 129         0
#> 130         0
#> 131         0
#> 132         0
#> 133         0
#> 134         0
#> 135         0
#> 136         0
#> 137         0
#> 138         0
#> 139         0
#> 140         0
#> 141         0
#> 142         0
#> 143         0
#> 144         0
#> 145         0
#> 146         0
#> 147         0
#> 148         0
#> 149         0
#> 150         0
#> 151         0
#> 152         0
#> 153         0
#> 154         0
#> 155         0
#> 156         0
#> 157         0
#> 158         0
#> 159         0
#> 160         0
#> 161         0
#> 162        11
#> 163         0
#> 164         0
#> 165        11
#> 166        11
#> 167         0
#> 168         0
#> 169         0
#> 170         0
#> 171         0
#> 172         0
#> 173         0
#> 174         0
#> 175         0
#> 176         0
#> 177         0
#> 178         0
#> 179         0
#> 180         0
#> 181         0
#> 182         0
#> 183         0
#> 184         0
#> 185         0
#> 186         0
#> 187         0
#> 188         0
#> 189         0
#> 190         0
#> 191         0
#> 192         0
#> 193         0
#> 194         0
#> 195         0
#> 196         0
#> 197         0
#> 198         0
#> 199         0
#> 200         0
#> 201         0
#> 202         0
#> 203         0
#> 204         0
#> 205         0
#> 206         0
#> 207         0
#> 208         0
#> 209         0
#> 210         0
#> 211         0
#> 212         0
#> 213         0
#> 214         0
#> 215         0
#> 216         0
#> 217         0
#> 218         0
#> 219        11
#> 220        11
#> 221         0
#> 222         0
#> 223         0
#> 224         0
#> 225         0
#> 226         0
#> 227         0
#> 228         0
#> 229         0
#> 230         0
#> 231         0
#> 232         0
#> 233         0
#> 234         0
#> 235         0
#> 236         0
#> 237         0
#> 238         0
#> 239         0
#> 240         0
#> 241         0
#> 242         0
#> 243         0
#> 244        11
#> 245        11
#> 246         0
#> 247         0
#> 248         0
#> 249         0
#> 250         0
#> 251         0
#> 252         0
#> 253         0
#> 254         0
#> 255         0
#> 256         0
#> 257         0
#> 258         0
#> 259         0
#> 260         0
#> 261         0
#> 262         0
#> 263         0
#> 264         0
#> 265         0
#> 266         0
#> 267         0
#> 268         0
#> 269         0
#> 270         0
#> 271        11
#> 272         0
#> 273         0
#> 274         0
#> 275         0
#> 276         0
#> 277         0
#> 278         0
#> 279         0
#> 280        11
#> 281        11
#> 282         0
#> 283        11
#> 284        11
#> 285         0
#> 286         0
#> 287         0
#> 288         0
#> 289         0
#> 290         0
#> 291         0
#> 292         0
#> 293         0
#> 294         0
#> 295         0
#> 296         0
#> 297         0
#> 298         0
#> 299         0
#> 300         0
#> 301         0
#> 302         0
#> 303         0
#> 304         0
#> 305         0
#> 306         0
#> 307         0
#> 308         0
#> 309         0
#> 310         0
#> 311         0
#> 312         0
#> 313         0
#> 314         0
#> 315         0
#> 316         0
#> 317         0
#> 318         0
#> 319         0
#> 320         0
#> 321         0
#> 322         0
#> 323         0
#> 324         0
#> 325         0
#> 326         0
#> 327         0
#> 328         0
#> 329         0
#> 330         0
#> 331         0
#> 332         0
#> 333         0
#> 334         0
#> 335         0
#> 336         0
#> 337         0
#> 338         0
#> 339         0
#> 340         0
#> 341         0
#> 342         0
#> 343         0
#> 344         0
#> 345         0
#> 346         0
#> 347         0
#> 348         0
#> 349         0
#> 350         0
#> 351         0
#> 352         0
#> 353         0
#> 354        11
#> 355         0
#> 356         0
#> 357         0
#> 358         0
#> 359         0
#> 360         0
#> 361        11
#> 362         0
#> 363         0
#> 364         0
#> 365         0
#> 366         0
#> 367         0
#> 368         0
#> 369         0
#> 370         0
#> 371         0
#> 372         0
#> 373         0
#> 374         0
#> 375         0
#> 376         0
#> 377         0
#> 378         0
#> 379         0
#> 380         0
#> 381         0
#> 382         0
#> 383         0
#> 384         0
#> 385         0
#> 386         0
#> 387         0
#> 388         0
#> 389         0
#> 390         0
#> 391         0
#> 392         0
#> 393         0
#> 394         0
#> 395         0
#> 396         0
#> 397         0
#> 398         0
#> 399         0
#> 400         0
#> 401         0
#> 402         0
#> 403         0
#> 404         0
#> 405         0
#> 406         0
#> 407         0
#> 408         0
#> 409         0
#> 410         0
#> 411         0
#> 412         0
#> 413         0
#> 414         0
#> 415         0
#> 416         0
#> 417         0
#> 418         0
#> 419         0
#> 420         0
#> 421         0
#> 422         0
#> 423         0
#> 424         0
#> 425         0
#> 426         0
#> 427         0
#> 428         0
#> 429         0
#> 430         0
#> 431         0
#> 432         0
#> 433         0
#> 434         0
#> 435         0
#> 436         0
#> 437         0
#> 438         0
#> 439         0
#> 440         0
#> 441         0
#> 442         0
#> 443         0
#> 444         0
#> 445         0
#> 446         0
#> 447         0
#> 448         0
#> 449         0
#> 450         0
#> 451         0
#> 452         0
#> 453         0
#> 454         0
#> 455         0
#> 456         0
#> 457         0
#> 458         0
#> 459         0
#> 460         0
#> 461         0
#> 462         0
#> 463         0
#> 464         0
#> 465         0
#> 466         0
#> 467         0
#> 468         0
#> 469         0
#> 470         0
#> 471         0
#> 472         0
#> 473         0
#> 474         0
#> 475         0
#> 476         0
#> 477         0
#> 478         0
#> 479         0
#> 480         0
#> 481         0
#> 482         0
#> 483         0
#> 484         0
#> 485         0
#> 486         0
#> 487         0
#> 488         0
#> 489         0
#> 490         0
#> 491         0
#> 492         0
#> 493         0
#> 494         0
#> 495         0
#> 496         0
#> 497         0
#> 498         0
#> 499         0
#> 500         0
#> 501         0
#> 502         0
#> 503         0
#> 504         0
#> 505         0
#> 506         0
#> 507         0
#> 508         0
#> 509         0
#> 510         0
#> 511         0
#> 512         0
#> 513         0
#> 514         0
#> 515         0
#> 516         0
#> 517         0
#> 518         0
#> 519         0
#> 520         0
#> 521         0
#> 522         0
#> 523         0
#> 524         0
#> 525         0
#> 526         0
#> 527         0
#> 528         0
#> 529         0
#> 530         0
#> 531         0
#> 532         0
#> 533         0
#> 534         0
#> 535         0
#> 536         0
#> 537         0
#> 538         0
#> 539         0
#> 540         0
#> 541         0
#> 542         0
#> 543         0
#> 544         0
#> 545         0
#> 546         0
#> 547         0
#> 548         0
#> 549         0
#> 550         0
#> 551         0
#> 552         0
#> 553         0
#> 554         0
#> 555         0
#> 556         0
#> 557         0
#> 558         0
#> 559         0
#> 560         0
#> 561         0
#> 562         0
#> 563         0
#> 564         0
#> 565         0
#> 566         0
#> 567         0
#> 568         0
#> 569         0
#> 570         0
#> 571         0
#> 572         0
#> 573         0
#> 574         0
#> 575         0
#> 576         0
#> 577         0
#> 578         0
#> 579         0
#> 580         0
#> 581         0
#> 582         0
#> 583         0
#> 584         0
#> 585         0
#> 586         0
#> 587         0
#> 588         0
#> 589         0
#> 590         0
#> 591         0
#> 592         0
#> 593         0
#> 594         0
#> 595         0
#> 596         0
#> 597         0
#> 598         0
#> 599         0
#> 600         0
#> 601         0
#> 602         0
#> 603         0
#> 604         0
#> 605         0
#> 606         0
#> 607         0
#> 608         0
#> 609         0
#> 610         0
#> 611         0
#> 612         0
#> 613         0
#> 614         0
#> 615         0
#> 616         0
#> 617         0
#> 618         0
#> 619         0
#> 620         0
#> 621         0
#> 622         0
#> 623         0
#> 624         0
#> 625         0
#> 626         0
#> 627         0
#> 628         0
#> 629         0
#> 630         0
#> 631         0
#> 632         0
#> 633         0
#> 634         0
#> 635         0
#> 636         0
#> 637         0
#> 638         0
#> 639         0
#> 640         0
#> 641         0
#> 642         0
#> 643         0
#> 644         0
#> 645         0
#> 646         0
#> 647         0
#> 648         0
#> 649         0
#> 650         0
#> 651         0
#> 652         0
#> 653         0
#> 654         0
#> 655         0
#> 656         0
#> 657         0
#> 658         0
#> 659         0
#> 660         0
#> 661         0
#> 662         0
#> 663         0
#> 664         0
#> 665         0
#> 666         0
#> 667         0
#> 668         0
#> 669         0
#> 670         0
#> 671         0
#> 672         0
#> 673         0
#> 674         0
#> 675         0
#> 676         0
#> 677         0
#> 678         0
#> 679         0
#> 680         0
#> 681         0
#> 682         0
#> 683         0
#> 684         0
#> 685         0
#> 686         0
#> 687         0
#> 688         0
#> 689         0
#> 690         0
#> 691         0
#> 692         0
#> 693         0
#> 694         0
#> 695         0
#> 696         0
#> 697         0
#> 698         0
#> 699         0
#> 700        11
#> 701        11
#> 702         0
#> 703        11
#> 704         0
#> 705         0
#> 706         0
#> 707         0
#> 708         0
#> 709         0
#> 710         0
#> 711         0
#> 712         0
#> 713         0
#> 714         0
#> 715         0
#> 716         0
#> 717         0
#> 718         0
#> 719         0
#> 720         0
#> 721         0
#> 722         0
#> 723         0
#> 724         0
#> 725         0
#> 726         0
#> 727         0
#> 728         0
#> 729         0
#> 730         0
#> 731         0
#> 732         0
#> 733         0
#> 734        11
#> 735        11
#> 736        11
#> 737         0
#> 738         0
#> 739         0
#> 740         0
#> 741         0
#> 742         0
#> 743         0
#> 744         0
#> 745         0
#> 746         0
#> 747         0
#> 748         0
#> 749         0
#> 750         0
#> 751        11
#> 752         0
#> 753         0
#> 754         0
#> 755         0
#> 756         0
#> 757         0
#> 758        11
#> 759         0
#> 760         0
#> 761         0
#> 762         0
#> 763         0
#> 764         0
#> 765         0
#> 766         0
#> 767         0
#> 768         0
#> 769         0
#> 770         0
#> 771         0
#> 772         0
#> 773         0
#> 774         0
#> 775         0
#> 776         0
#> 777         0
#> 778         0
#> 779         0
#> 780         0
#> 781         0
#> 782         0
#> 783         0
#> 784         0
#> 785         0
#> 786         0
#> 787         0
#> 788         0
#> 789         0
#> 790         0
#> 791         0
#> 792         0
#> 793         0
#> 794         0
#> 795         0
#> 796         0
#> 797         0
#> 798         0
#> 799         0
#> 800         0
#> 801         0
#> 802         0
#> 803         0
#> 804         0
#> 805         0
#> 806         0
#> 807         0
#> 808         0
#> 809         0
#> 810         0
#> 811         0
#> 812         0
#> 813         0
#> 814         0
#> 815         0
#> 816         0
#> 817         0
#> 818         0
#> 819         0
#> 820         0
#> 821         0
#> 822         0
#> 823         0
#> 824         0
#> 825         0
#> 826         0
#> 827         0
#> 828         0
#> 829         0
#> 830         0
#> 831         0
#> 832         0
#> 833         0
#> 834         0
#> 835         0
#> 836         0
#> 837         0
#> 838         0
#> 839         0
#> 840         0
#> 841         0
#> 842         0
#> 843         0
#> 844         0
#> 845         0
#> 846         0
#> 847         0
#> 848         0
#> 849         0
#> 850         0
#> 851         0
#> 852         0
#> 853         0
#> 854         0
#> 855         0
#> 856         0
#> 857         0
#> 858         0
#> 859         0
#> 860         0
#> 861         0
#> 862         0
#> 863         0
#> 864         0
#> 865         0
#> 866         0
#> 867         0
#> 868         0
#> 869         0
#> 870         0
#> 871         0
#> 872         0
#> 873         0
#> 874         0
#> 875         0
#> 876         0
#> 877         0
#> 878         0
#> 879         0
#> 880         0
#> 881         0
#> 882         0
#> 883         0
#> 884         0
#> 885         0
#> 886         0
#> 887         0
#> 888         0
#> 889         0
#> 890         0
#> 891         0
#> 892         0
#> 893         0
#> 894         0
#> 895         0
#> 896         0
#> 897         0
#> 898         0
#> 899         0
#> 900         0
#> 901         0
#> 902         0
#> 903         0
#> 904         0
#> 905         0
#> 906         0
#> 907         0
#> 908         0
#> 909         0
#> 910         0
#> 911         0
#> 912         0
#> 913         0
#> 914         0
#> 915         0
#> 916         0
#> 917         0
#> 918         0
#> 919         0
#> 920         0
#> 921         0
#> 922         0
#> 923         0
#> 924         0
#> 925         0
#> 926         0
#> 927         0
#> 928         0
#> 929         0
#> 930         0
#> 931         0
#> 932         0
#> 933         0
#> 934         0
#> 935         0
#> 936         0
#> 937         0
#> 938         0
#> 939         0
#> 940         0
#> 941         0
#> 942         0
#> 943         0
#> 944         0
#> 945         0
#> 946         0
#> 947         0
#> 948         0
#> 949         0
#> 950         0
#> 951         0
#> 952         0
#> 953         0
#> 954         0
#> 955         0
#> 956         0
#> 957         0
#> 958         0
#> 959         0
#> 960         0
#> 961         0
#> 962         0
#> 963         0
#> 964         0
#> 965         0
#> 966         0
#> 967         0
#> 968         0
#> 969         0
#> 970         0
#> 971         0
#> 972         0
#> 973         0
#> 974         0
#> 975         0
#> 976         0
#> 977         0
#> 978         0
#> 979         0
#> 980         0
#> 981         0
#> 982         0
#> 983         0
#> 984         0
#> 985         0
#> 986         0
#> 987         0
#> 988         0
#> 989         0
#> 990         0
#> 991         0
#> 992         0
#> 993         0
#> 994         0
#> 995         0
#> 996         0
#> 997         0
#> 998         0
#> 999         0
#> 1000        0
#> 1001        0
#> 1002        0
#> 1003        0
#> 1004        0
#> 1005        0
#> 1006        0
#> 1007        0
#> 1008        0
#> 1009        0
#> 1010        0
#> 1011        0
#> 1012        0
#> 1013        0
#> 1014        0
#> 1015        0
#> 1016        0
#> 1017        0
#> 1018        0
#> 1019        0
#> 1020        0
#> 1021        0
#> 1022        0
#> 1023        0
#> 1024        0
#> 1025        0
#> 1026        0
#> 1027        0
#> 1028        0
#> 1029        0
#> 1030        0
#> 1031        0
#> 1032        0
#> 1033        0
#> 1034        0
#> 1035        0
#> 1036        0
#> 1037        0
#> 1038        0
#> 1039        0
#> 1040        0
#> 1041        0
#> 1042        0
#> 1043        0
#> 1044        0
#> 1045        0
#> 1046        0
#> 1047        0
#> 1048        0
#> 1049        0
#> 1050        0
#> 1051        0
#> 1052        0
#> 1053        0
#> 1054        0
#> 1055        0
#> 1056        0
#> 1057        0
#> 1058        0
#> 1059        0
#> 1060        0
#> 1061        0
#> 1062        0
#> 1063        0
#> 1064        0
#> 1065        0
#> 1066        0
#> 1067        0
#> 1068        0
#> 1069        0
#> 1070        0
#> 1071        0
#> 1072        0
#> 1073        0
#> 1074        0
#> 1075        0
#> 1076        0
#> 1077        0
#> 1078        0
#> 1079        0
#> 1080        0
#> 1081        0
#> 1082        0
#> 1083        0
#> 1084        0
#> 1085        0
#> 1086        0
#> 1087        0
#> 1088        0
#> 1089        0
#> 1090        0
#> 1091        0
#> 1092        0
#> 1093        0
#> 1094        0
#> 1095        0
#> 1096        0
#> 1097        0
#> 1098        0
#> 1099        0
#> 1100        0
#> 1101        0
#> 1102        0
#> 1103        0
#> 1104        0
#> 1105        0
#> 1106        0
#> 1107        0
#> 1108        0
#> 1109        0
#> 1110        0
#> 1111        0
#> 1112        0
#> 1113        0
#> 1114        0
#> 1115        0
#> 1116        0
#> 1117        0
#> 1118        0
#> 1119        0
#> 1120        0
#> 1121        0
#> 1122        0
#> 1123        0
#> 1124        0
#> 1125        0
#> 1126        0
#> 1127        0
#> 1128        0
#> 1129        0
#> 1130        0
#> 1131        0
#> 1132        0
#> 1133        0
#> 1134        0
#> 1135        0
#> 1136        0
#> 1137        0
#> 1138        0
#> 1139        0
#> 1140        0
#> 1141        0
#> 1142        0
#> 1143        0
#> 1144        0
#> 1145        0
#> 1146        0
#> 1147        0
#> 1148        0
#> 1149        0
#> 1150        0
#> 1151        0
#> 1152        0
#> 1153        0
#> 1154        0
#> 1155        0
#> 1156        0
#> 1157        0
#> 1158        0
#> 1159        0
#> 1160        0
#> 1161        0
#> 1162        0
#> 1163        0
#> 1164        0
#> 1165        0
#> 1166        0
#> 1167        0
#> 1168        0
#> 1169        0
#> 1170        0
#> 1171        0
#> 1172        0
#> 1173        0
#> 1174        0
#> 1175        0
#> 1176        0
#> 1177        0
#> 1178        0
#> 1179        0
#> 1180        0
#> 1181        0
#> 1182        0
#> 1183        0
#> 1184        0
#> 1185        0
#> 1186        0
#> 1187        0
#> 1188        0
#> 1189        0
#> 1190        0
#> 1191        0
#> 1192        0
#> 1193        0
#> 1194        0
#> 1195        0
#> 1196        0
#> 1197        0
#> 1198        0
#> 1199        0
#> 1200        0
#> 1201        0
#> 1202        0
#> 1203        0
#> 1204        0
#> 1205        0
#> 1206        0
#> 1207        0
#> 1208        0
#> 1209        0
#> 1210        0
#> 1211        0
#> 1212        0
#> 1213        0
#> 1214        0
#> 1215        0
#> 1216        0
#> 1217        0
#> 1218        0
#> 1219        0
#> 1220        0
#> 1221        0
#> 1222        0
#> 1223        0
#> 1224        0
#> 1225        0
#> 1226        0
#> 1227        0
#> 1228        0
#> 1229        0
#> 1230        0
#> 1231        0
#> 1232        0
#> 1233        0
#> 1234        0
#> 1235        0
#> 1236        0
#> 1237        0
#> 1238        0
#> 1239        0
#> 1240        0
#> 1241        0
#> 1242        0
#> 1243        0
#> 1244        0
#> 1245        0
#> 1246        0
#> 1247        0
#> 1248        0
#> 1249        0
#> 1250        0
#> 1251        0
#> 1252        0
#> 1253        0
#> 1254        0
#> 1255        0
#> 1256        0
#> 1257        0
#> 1258        4
#> 1259        0
#> 1260        0
#> 1261        0
#> 1262        0
#> 1263        0
#> 1264        0
#> 1265        0
#> 1266        0
#> 1267        0
#> 1268        0
#> 1269        0
#> 1270        0
#> 1271        0
#> 1272        0
#> 1273        0
#> 1274        0
#> 1275        0
#> 1276        0
#> 1277        0
#> 1278        0
#> 1279        0
#> 1280        0
#> 1281        0
#> 1282        0
#> 1283        0
#> 1284        0
#> 1285        0
#> 1286        0
#> 1287        0
#> 1288        0
#> 1289        0
#> 1290        0
#> 1291        0
#> 1292        0
#> 1293       11
#> 1294        0
#> 1295        0
#> 1296        0
#> 1297        0
#> 1298        0
#> 1299        0
#> 1300        0
#> 1301        0
#> 1302        0
#> 1303        0
#> 1304       11
#> 1305        0
#> 1306        0
#> 1307        0
#> 1308        0
#> 1309        0
#> 1310        0
#> 1311       11
#> 1312        0
#> 1313        0
#> 1314        0
#> 1315        0
#> 1316        0
#> 1317        0
#> 1318        0
#> 1319        0
#> 1320        0
#> 1321        0
#> 1322        0
#> 1323        0
#> 1324        0
#> 1325        0
#> 1326        0
#> 1327        0
#> 1328        0
#> 1329        0
#> 1330        0
#> 1331        0
#> 1332        0
#> 1333        0
#> 1334        0
#> 1335        0
#> 1336        0
#> 1337        0
#> 1338        0
#> 1339        0
#> 1340        0
#> 1341        0
#> 1342        0
#> 1343        0
#> 1344        1
#> 1345        0
#> 1346        1
#> 1347        1
#> 1348        1
#> 1349        1
#> 1350        0
#> 1351        0
#> 1352        0
#> 1353        0
#> 1354        0
#> 1355        0
#> 1356        0
#> 1357        0
#> 1358        1
#> 1359        0
#> 1360        0
#> 1361        0
#> 1362        0
#> 1363        0
#> 1364        0
#> 1365        0
#> 1366        0
#> 1367        0
#> 1368        0
#> 1369        0
#> 1370        0
#> 1371        0
#> 1372        0
#> 1373        0
#> 1374        0
#> 1375        0
#> 1376        0
#> 1377        0
#> 1378       11
#> 1379       11
#> 1380        0
#> 1381        0
#> 1382        0
#> 1383        1
#> 1384        0
#> 1385        0
#> 1386        0
#> 1387        0
#> 1388        0
#> 1389        0
#> 1390        0
#> 1391        0
#> 1392        0
#> 1393        0
#> 1394        0
#> 1395        0
#> 1396        0
#> 1397        0
#> 1398        0
#> 1399        0
#> 1400        0
#> 1401        0
#> 1402        0
#> 1403        0
#> 1404        0
#> 1405        0
#> 1406        0
#> 1407        0
#> 1408        0
#> 1409        0
#> 1410        0
#> 1411        0
#> 1412        0
#> 1413        0
#> 1414        0
#> 1415        0
#> 1416        0
#> 1417        0
#> 1418        0
#> 1419        0
#> 1420        0
#> 1421        0
#> 1422        0
#> 1423        0
#> 1424        0
#> 1425        0
#> 1426        0
#> 1427        0
#> 1428        0
#> 1429        0
#> 1430        0
#> 1431        0
#> 1432        0
#> 1433        0
#> 1434        0
#> 1435        0
#> 1436        0
#> 1437        0
#> 1438        0
#> 1439        0
#> 1440        0
#> 1441        0
#> 1442        0
#> 1443        0
#> 1444        0
#> 1445        0
#> 1446        0
#> 1447        0
#> 1448        0
#> 1449        0
#> 1450        0
#> 1451        0
#> 1452        0
#> 1453        0
#> 1454        0
#> 1455        0
#> 1456        0
#> 1457        0
#> 1458        0
#> 1459        0
#> 1460        0
#> 1461        0
#> 1462        0
#> 1463        0
#> 1464        0
#> 1465        0
#> 1466        0
#> 1467        0
#> 1468        0
#> 1469        0
#> 1470        0
#> 1471        0
#> 1472        0
#> 1473        0
#> 1474        0
#> 1475        0
#> 1476        0
#> 1477        0
#> 1478        0
#> 1479        0
#> 1480        0
#> 1481        0
#> 1482        0
#> 1483        0
#> 1484        0
#> 1485        0
#> 1486        0
#> 1487        0
#> 1488        0
#> 1489        0
#> 1490        0
#> 1491        0
#> 1492        0
#> 1493        0
#> 1494        0
#> 1495        0
#> 1496        0
#> 1497        0
#> 1498        0
#> 1499        0
#> 1500        0
#> 1501        0
#> 1502        0
#> 1503        0
#> 1504        0
#> 1505        0
#> 1506        0
#> 1507        0
#> 1508        0
#> 1509        0
#> 1510        0
#> 1511        0
#> 1512        0
#> 1513        0
#> 1514        0
#> 1515        0
#> 1516        0
#> 1517        0
#> 1518        0
#> 1519        0
#> 1520        0
#> 1521        0
#> 1522        0
#> 1523        0
#> 1524        0
#> 1525        0
#> 1526        0
#> 1527        0
#> 1528        0
#> 1529        0
#> 1530        0
#> 1531        0
#> 1532        0
#> 1533        0
#> 1534        0
#> 1535        0
#> 1536        0
#> 1537        0
#> 1538        0
#> 1539        0
#> 1540        0
#> 1541        0
#> 1542        0
#> 1543        0
#> 1544        0
#> 1545        0
#> 1546        0
#> 1547        0
#> 1548        0
#> 1549        0
#> 1550        0
#> 1551        0
#> 1552        0
#> 1553        0
#> 1554        0
#> 1555        0
#> 1556        0
#> 1557        0
#> 1558        0
#> 1559        0
#> 1560        0
#> 1561        0
#> 1562        0
#> 1563        0
#> 1564        0
#> 1565        0
#> 1566        0
#> 1567        0
#> 1568        0
#> 1569        0
#> 1570        0
#> 1571        0
#> 1572        0
#> 1573        0
#> 1574        0
#> 1575        0
#> 1576        0
#> 1577        0
#> 1578        0
#> 1579        0
#> 1580        0
#> 1581        0
#> 1582        0
#> 1583        0
#> 1584        0
#> 1585        0
#> 1586        0
#> 1587        0
#> 1588        0
#> 1589        0
#> 1590        0
#> 1591        0
#> 1592        0
#> 1593        0
#> 1594        0
#> 1595        0
#> 1596        0
#> 1597        0
#> 1598        0
#> 1599        0
#> 1600        0
#> 1601        0
#> 1602        0
#> 1603        0
#> 1604        0
#> 1605        0
#> 1606        0
#> 1607        0
#> 1608        0
#> 1609        0
#> 1610        0
#> 1611        0
#> 1612        0
#> 1613        0
#> 1614        0
#> 1615        0
#> 1616        0
#> 1617        0
#> 1618        0
#> 1619        0
#> 1620        0
#> 1621        0
#> 1622        0
#> 1623        0
#> 1624        0
#> 1625        0
#> 1626        0
#> 1627        0
#> 1628        0
#> 1629        0
#> 1630        0
#> 1631        0
#> 1632        0
#> 1633        0
#> 1634        0
#> 1635        0
#> 1636        0
#> 1637        0
#> 1638        0
#> 1639        0
#> 1640        0
#> 1641        0
#> 1642        0
#> 1643        0
#> 1644        0
#> 1645        0
#> 1646        0
#> 1647        0
#> 1648        0
#> 1649        0
#> 1650        0
#> 1651        0
#> 1652        0
#> 1653        0
#> 1654        0
#> 1655        0
#> 1656        0
#> 1657        0
#> 1658        0
#> 1659        0
#> 1660        0
#> 1661        0
#> 1662        0
#> 1663        0
#> 1664        0
#> 1665        0
#> 1666        0
#> 1667        0
#> 1668        0
#> 1669        0
#> 1670        0
#> 1671        0
#> 1672        0
#> 1673        0
#> 1674        0
#> 1675        0
#> 1676        0
#> 1677        0
#> 1678        0
#> 1679        0
#> 1680        0
#> 1681        0
#> 1682        0
#> 1683        0
#> 1684        0
#> 1685        0
#> 1686        0
#> 1687        0
#> 1688        0
#> 1689        0
#> 1690        0
#> 1691        0
#> 1692        0
#> 1693        0
#> 1694        0
#> 1695        0
#> 1696        0
#> 1697        0
#> 1698        0
#> 1699        0
#> 1700        0
#> 1701        0
#> 1702        0
#> 1703        0
#> 1704        0
#> 1705        0
#> 1706        0
#> 1707        0
#> 1708        0
#> 1709        0
#> 1710       11
#> 1711        0
#> 1712        0
#> 1713        0
#> 1714        0
#> 1715        0
#> 1716        0
#> 1717        0
#> 1718        0
#> 1719        0
#> 1720        0
#> 1721        0
#> 1722        0
#> 1723        0
#> 1724        0
#> 1725        0
#> 1726        0
#> 1727        0
#> 1728        0
#> 1729        0
#> 1730        0
#> 1731        0
#> 1732        0
#> 1733        0
#> 1734        0
#> 1735        0
#> 1736        0
#> 1737        0
#> 1738        0
#> 1739        0
#> 1740        0
#> 1741        0
#> 1742        0
#> 1743        0
#> 1744        0
#> 1745        0
#> 1746        0
#> 1747        0
#> 1748        0
#> 1749        0
#> 1750        0
#> 1751        0
#> 1752        0
#> 1753        0
#> 1754        0
#> 1755        0
#> 1756        0
#> 1757        0
#> 1758        0
#> 1759        0
#> 1760        0
#> 1761        0
#> 1762        0
#> 1763        0
#> 1764        0
#> 1765        0
#> 1766        0
#> 1767        0
#> 1768        0
#> 1769        0
#> 1770        0
#> 1771        0
#> 1772        0
#> 1773        0
#> 1774        0
#> 1775        0
#> 1776        0
#> 1777        0
#> 1778        0
#> 1779        0
#> 1780        0
#> 1781        0
#> 1782        0
#> 1783        0
#> 1784        0
#> 1785        0
#> 1786        0
#> 1787        0
#> 1788        0
#> 1789        0
#> 1790        0
#> 1791        0
#> 1792        0
#> 1793        0
#> 1794        0
#> 1795        0
#> 1796        0
#> 1797        0
#> 1798        0
#> 1799        0
#> 1800        0
#> 1801        0
#> 1802        0
#> 1803        0
#> 1804        0
#> 1805        0
#> 1806        0
#> 1807        0
#> 1808        0
#> 1809        0
#> 1810        0
#> 1811        0
#> 1812        0
#> 1813        0
#> 1814        0
#> 1815        0
#> 1816        0
#> 1817        0
#> 1818        0
#> 1819        0
#> 1820        0
#> 1821        0
#> 1822        0
#> 1823        0
#> 1824        0
#> 1825        0
#> 1826        0
#> 1827        0
#> 1828        0
#> 1829        0
#> 1830        0
#> 1831        0
#> 1832        0
#> 1833        0
#> 1834        0
#> 1835        0
#> 1836        0
#> 1837        0
#> 1838        0
#> 1839        0
#> 1840        0
#> 1841        0
#> 1842        0
#> 1843        0
#> 1844        0
#> 1845        0
#> 1846        0
#> 1847        0
#> 1848        0
#> 1849        0
#> 1850        0
#> 1851        0
#> 1852        0
#> 1853        0
#> 1854        0
#> 1855        0
#> 1856        0
#> 1857        0
#> 1858        0
#> 1859        0
#> 1860        0
#> 1861        0
#> 1862        0
#> 1863        0
#> 1864        0
#> 1865        0
#> 1866        0
#> 1867        0
#> 1868        0
#> 1869        0
#> 1870        0
#> 1871        0
#> 1872        0
#> 1873        0
#> 1874        0
#> 1875        0
#> 1876        0
#> 1877        0
#> 1878        0
#> 1879        0
#> 1880        0
#> 1881        0
#> 1882        0
#> 1883        0
#> 1884        0
#> 1885        0
#> 1886        0
#> 1887        0
#> 1888        0
#> 1889        0
#> 1890        0
#> 1891        0
#> 1892        0
#> 1893        0
#> 1894        0
#> 1895        0
#> 1896        0
#> 1897        0
#> 1898        0
#> 1899        0
#> 1900        0
#> 1901        0
#> 1902        0
#> 1903        0
#> 1904        0
#> 1905        0
#> 1906        0
#> 1907        0
#> 1908        0
#> 1909        0
#> 1910        0
#> 1911        0
#> 1912        0
#> 1913        0
#> 1914        0
#> 1915        0
#> 1916        0
#> 1917        0
#> 1918        0
#> 1919        0
#> 1920        0
#> 1921        0
#> 1922        0
#> 1923        0
#> 1924        0
#> 1925        0
#> 1926        0
#> 1927        0
#> 1928        0
#> 1929        0
#> 1930        0
#> 1931        0
#> 1932        0
#> 1933        0
#> 1934        0
#> 1935        0
#> 1936        0
#> 1937        0
#> 1938        0
#> 1939        0
#> 1940        0
#> 1941        0
#> 1942        0
#> 1943        0
#> 1944        0
```
