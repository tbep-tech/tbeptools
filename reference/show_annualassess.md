# Create a table for the annual management outcome assessments

Create a table for the annual management outcome assessments for
chlorophyll-a and light attenuation by bay segment

## Usage

``` r
show_annualassess(
  epcdata,
  yrsel,
  partialyr = F,
  caption = F,
  family = "Arial",
  txtsz = 12,
  width = NULL
)
```

## Arguments

- epcdata:

  data frame of epc data returned by
  [`read_importwq`](https://tbep-tech.github.io/tbeptools/reference/read_importwq.md)

- yrsel:

  numeric indicating chosen year

- partialyr:

  logical indicating if incomplete annual data for the most recent year
  are approximated by five year monthly averages for each parameter

- caption:

  logical indicating if a caption is added using
  [`set_caption`](https://davidgohel.github.io/flextable/reference/set_caption.html)

- family:

  chr string indicating font family for text labels

- txtsz:

  numeric indicating font size

- width:

  optional numeric value indicating width in inches

## Value

A
[`flextable`](https://davidgohel.github.io/flextable/reference/flextable.html)
object showing the segment-averaged chlorophyll-a and light attenuation
for the selected year, with bay segment names colored by the management
outcome used in
[`show_matrix`](https://tbep-tech.github.io/tbeptools/reference/show_matrix.md).

## Examples

``` r
show_annualassess(epcdata, yrsel = 2025)


.cl-cbc11a04{}.cl-cb950586{font-family:'Arial';font-size:12pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-cb95059a{font-family:'Arial';font-size:7.2pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;vertical-align:super;}.cl-cb982a2c{margin:0;text-align:left;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-cb982a36{margin:0;text-align:center;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-cb985024{width:0.75in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-cb98502e{width:0.75in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 1.5pt solid rgba(102, 102, 102, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-cb985038{width:0.75in;background-color:rgba(45, 201, 56, 1.00);vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-cb985039{width:0.75in;background-color:transparent;vertical-align: middle;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-cb985042{width:0.75in;background-color:rgba(45, 201, 56, 1.00);vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-cb985043{width:0.75in;background-color:transparent;vertical-align: middle;border-bottom: 1.5pt solid rgba(102, 102, 102, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}



Segment
```

Chl-a (ug/L)

Light Penetration (m-1)

2025

target

2025

target

OTB

6.6

8.5

0.71

0.83

HB

10.0

13.2

0.88

1.58

MTB

5.5

7.4

0.56

0.83

LTB

3.0

4.6

0.60

0.63

show_annualassess(epcdata, yrsel = 2025, caption = TRUE)

| Segment | Chl-a (ug/L) |        | Light Penetration (m-1) |        |
|---------|--------------|--------|-------------------------|--------|
|         | 2025         | target | 2025                    | target |
| OTB     | 6.6          | 8.5    | 0.71                    | 0.83   |
| HB      | 10.0         | 13.2   | 0.88                    | 1.58   |
| MTB     | 5.5          | 7.4    | 0.56                    | 0.83   |
| LTB     | 3.0          | 4.6    | 0.60                    | 0.63   |

Water quality outcomes for 2025.
