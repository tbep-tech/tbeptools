# Reference table for Tampa Bay Nekton Index species classifications

Reference table for Tampa Bay Nekton Index species classifications

## Usage

``` r
tbnispp
```

## Format

A data frame with 196 rows and 10 variables:

- TSN:

  int

- NODCCODE:

  chr

- ScientificName:

  chr

- Include_TB_Index:

  chr

- Hab_Cat:

  chr

- Est_Cat:

  chr

- Est_Use:

  chr

- Feeding_Cat:

  chr

- Feeding_Guild:

  chr

- Selected_Taxa:

  chr

## Details

See `data-raw/tbnispp-raw.R` for the script used to create the data
object, which pulls the source rds file from the
[tbni-proc](https://github.com/tbep-tech/tbni-proc) repo.

## Examples

``` r
dim(tbnispp)
#> [1] 196  10
```
