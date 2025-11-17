# Convert references csv to bib

Convert references csv to bib

## Usage

``` r
anlz_refs(path)
```

## Arguments

- path:

  chr string of path to reference csv file or data frame object

## Value

A data frame with references formatted as bib entries

## Examples

``` r
# input and format
path <- system.file('tbep-refs.csv', package = 'tbeptools')
bibs <- anlz_refs(path)

if (FALSE) { # \dontrun{
# save output
 writeLines(bibs, 'formatted.bib')
} # }
```
