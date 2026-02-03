# All bay data as of 20260203

All bay data as of 20260203

## Usage

``` r
epcdata
```

## Format

A data frame with 29041 rows and 26 variables:

- bay_segment:

  chr

- epchc_station:

  num

- SampleTime:

  POSIXct

- yr:

  num

- mo:

  num

- Latitude:

  num

- Longitude:

  num

- Total_Depth_m:

  num

- Sample_Depth_m:

  num

- tn:

  num

- tn_q:

  chr

- sd_m:

  num

- sd_raw_m:

  num

- sd_q:

  chr

- chla:

  num

- chla_q:

  chr

- Sal_Top_ppth:

  num

- Sal_Mid_ppth:

  num

- Sal_Bottom_ppth:

  num

- Temp_Water_Top_degC:

  num

- Temp_Water_Mid_degC:

  num

- Temp_Water_Bottom_degC:

  num

- Turbidity_JTU-NTU:

  num

- Turbidity_Q:

  num

- Color_345_F45_PCU:

  num

- Color_345_F45_Q:

  num

## Examples

``` r
if (FALSE) { # \dontrun{
xlsx <- '~/Desktop/epcdata.xlsx'
epcdata <- read_importwq(xlsx, download_latest = TRUE)

nrow(epcdata)
ncol(epcdata)

save(epcdata, file = 'data/epcdata.RData', compress = 'xz')
} # }
```
