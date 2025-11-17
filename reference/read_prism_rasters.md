# Read PRISM raster layers into data frame

Scan directory for rasters (\*.tif) and parse PRISM layer names into
columns of a data frame.

## Usage

``` r
read_prism_rasters(dir_tif)
```

## Arguments

- dir_tif:

  directory path PRISM daily rasters were downloaded and cropped using
  [`read_importprism()`](https://tbep-tech.github.io/tbeptools/reference/read_importprism.md).

## Value

A data frame with columns for:

- `path_tif` path to GeoTIFF

- `lyr` layer name

- `date` date of modeled weather data

- `md` month-day

- `variable` variable of modeled weather data

- `version` version (1-8)

- `date_updated` date the model was updated

## Details

Any existing rasters in `dir_tif` are scanned based on a common naming
structure for the raster file name (`prism_daily_{month}-{day}.tif`) and
layer names (`{date}_{variable}_v{version}-{date_updated}`) into a data
frame.

For more on the [Parameter-elevation Relationship on Independent Slopes
Model (PRISM)](https://prism.oregonstate.edu/), see
[`read_importprism()`](https://tbep-tech.github.io/tbeptools/reference/read_importprism.md).

## Examples

``` r
dir_tif <- system.file("prism", package = "tbeptools")
read_prism_rasters(dir_tif)
#> # A tibble: 10 × 7
#>    path_tif                 lyr   date       md    variable version date_updated
#>    <chr>                    <chr> <date>     <chr> <chr>      <int> <date>      
#>  1 /home/runner/work/_temp… 1981… 1981-01-01 01-01 ppt            8 1981-07-21  
#>  2 /home/runner/work/_temp… 1981… 1981-01-01 01-01 pptytd         8 1981-07-21  
#>  3 /home/runner/work/_temp… 1981… 1981-01-01 01-01 tdmean         8 1981-07-21  
#>  4 /home/runner/work/_temp… 1981… 1981-01-01 01-01 tmax           8 1981-07-21  
#>  5 /home/runner/work/_temp… 1981… 1981-01-01 01-01 tmin           8 1981-07-21  
#>  6 /home/runner/work/_temp… 1981… 1981-01-02 01-02 ppt            8 1981-07-21  
#>  7 /home/runner/work/_temp… 1981… 1981-01-02 01-02 pptytd         8 1981-07-21  
#>  8 /home/runner/work/_temp… 1981… 1981-01-02 01-02 tdmean         8 1981-07-21  
#>  9 /home/runner/work/_temp… 1981… 1981-01-02 01-02 tmax           8 1981-07-21  
#> 10 /home/runner/work/_temp… 1981… 1981-01-02 01-02 tmin           8 1981-07-21  
```
