# Bay segment targets

Bay segment specific management targets including low and high magnitude
exceedance thresholds

## Usage

``` r
targets
```

## Format

A data frame with 4 rows and 8 variables:

- bay_segment:

  chr

- name:

  chr

- chla_target:

  num

- chla_smallex:

  num

- chla_thresh:

  num

- la_target:

  num

- la_smallex:

  num

- la_thresh:

  num

## Examples

``` r
if (FALSE) { # \dontrun{

targets <- structure(list(
   bay_segment = c("OTB", "HB", "MTB", "LTB", "BCBN", "BCBS", "TCB", "MR", "RALTB"),
   name = c("Old Tampa Bay", "Hillsborough Bay", "Middle Tampa Bay", "Lower Tampa Bay",
      "Boca Ciega Bay North", "Boca Ciega Bay South", "Terra Ceia Bay", "Manatee River",
      "Remainder Lower Tampa Bay"),
   chla_target = c(8.5, 13.2, 7.4, 4.6, 7.7, 6.1, 7.5, 7.3, NaN),
   chla_smallex = c(8.9, 14.1, 7.9, 4.8, NaN, NaN, NaN, NaN, NaN),
   chla_thresh = c(9.3, 15, 8.5, 5.1, 8.3, 6.3, 8.7, 8.8, 5.1),
   la_target = c(0.83, 1.58, 0.83, 0.63, NaN, NaN, NaN, NaN, NaN),
   la_smallex = c(0.86, 1.63, 0.87, 0.66, NaN, NaN, NaN, NaN, NaN),
   la_thresh = c(0.88, 1.67, 0.91, 0.68, NaN, NaN, NaN, NaN, NaN)),
   class = "data.frame", row.names = c(NA, -9L)
   )

save(targets, file = 'data/targets.RData')
} # }
```
