# Create a bay segment assessment table for the 2022-2026 reasonable assurance period

Create a bay segment assessment table for the 2022-2026 reasonable
assurance period

## Usage

``` r
show_ratab(
  epcdata,
  yrsel,
  bay_segment = c("OTB", "HB", "MTB", "LTB", "RALTB"),
  partialyr = F,
  outtxt1 = NULL,
  outtxt2 = NULL,
  outtxt3 = NULL,
  outtxt45 = NULL,
  txtsz = 13,
  width = NULL
)
```

## Arguments

- epcdata:

  data frame of epc data returned by
  [`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

- yrsel:

  numeric indicating chosen year

- bay_segment:

  chr string for the bay segment, one of "OTB", "HB", "MTB", "LTB",
  "RALTB"

- partialyr:

  logical indicating if incomplete annual data for the most recent year
  are approximated by five year monthly averages for each parameter

- outtxt1:

  optional text for NMC action 1, added to the outcome column

- outtxt2:

  optional text for NMC action 2, added to the outcome column

- outtxt3:

  optional text for NMC action 3, added to the outcome column

- outtxt45:

  optional text for NMC actions 4 and 5, added to the outcome column

- txtsz:

  numeric indicating font size

- width:

  optional numeric value indicating width in inches

## Value

A
[`flextable`](https://davidgohel.github.io/flextable/reference/flextable.html)
object showing the reasonable assurance compliance of the bay segment
for the selected year within the five-year period.

## Details

Choosing `bay_segment = 'RALTB'` will not work with
[`epcdata`](https://tbep-tech.github.io/tbeptools/reference/epcdata.md)
and additional data are needed to use this option.

## Examples

``` r
show_ratab(epcdata, yrsel = 2025, bay_segment = 'OTB')
#> Registered S3 method overwritten by 'ftExtra':
#>   method                  from     
#>   as_flextable.data.frame flextable


.cl-3bca3ff2{}.cl-3bc39bac{font-family:'Arial';font-size:13pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-3bc39bc0{font-family:'Arial';font-size:13pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-3bc39bca{font-family:'Arial';font-size:13pt;font-weight:normal;font-style:italic;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-3bc66cba{margin:0;text-align:center;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-3bc66cc4{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-3bc68ff6{width:2in;background-color:rgba(173, 216, 230, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3bc69000{width:0.6in;background-color:rgba(173, 216, 230, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3bc6900a{width:1.5in;background-color:rgba(173, 216, 230, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3bc6900b{width:2in;background-color:rgba(173, 216, 230, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3bc69014{width:0.6in;background-color:rgba(144, 238, 144, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3bc6901e{width:0.6in;background-color:rgba(255, 255, 255, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3bc6901f{width:1.5in;background-color:rgba(173, 216, 230, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3bc69028{width:0.6in;background-color:rgba(173, 216, 230, 1.00);vertical-align: middle;border-bottom: 1pt solid rgba(102, 102, 102, 1.00);border-top: 1pt solid rgba(102, 102, 102, 1.00);border-left: 1pt solid rgba(102, 102, 102, 1.00);border-right: 1pt solid rgba(102, 102, 102, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


Bay Segment Reasonable Assurance Assessment Steps
```
