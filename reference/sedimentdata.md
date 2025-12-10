# Sediment data for the Tampa Bay current as of 20251210

Sediment data for the Tampa Bay current as of 20251210

## Usage

``` r
sedimentdata
```

## Format

A `data.frame` with 231727 rows and 24 variables:

- ProgramId:

  int

- ProgramName:

  chr

- FundingProject:

  chr

- yr:

  int

- AreaAbbr:

  chr

- StationID:

  int

- StationNumber:

  chr

- Latitude:

  num

- Longitude:

  num

- Replicate:

  chr

- SedResultsType:

  chr

- Parameter:

  chr

- ValueAdjusted:

  num

- Units:

  chr

- Qualifier:

  chr

- MDLnum:

  num

- PQLnum:

  num

- TEL:

  num

- PEL:

  num

- BetweenTELPEL:

  chr

- ExceedsPEL:

  chr

- PreparationDate:

  chr

- AnalysisTimeMerge:

  chr

- PELGrade:

  Factor

## Examples

``` r
if (FALSE) { # \dontrun{
# location to download data
path <- '~/Desktop/sediment.zip'

# load and assign to object
sedimentdata <- read_importsediment(path, download_latest = TRUE, remove = TRUE)

save(sedimentdata, file = 'data/sedimentdata.RData', compress = 'xz')

} # }
```
