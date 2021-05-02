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
  - name: Ben D. Best
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

The Tampa Bay Estuary Program (TBEP) in Florida, USA is responsible for developing and implementing a place-based plan to sustain historical and future progress in the restoration of Tampa Bay [@tbep1017].  The needs of TBEP for reporting on indicators of environmental condition are similar to other environmental organizations.  Multiple local and regional partners collect data that are used for different reporting products.  Without data synthesis tools that are transparent, accessible, and reproducible, NEP staff and colleagues waste time and resources compiling information by hand.  The `tbeptools` R software package can be used for routine development of reporting products, allowing for more efficient use of limited resources and a more effective approach to communicate research to environmental decision-makers.     

# Statement of need

The `tbeptools` R package was developed to automate data synthesis and analysis for many of the environmental indicators for Tampa Bay, with more general application to commonly available datasets for estuaries.  The functions in the package were developed to extract methods available in existing technical documents and to make them available in an open source programming environment.  By making these tools available as an R package, routine assessments are now accomplished more quickly and other researchers can use the tools to develop more specific analysis pipelines.  

The function names were chosen with a typical analysis workflow in mind, where functions are available to `read` data from a source (typically from an online repository), `anlz` to analyze the imported data using methods in existing technical documents or published papers, and to `show` the results as a summary graphic for use by environmental managers.  The functions are used to report on water quality [@Beck21b], fisheries [@Schrandt21], benthic condition [@Karlen20], tidal creeks [@Wessel21], and seagrass transect data [@Sherwood17]. The [vignettes](https://tbep-tech.github.io/tbeptools/articles/intro.html) for the package are topically organized to describe the functions that apply to each of the indicators.

Most of the NEPs do not have analysis software to operationalize data import, analysis, and plotting for reporting.  Recently, a similar software package, `peptools` [@Beck21a], was developed for the Peconic Estuary Partnership (New York, USA) using many of the functions in `tbeptools` to develop reporting products for a new water quality monitoring program.  This successful technology transfer demonstrates the added value of presenting these methods in an open source environment available for discovery and reuse by others.  We expect other NEPs to begin using these tools as their application becomes more widespread among estuarine researchers.

# Acknowledgements

We acknowledge our many local and regional partners for their continuing collaborative efforts in working towards a healthy Tampa Bay, in particular the [Tampa Bay Nitrogen Management Consortium](https://tbep.org/our-work/boards-committees/nitrogen-management-consortium/). The `tbeptools` software would not be possible without data provided by our partners. 

# References
