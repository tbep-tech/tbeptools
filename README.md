
# tbeptools

[![R-CMD-check](https://github.com/tbep-tech/tbeptools/workflows/R-CMD-check/badge.svg)](https://github.com/tbep-tech/tbeptools/actions)
[![pkgdown](https://github.com/tbep-tech/tbeptools/workflows/pkgdown/badge.svg)](https://github.com/tbep-tech/tbeptools/actions)
[![DOI](https://joss.theoj.org/papers/10.21105/joss.03485/status.svg)](https://doi.org/10.21105/joss.03485)
[![Codecov test coverage](https://codecov.io/gh/tbep-tech/tbeptools/branch/master/graph/badge.svg)](https://codecov.io/gh/tbep-tech/tbeptools?branch=master)
[![DOI](https://zenodo.org/badge/184627857.svg)](https://zenodo.org/badge/latestdoi/184627857)

R package for Tampa Bay Estuary Program functions. Please see the [vignette](https://tbep-tech.github.io/tbeptools/articles/intro.html) for a full description.

<img src="man/figures/logo.png" align="center" width="125"/>

Please cite this package as follows: 

Beck, M.W., Schrandt, M.N., Wessel, M.R., Sherwood, E.T., Raulerson, G.E., Budihal Prasad, A.A., Best, B.D., (2021). tbeptools: An R package for synthesizing estuarine data for environmental research. Journal of Open Source Software, 6(65), 3485, https://doi.org/10.21105/joss.03485

# Installation

The package can be installed from [r-universe](https://tbep-tech.r-universe.dev).  The source code is available on the tbep-tech GitHub group web page: <https://github.com/tbep-tech/tbeptools>.  Note that tbeptools only needs to be installed once, but it needs to be loaded every new R session (i.e., `library(tbeptools)`).

```r
# enable repos
options(repos = c(
    tbeptech = 'https://tbep-tech.r-universe.dev',
    CRAN = 'https://cloud.r-project.org'))

# install tbeptools
install.packages('tbeptools')

# load tbeptools
library(tbeptools)
```

After the package is loaded, you can view the help files for each function by typing a question mark followed by the function name, e.g., `?read_importwq`, on the console.  The help files provide a brief description of what each function does and the required arguments that are needed to run the function.

# Package vignettes

The vignettes are organized by topic and are an excellent place to start for understanding how to use the package. Currently, there are five vignettes available for tbeptools:

* [Intro to TBEP tools](https://tbep-tech.github.io/tbeptools/articles/intro.html): A general overview of the package with specific examples of functions for working with the water quality report card
* [Tampa Bay Nekton Index](https://tbep-tech.github.io/tbeptools/articles/tbni.html): Overview of functions to import, analyze, and plot results for the Tampa Bay Nekton Index
* [Tampa Bay Benthic Index](https://tbep-tech.github.io/tbeptools/articles/tbbi.html): Overview of functions to import data for Tampa Bay Benthic Index, under development
* [Tidal Creeks Assessment](https://tbep-tech.github.io/tbeptools/articles/tidalcreeks.html): Overview of functions to import, analyze, and plot results for the assessment of tidal creeks in southwest Florida
* [Seagrass Transect Data](https://tbep-tech.github.io/tbeptools/articles/seagrasstransect.html): Overview of functions to import, analyze, and plot results for the seagrass transect data collected in Tampa Bay

# Usage

Functions in tbeptools fall in three categories depending on mode of use.  Each function is named using a prefix for the mode of use, followed by what the function does. The prefixes are:

* `read`: Import current data from the main site.

* `anlz`: Analyze or summarize the imported data. 

* `show`: Create a plot of the analyzed data.

The functions can be easily found in RStudio after loading the package and typing the prefix at the command line.  An autofill dialog box will pop up showing all functions that apply for the prefix. This eliminates the need for searching for individual functions if all you know is the category of function you need (e.g., `read`, `anlz`, or `show`).

Each function also includes a semi-descriptive suffix that generally describes what category it applies to (e.g, water quality, seagrass) and what it does (e.g., imports, formats).  These follow a loose convention that attempts to strike a balance between description and brevity.  The optimal balance is often hard to achieve.  To aid in understanding, we provide a brief description of suffixes that are used more than once.  

Suffix descriptions:

* `attain`: Analyze functions that summarize data relative to attainment categories specific to bay segments
* `ave`, `med`: Analyze functions that summarize data into averages or medians
* `benthic`: Applies to benthic monitoring data used for the Tampa Bay Benthic Index
* `fim`: Applies to data from the Fisheries Independent Monitoring program used for the Tampa Bay Nekton Index
* `form`: An intermediate function for formatting imported data for downstream analysis
* `import`: A function used to import data from a source external to the package
* `indic`: A function that analyzes or plots individual tidal creek indicator values, as opposed to integrated creek scores
* `iwr`: Functions or data that apply to the Impaired Waters Rule (IWR) data maintained by the Florida Department of Environmental Protection used as source data for the tidal creek functions
* `matrix`: A plotting function that creates a report card style matrix
* `met`: A function that analyses or plots individual metrics for integrated indices, e.g., TBBI, TBNI
* `phyto`: Applies to phytoplankton data from the Hillsborough County Environmental Protection Commission
* `plotly`: A plotting function that returns an interactive plotly object
* `scr`: A function that analyses or plots summary scores for integrated indices, e.g., TBBI, TBNI
* `seg`, `site`: Functions that analyze or plot results relative to bay segments or individual monitoring sites 
* `tbbi`: Applies to the Tampa Bay Benthic Index (TBBI)
* `tbni`: Applies to the Tampa Bay Nekton Index (TBNI)
* `tdlcrk`: Applies to tidal creeks
* `transect`: Applies to seagrass transect data
* `wq`: Applies to water quality

The function [reference page](https://tbep-tech.github.io/tbeptools/reference/index.html) can also be viewed for a complete list of functions organized by category, a description of what they do, and links to the help files. 

The following example demonstrates use of a subset of the functions for water quality data to read a file from the Hillsborough County Environmental Protection Commission long-term monitoring dataset (available from <https://www.tampabay.wateratlas.usf.edu/>), analyze monthly and annual averages by major bay segments of Tampa Bay, and plot an annual time series for one of the bay segments.

```r
# load the package
library(tbeptools)

# read current data
wqdat <- read_importwq(xlsx = "wqdata.xlsx", download_latest = TRUE)
wqdat
```

```
## # A tibble: 26,611 x 22
##   bay_segment epchc_station SampleTime             yr    mo
##   <chr>               <dbl> <dttm>              <dbl> <dbl>
## 1 HB                      6 2021-06-08 10:59:00  2021     6
## 2 HB                      7 2021-06-08 11:13:00  2021     6
## 3 HB                      8 2021-06-08 14:15:00  2021     6
## 4 MTB                     9 2021-06-08 13:14:00  2021     6
## 5 MTB                    11 2021-06-08 11:30:00  2021     6
## # ... with 26,606 more rows, and 17 more variables:
## #   Latitude <dbl>, Longitude <dbl>, Total_Depth_m <dbl>,
## #   Sample_Depth_m <dbl>, tn <dbl>, tn_q <chr>, sd_m <dbl>,
## #   sd_raw_m <dbl>, sd_q <chr>, chla <dbl>, chla_q <chr>,
## #   Sal_Top_ppth <dbl>, Sal_Mid_ppth <dbl>,
## #   Sal_Bottom_ppth <dbl>, Temp_Water_Top_degC <dbl>,
## #   Temp_Water_Mid_degC <dbl>, ...
```

```r
# analyze monthly and annual means by bay segment
avedat <- anlz_avedat(wqdat)
avedat
```

```
## $ann
## # A tibble: 584 x 4
##      yr bay_segment var         val
##   <dbl> <chr>       <chr>     <dbl>
## 1  1974 HB          mean_chla 22.4 
## 2  1974 LTB         mean_chla  4.24
## 3  1974 MTB         mean_chla  9.66
## 4  1974 OTB         mean_chla 10.2 
## 5  1975 HB          mean_chla 27.9 
## # ... with 579 more rows
## 
## $mos
## # A tibble: 4,484 x 5
##   bay_segment    yr    mo var         val
##   <chr>       <dbl> <dbl> <chr>     <dbl>
## 1 HB           1974     1 mean_chla 36.2 
## 2 LTB          1974     1 mean_chla  1.75
## 3 MTB          1974     1 mean_chla 11.5 
## 4 OTB          1974     1 mean_chla  4.4 
## 5 HB           1974     2 mean_chla 42.4 
## # ... with 4,479 more rows
```

```r
# show annual time series of chlorophyll for Hillsborough bay segment
show_thrplot(wqdat, bay_segment = "HB", yrrng = c(1975, 2020))
```

<img src="man/figures/thrplotex-1.jpeg" align="center"/>

Functions in `tbeptools` also support the creation of content for interactive, online dashboards that can facilitate more informed decisions without requiring an intimate understanding of the R programming language or the methods for analysis.  These dashboards include assessments for [water quality](https://shiny.tbeptech.org/wq-dash/), [seagrasses](https://shiny.tbep.org/seagrasstransect-dash/), [nekton communities](http://shiny.tbeptech.org/nekton-dash), and [tidal creeks](https://shiny.tbep.org/tidalcreek-dash/).

# Issues and suggestions

Please report any issues and suggestions on the [issues link](https://github.com/tbep-tech/tbeptools/issues) for the repository.  A guide to posting issues can be found [here](.github/ISSUE_TEMPLATE.md).

# Contributing

Please view our [contributing](.github/CONTRIBUTING.md) guidelines for any changes or pull requests.
