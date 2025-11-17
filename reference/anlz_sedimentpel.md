# Get sediment PEL ratios at stations in Tampa Bay

Get sediment PEL ratios at stations in Tampa Bay

## Usage

``` r
anlz_sedimentpel(
  sedimentdata,
  yrrng = c(1993, 2023),
  bay_segment = c("HB", "OTB", "MTB", "LTB", "TCB", "MR", "BCB"),
  funding_proj = "TBEP"
)
```

## Arguments

- sedimentdata:

  input sediment `data.frame` as returned by
  [`read_importsediment`](https://tbep-tech.github.io/tbeptools/reference/read_importsediment.md)

- yrrng:

  numeric vector indicating min, max years to include, use single year
  for one year of data

- bay_segment:

  chr string for the bay segment, one to many of "HB", "OTB", "MTB",
  "LTB", "TCB", "MR", "BCB"

- funding_proj:

  chr string for the funding project, one to many of "TBEP" (default),
  "TBEP-Special", "Apollo Beach", "Janicki Contract", "Rivers", "Tidal
  Streams"

## Value

A `data.frame` object with average PEL ratios and grades at each station

## Details

Average PEL ratios for all contaminants graded from A to F for benthic
stations monitored in Tampa Bay are estimated. The PEL is a measure of
how likely a contaminant is to have a toxic effect on invertebrates that
inhabit the sediment. The PEL ratio is the contaminant concentration
divided by the Potential Effects Levels (PEL) that applies to a
contaminant, if available. Higher ratios and lower grades indicate
sediment conditions that are likely unfavorable for invertebrates. The
station average combines the PEL ratios across all contaminants measured
at a station and the grade applies to the average.

The grade breaks for the PEL ratio are 0.00756, 0.02052, 0.08567, and
0.28026, with lower grades assigned to the higher breaks.

## See also

[`show_sedimentpelmap`](https://tbep-tech.github.io/tbeptools/reference/show_sedimentpelmap.md)

## Examples

``` r
anlz_sedimentpel(sedimentdata)
#> # A tibble: 2,277 × 7
#>       yr AreaAbbr StationNumber Latitude Longitude PELRatio Grade
#>    <int> <chr>    <chr>            <dbl>     <dbl>    <dbl> <fct>
#>  1  1993 HB       93HB15            27.8     -82.4  0.0157  B    
#>  2  1993 HB       93HB16            27.8     -82.5  0.0261  C    
#>  3  1993 HB       93HB23            27.9     -82.4  0.0174  B    
#>  4  1993 LTB      93LTB24           27.7     -82.6  0.0124  B    
#>  5  1993 LTB      93LTB25           27.6     -82.6  0.0189  B    
#>  6  1993 LTB      93LTB26           27.6     -82.7  0.00997 B    
#>  7  1993 LTB      93LTB27           27.6     -82.7  0.0125  B    
#>  8  1993 LTB      93LTB28           27.6     -82.7  0.0887  D    
#>  9  1993 LTB      93LTB29           27.6     -82.6  0.0350  C    
#> 10  1993 LTB      93LTB30           27.6     -82.6  0.0496  C    
#> # ℹ 2,267 more rows
```
