# Seagrass transect data for Tampa Bay current as of 12052025

Seagrass transect data for Tampa Bay current as of 12052025

## Usage

``` r
transect
```

## Format

A data frame with 164724 rows and 11 variables:

- Crew:

  chr

- MonitoringAgency:

  chr

- Date:

  Date

- Transect:

  chr

- Site:

  chr

- Depth:

  int

- Savspecies:

  chr

- SeagrassEdge:

  num

- var:

  chr

- aveval:

  num

- sdval:

  num

## Examples

``` r
if (FALSE) { # \dontrun{

transect <- read_transect()

save(transect, file = 'data/transect.RData', compress = 'xz')

} # }
```
