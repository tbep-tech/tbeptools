# Format sediment data

Format sediment data

## Usage

``` r
read_formsediment(pathin)
```

## Arguments

- pathin:

  A path to unzipped csv files with sediment result tables

## Value

A `data.frame` of sediment data for Tampa Bay

## Details

Function is used internally within
[`read_importsediment`](https://tbep-tech.github.io/tbeptools/reference/read_importsediment.md)

## Examples

``` r
if (FALSE) { # \dontrun{

# location to download data
path <- '~/Desktop/sediment.zip'

# download
urlin1 <- 'https://epcbocc.sharepoint.com/:x:/s/Share/'
urlin2 <- 'Ef9utuKCHD9LliarsOPKCJwB5kxgCObf0tY5x5wX20JQUA?e=DuTseb'
urlin <- paste0(urlin1, urlin2, '&download=1')
read_dlcurrent(path, download_latest = TRUE, urlin = urlin)

# unzip
tmppth <- tempfile()
utils::unzip(path, exdir = tmppth, overwrite = TRUE)

# format sediment data
read_formsediment(pathin = tmppth)

# remove temporary path
unlink(tmppth, recursive = TRUE)

} # }
```
