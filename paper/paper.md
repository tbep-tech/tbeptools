---
title: 'tbeptools: An R package for synthesizing estuarine data for environmental research'
tags:
  - R
  - estuary
  - Tampa Bay
  - water quality
  - reporting
authors:
  - name: Marcus W. Beck^[Corresponding author]
    orcid: 0000-0002-4996-0059
    affiliation: 1 
  - name: Meagan N. Schrandt
    orcid: 0000-0002-0482-5072
    affiliation: 2
  - name: Michael R. Wessel
    affiliation: 3
  - name: Edward T. Sherwood
    orcid: 0000-0001-5330-302X
    affiliation: 1
  - name: Gary E. Raulerson
    orcid: 0000-0002-5920-5743
    affiliation: 1  
  - name: Adhokshaja Achar Budihal Prasad
    affiliation: 4
  - name: Benjamin D. Best
    orcid: 0000-0002-2686-0784
    affiliation: 5
affiliations:
  - name: Tampa Bay Estuary Program, St. Petersburg, Florida, USA
    index: 1
  - name: Fish and Wildlife Research Institute, Florida Fish and Wildlife Conservation Commission, St. Petersburg, Florida, USA
    index: 2
  - name: Janicki Environmental, Inc., St. Petersburg, Florida, USA
    index: 3
  - name: University of South Florida, Tampa, Florida, USA
    index: 4
  - name: EcoQuants, LLC, Santa Barbara, California, USA
    index: 5
date: 27 April 2021
bibliography: paper.bib
output: rticles::joss_article
csl: apa.csl
journal: JOSS
---



# Summary

Many environmental programs report on the status and trends of natural resources to inform management decisions for protecting or restoring environmental condition.  The National Estuary Program (NEP) in the United States is one example of a resource management institution focused on "estuaries of national significance" that provides place-based solutions to managing coastal resources.  There are 28 NEPs in the United States, each with similar but location-specific programmatic goals to address environmental challenges related to water quality, alteration of hydrologic flows, invasive species, climate change,  declines in fish and wildlife populations, pathogens and other contaminants, and stormwater management.  A critical need of each NEP is the synthesis of data from disparate sources that can inform management response to address these environmental challenges. 

The Tampa Bay Estuary Program (TBEP) in Florida, USA is responsible for developing and implementing a place-based plan to sustain historical and future progress in the restoration of Tampa Bay [@tbep1017].  The needs of TBEP for reporting on indicators of environmental condition are similar to other environmental organizations.  Multiple local and regional partners collect data that are used for different reporting products.  Without data synthesis tools that are transparent, accessible, and reproducible, NEP staff and colleagues waste time and resources compiling information by hand.  The `tbeptools` R software package can be used for routine development of reporting products, allowing for more efficient use of limited resources and a more effective approach to communicate research to environmental decision-makers. Functions in `tbeptools` also support the creation of content for interactive, online dashboards that can facilitate more informed decisions without requiring an intimate understanding of the R programming language or the methods for analysis.       

The `tbeptools` package also addresses challenges associated with data retrieval and assessment of environmental data relative to important policy or management targets.  For each environmental indicator, functions are included to import required data directly from sources, removing the need to manually obtain information prior to reporting.  These functions are integrated into summary report cards that are generated automatically through continuous integration services (i.e., [GitHub Actions](https://github.com/features/actions)) that free the analyst from external downloads, analysis, and copying of results that can introduce errors in reporting.  Similar packages provide seamless access to database services [e.g., `dataRetrieval`, @DeCicco21], but few packages link these data sources directly to analysis and reporting as in `tbeptools` [but see `wqindex`, @Thorley18].  Management targets and regulatory thresholds based on summary assessmenta of data, either direct from sources or included as supplementary data in the package, are also hard-coded into the functions. 

# Statement of need

The `tbeptools` R package was developed to automate data synthesis and analysis for many of the environmental indicators for Tampa Bay, with more general application to commonly available datasets for estuaries.  The functions in the package were developed to extract methods from existing technical documents and to make them available in an open source programming environment.  By making these tools available as an R package, routine assessments are now accomplished more quickly and other researchers can use the tools to develop more specific analysis pipelines.  

The function names were chosen with a typical analysis workflow in mind, where functions are available to `read` data from a source (typically from an online repository or stable URL), `anlz` to analyze the imported data using methods in existing technical documents or published papers, and to `show` the results as a summary graphic for use by environmental managers.  The functions are used to report on water quality [@Beck21b], fisheries [@Schrandt21], benthic condition [@Karlen20], tidal creeks [@Wessel21], and seagrass transect data [@Sherwood17]. The [vignettes](https://tbep-tech.github.io/tbeptools/articles/intro.html) for the package are topically organized to describe the functions that apply to each of the indicators.

The following example demonstrates use of a subset of the functions for water quality data to read a file from the Hillsborough County Environmental Protection Commission long-term monitoring dataset (available from <https://www.tampabay.wateratlas.usf.edu/>), analyze monthly and annual averages by major bay segments of Tampa Bay, and plot an annual time series for one of the bay segments.


```r
# load the package
library(tbeptools)

# read current data
wqdat <- read_importwq(xlsx = 'wqdata.xlsx', download_latest = TRUE)
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
show_thrplot(wqdat, bay_segment = 'HB', yrrng = c(1975, 2020))
```

![](paper_files/figure-latex/thrplotex-1.jpeg)<!-- --> 


Most of the NEPs do not have analysis software to operationalize data import, analysis, and plotting for reporting.  Recently, a similar software package, `peptools` [@Beck21a], was developed for the Peconic Estuary Partnership (New York, USA) using many of the functions in `tbeptools` to develop reporting products for a new water quality monitoring program.  This successful technology transfer demonstrates the added value of presenting these methods in an open source environment available for discovery and reuse by others.  We expect other NEPs to begin using these tools as their application becomes more widespread among estuarine researchers.

Beyond the NEPs, `tbeptools` is an effective example of an R package for implementing technical methods in existing literature and reports that can be used to support environmental monitoring and assessment needs for science-based decisions.  To this end, the `tbeptools` package was also created to support the development of online dashboards created in R Shiny [@Chang21].  Dashboards are powerful tools to increase accessibility for end users to engage with scientific products without the need to understand technical details in their creation.  However, providing the underlying methods as source code in an R package increases transparency and reproducibility of reporting products if users require a more detailed understanding of how the content was created.  Currently, the `tbeptools` package supports dashboards created by TBEP for the assessment of [water quality](https://shiny.tbeptech.org/wq-dash/) [Figure \ref{fig:dashex}, @Beck20a], [seagrasses](https://shiny.tbep.org/seagrasstransect-dash/) [@Beck20b], [nekton communities](http://shiny.tbeptech.org/nekton-dash) [@Beck20c], and [tidal creeks](https://shiny.tbep.org/tidalcreek-dash/) [@Beck20d].  Resource management agencies or similar institutions could follow this approach to facilitate development of front-end products for more informed decision-making. 

![The TBEP water quality dashboard, demonstrating use of the `tbeptools` R package to generate summary plots for specific bay segments.\label{fig:dashex}](paper_files/figure-latex/dashex.JPG){width='100%'}

# Acknowledgements

We acknowledge our many local and regional partners for their continuing collaborative efforts in working towards a healthy Tampa Bay, in particular the [Tampa Bay Nitrogen Management Consortium](https://tbep.org/our-work/boards-committees/nitrogen-management-consortium/). The `tbeptools` software would not be possible without data provided by our partners. 

# References
