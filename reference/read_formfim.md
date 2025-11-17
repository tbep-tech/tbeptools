# Format FIM data for the Tampa Bay Nekton Index

Format FIM data for the Tampa Bay Nekton Index

## Usage

``` r
read_formfim(datin, locs = FALSE)
```

## Arguments

- datin:

  input `data.frame` loaded from
  [`read_importfim`](https://tbep-tech.github.io/tbeptools/reference/read_importfim.md)

- locs:

  logical indicating if a spatial features object is returned with
  locations of each FIM sampling station

## Value

A formatted `data.frame` with FIM data if `locs = FALSE`, otherwise a
simple features object if `locs = TRUE`

## Details

Function is used internally within
[`read_importfim`](https://tbep-tech.github.io/tbeptools/reference/read_importfim.md)

## See also

[`read_importfim`](https://tbep-tech.github.io/tbeptools/reference/read_importfim.md)

## Examples

``` r
# file path
url <- 'https://raw.githubusercontent.com/tbep-tech/tbni-proc/master/data/'
fl <- 'TampaBay_NektonIndexData.csv'
csv <- url(paste0(url, fl))

datin <- read.csv(csv)

# load and assign to object
fimdata <- read_formfim(datin)
#> Warning: attribute variables are assumed to be spatially constant throughout all geometries
```
