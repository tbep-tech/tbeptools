# Download latest file from epchc.org

Download latest file from epchc.org

## Usage

``` r
read_dlcurrent(locin, download_latest = TRUE, urlin)
```

## Arguments

- locin:

  chr string path for local file, to overwrite it not current

- download_latest:

  logical to download latest file regardless of local copy

- urlin:

  url for file location

## Value

The local copy specified in the path by `locin` is overwritten by the
new file is not current or `download_latest = TRUE`. The function does
nothing if `download_latest = FALSE`.

## Details

The local copy is checked against a temporary file downloaded from the
location specified by `urlin`. The local file is replaced with the
downloaded file if the MD5 hashes are different.

## Examples

``` r
if (FALSE) { # \dontrun{
locin <- '~/Desktop/RWMDataSpreadsheet_ThroughCurrentReportMonth.xlsx'
urlin1 <- 'https://epcbocc.sharepoint.com/:x:/s/Share/'
urlin2 <- 'EYXZ5t16UlFGk1rzIU91VogBa8U37lh8z_Hftf2KJISSHg?e=8r1SUL'
urlin <- paste0(urlin1, urlin2, '&download=1')
read_dlcurrent(locin = locin, urlin = urlin)
} # }
```
