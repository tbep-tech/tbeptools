# Get annual averages of seagrass frequency occurrence by bay segments, year, and species

Get annual averages of seagrass frequency occurrence by bay segments,
year, and species

## Usage

``` r
anlz_transectavespp(
  transectocc,
  bay_segment = c("OTB", "HB", "MTB", "LTB", "BCB"),
  yrrng = c(1998, 2025),
  species = c("Halodule", "Syringodium", "Thalassia", "Ruppia", "Halophila", "Caulerpa",
    "Dapis", "Chaetomorpha"),
  total = TRUE,
  by_seg = FALSE
)
```

## Arguments

- transectocc:

  data frame returned by
  [`anlz_transectocc`](https://tbep-tech.github.io/tbeptools/reference/anlz_transectocc.md)

- bay_segment:

  chr string for the bay segment, one to many of "OTB", "HB", "MTB",
  "LTB", "BCB"

- yrrng:

  numeric indicating year ranges to evaluate

- species:

  chr string of species to summarize, one to many of "Halodule",
  "Syringodium", "Thalassia", "Ruppia", "Halophila", "Caulerpa",
  "Dapis", "Chaetomorpha"

- total:

  logical indicating if total frequency occurrence for all species is
  also returned

- by_seg:

  logical indicating if separate results by bay segments are retained

## Value

A data frame of annual averages by bay segment

## Details

Frequency occurrence estimates are averaged across segments in
`bay_segment` if `by_seg = F`, i.e., separate results by location are
not returned. Results are retained by bay segment if `by_seg = T`.

## Examples

``` r
if (FALSE) { # \dontrun{
transect <- read_transect()
} # }
transectocc <- anlz_transectocc(transect)
anlz_transectavespp(transectocc)
#> # A tibble: 252 × 3
#>       yr Savspecies    foest
#>    <dbl> <fct>         <dbl>
#>  1  1998 Caulerpa     0.0166
#>  2  1998 Chaetomorpha 0     
#>  3  1998 Dapis        0     
#>  4  1998 Halodule     0.361 
#>  5  1998 Halophila    0     
#>  6  1998 Ruppia       0.0112
#>  7  1998 Syringodium  0.0451
#>  8  1998 Thalassia    0.254 
#>  9  1998 total        0.580 
#> 10  1999 Caulerpa     0.0277
#> # ℹ 242 more rows
```
