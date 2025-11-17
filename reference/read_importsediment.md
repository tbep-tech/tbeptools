# Download and import sediment data for Tampa Bay

Download and import sediment data for Tampa Bay

## Usage

``` r
read_importsediment(path, download_latest = FALSE, remove = FALSE)
```

## Arguments

- path:

  chr string for local path where the zipped folder will be downloaded,
  must include .zip extension

- download_latest:

  logical to download latest if a more recent dataset is available

- remove:

  logical if the downloaded folder is removed after unzipping

## Value

A `data.frame` of sediment data for Tampa Bay

## Details

This function downloads and unzips a folder of results tables from
<https://epcbocc.sharepoint.com/:u:/s/Share/Ef9utuKCHD9LliarsOPKCJwB5kxgCObf0tY5x5wX20JQUA?e=DuTseb&download=1>
(viewable at
<https://epcbocc.sharepoint.com/:f:/s/Share/EtOJfziTTa9FliL1oROb9OsBRZU-nO60fu_0NRC162hHjQ?e=4gUXgJ>).

The row entries for columns `"BetweenTELPEL"` and `"ExceedsPEL"` for
rows where the `"Qualifier"` column is `"U"` or `"T"` (below detection,
not detected) are assigned `NA`, regardless of the entry in the source
data.

## Examples

``` r
if (FALSE) { # \dontrun{
# location to download data
path <- '~/Desktop/sediment.zip'

# load and assign to object
sedimentdata <- read_importsediment(path, download_latest = TRUE)

} # }
```
