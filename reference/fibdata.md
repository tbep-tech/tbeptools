# All Fecal Indicator Bacteria (FIB) data as of 20250321

All Fecal Indicator Bacteria (FIB) data as of 20250321

## Usage

``` r
fibdata
```

## Format

A data frame with 29323 rows and 18 variables:

- area:

  chr

- epchc_station:

  num

- class:

  chr

- SampleTime:

  POSIXct

- yr:

  num

- mo:

  num

- Latitude:

  num

- Longitude:

  num

- Total_Depth_m:

  num

- Sample_Depth_m:

  num

- ecoli:

  num

- ecoli_q:

  chr

- entero:

  num

- entero_q:

  chr

- fcolif:

  num

- fcolif_q:

  chr

- totcol:

  num

- totcol_q:

  chr

## Details

This dataset includes FIB data from the Environmental Protection
Commission where station class is marine (3M, 2) and Enterococcus data
is present or the station class is freshwater (3F, 1) and E. coli data
is present. The data is formatted from the raw data loaded from
[`read_importfib`](https://tbep-tech.github.io/tbeptools/reference/read_importfib.md).

## Examples

``` r
if (FALSE) { # \dontrun{
xlsx <- tempfile(fileext = '.xlsx')
fibdata <- read_importfib(xlsx, download_latest = TRUE)

nrow(fibdata)
ncol(fibdata)

save(fibdata, file = 'data/fibdata.RData')

file.remove(xlsx)
} # }
```
