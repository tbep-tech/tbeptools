# Create reactable table from matrix data

Create reactable table from matrix data

## Usage

``` r
show_reactable(totab, colfun, nrows = 10, txtsz = 3)
```

## Arguments

- totab:

  A data frame in wide format of summarized results

- colfun:

  Function specifying how colors are treated in cell background

- nrows:

  numeric specifying number of rows in the table

- txtsz:

  numeric indicating text size in the cells, use `txtsz = NULL` to
  suppress

## Value

A
[`reactable`](https://glin.github.io/reactable/reference/reactable.html)
table

## Details

This function is used internally within
[`show_matrix`](https://tbep-tech.github.io/tbeptools/reference/show_matrix.md)
and
[`show_wqmatrix`](https://tbep-tech.github.io/tbeptools/reference/show_wqmatrix.md)

## Examples

``` r
data(targets)
data(epcdata)

library(tidyr)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# data
totab <- anlz_avedat(epcdata) %>%
  .$ann %>%
  filter(var %in% 'mean_chla') %>%
  left_join(targets, by = 'bay_segment') %>%
  select(bay_segment, yr, val, chla_thresh) %>%
  mutate(
    bay_segment = factor(bay_segment, levels = c('OTB', 'HB', 'MTB', 'LTB')),
     outcome = case_when(
      val < chla_thresh ~ 'green',
      val >= chla_thresh ~ 'red'
    )
  ) %>%
  select(bay_segment, yr, outcome) %>%
  spread(bay_segment, outcome)

# color function
colfun <- function(x){

  out <- case_when(
    x == 'red' ~ '#FF3333',
    x == 'green' ~ '#33FF3B'
  )

  return(out)

}

show_reactable(totab, colfun)

{"x":{"tag":{"name":"Reactable","attribs":{"data":{"yr":[1974,1975,1976,1977,1978,1979,1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025],"OTB":["red","red","red","red","red","red","red","red","red","red","green","red","red","red","green","red","red","green","green","green","red","red","green","green","red","green","green","green","green","red","red","green","green","green","green","red","green","red","green","green","green","red","green","red","green","red","red","red","green","green","green","green"],"HB":["red","red","red","red","red","red","red","red","red","red","green","red","red","green","green","green","green","green","green","green","red","red","green","green","red","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green"],"MTB":["red","red","red","red","red","red","red","red","red","red","red","red","green","red","green","green","green","green","green","green","red","red","green","green","red","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green"],"LTB":["green","green","green","red","green","red","red","red","red","red","green","green","green","green","green","green","green","green","green","green","red","green","green","green","red","green","green","green","green","green","green","red","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green","green"]},"columns":[{"id":"yr","name":"Year","type":"numeric","style":{"fontSize":"16px"}},{"id":"OTB","name":"OTB","type":"character","style":[{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"}]},{"id":"HB","name":"HB","type":"character","style":[{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"}]},{"id":"MTB","name":"MTB","type":"character","style":[{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"}]},{"id":"LTB","name":"LTB","type":"character","style":[{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#FF3333","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"},{"background":"#33FF3B","fontSize":"15.99px"}]}],"defaultPageSize":10,"dataKey":"f8360e40b901eec47fa75845da3c276c"},"children":[]},"class":"reactR_markup"},"evals":[],"jsHooks":[]}
```
