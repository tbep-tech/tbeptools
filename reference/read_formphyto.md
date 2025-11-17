# Format phytoplankton data

Format phytoplankton data

## Usage

``` r
read_formphyto(datin)
```

## Arguments

- datin:

  input `data.frame` loaded from
  [`read_importphyto`](https://tbep-tech.github.io/tbeptools/reference/read_importphyto.md)

## Value

A formatted `data.frame` with phytoplankton count data

## Details

Only seven taxonomic groups are summarized. Pyrodinium bahamense,
Karenia brevis, Tripos hircus, Pseudo-nitzschia sp., and
Pseudo-nitzschia pungens are retained at the species level. Diatoms are
summarized at the class level using Bacillariophyceae,
Coscinodiscophyceae, and Mediophyceae and Cyanobacteria are summarized
at the phylum level using Cyanobacteriota. All other taxa are grouped
into an "other" category.

## See also

[`read_importphyto`](https://tbep-tech.github.io/tbeptools/reference/read_importphyto.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# file path
xlsx <- '~/Desktop/phyto_data.xlsx'

# load and assign to object
phytodata <- read_importphyto(xlsx, download_latest = TRUE)
} # }
```
