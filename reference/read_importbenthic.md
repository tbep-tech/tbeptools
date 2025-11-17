# Download and import benthic data for Tampa Bay

Download and import benthic data for Tampa Bay

## Usage

``` r
read_importbenthic(path, download_latest = FALSE, remove = FALSE)
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

A nested `tibble` of station, taxa, and field sample data.

## Details

This function downloads and unzips a folder of base tables used to
calculate the benthic index from
<https://epcbocc.sharepoint.com/:f:/s/Share/EtOJfziTTa9FliL1oROb9OsBRZU-nO60fu_0NRC162hHjQ?e=4gUXgJ>.

Index the corresponding list element in the `value` column to view each
dataset. For example, the stations data in the first row can be viewed
as `benthicdata$value[[1]]`.

## Examples

``` r
if (FALSE) { # \dontrun{
# location to download data
path <- '~/Desktop/benthic.zip'

# load and assign to object
benthicdata <- read_importbenthic(path, download_latest = TRUE)

} # }
```
