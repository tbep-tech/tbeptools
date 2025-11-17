# Load local FIM data for the Tampa Bay Nekton Index

Load local FIM data for the Tampa Bay Nekton Index

## Usage

``` r
read_importfim(csv, download_latest = FALSE, locs = FALSE)
```

## Arguments

- csv:

  chr string path for local csv file, to overwrite if not current

- download_latest:

  logical passed to
  [`read_dlcurrent`](https://tbep-tech.github.io/tbeptools/reference/read_dlcurrent.md)
  to download raw data and compare with existing in `csv` if available

- locs:

  logical indicating if a spatial features object is returned with
  locations of each FIM sampling station

## Value

A formatted `data.frame` with FIM data if `locs = FALSE`, otherwise a
simple features object if `locs = TRUE`

## Details

Data downloaded from
ftp://ftp.floridamarine.org/users/fim/tmac/NektonIndex/TampaBay_NektonIndexData.csv.

## See also

[`read_formwq`](https://tbep-tech.github.io/tbeptools/reference/read_formwq.md),
[`read_importphyto`](https://tbep-tech.github.io/tbeptools/reference/read_importphyto.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
csv <- '~/Desktop/fimraw.csv'

# load and assign to object
fimdata <- read_importfim(csv, download_latest = TRUE)
} # }
```
