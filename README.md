
# tbeptools

[![R-CMD-check](https://github.com/tbep-tech/tbeptools/workflows/R-CMD-check/badge.svg)](https://github.com/tbep-tech/tbeptools/actions)
[![pkgdown](https://github.com/tbep-tech/tbeptools/workflows/pkgdown/badge.svg)](https://github.com/tbep-tech/tbeptools/actions)
[![JOSS-draft](https://github.com/tbep-tech/tbeptools/actions/workflows/draft-pdf.yaml/badge.svg)](https://github.com/tbep-tech/tbeptools/actions/workflows/draft-pdf.yaml)
[![Codecov test coverage](https://codecov.io/gh/tbep-tech/tbeptools/branch/master/graph/badge.svg)](https://codecov.io/gh/tbep-tech/tbeptools?branch=master)
[![DOI](https://zenodo.org/badge/184627857.svg)](https://zenodo.org/badge/latestdoi/184627857)

R package for Tampa Bay Estuary Program functions. Please see the [vignette](https://tbep-tech.github.io/tbeptools/articles/intro.html) for a full description.

<img src="man/figures/logo.png" align="center" width="125"/>

# Installation

The package can be installed from [r-universe](https://tbep-tech.r-universe.dev).  The source code is available on the tbep-tech GitHub group web page: <https://github.com/tbep-tech/tbeptools>.  Note that tbeptools only needs to be installed once, but it needs to be loaded every new R session (i.e., `library(tbeptools)`).

```r
install.packages('tbeptools', repos = 'https://tbep-tech/r-universe.dev')
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

# Package structure

Functions in tbeptools fall in three categories depending on mode of use.  Each function is named using a prefix for the mode of use, followed by what the function does. The prefixes are:

* `read`: Import current data from the main ftp site.

* `anlz`: Analyze or summarize the imported data. 

* `show`: Create a plot of the analyzed data.

The functions can be easily found in RStudio after loading the package and typing the prefix at the command line.  An autofill dialog box will pop up showing all functions that apply for the prefix. This eliminates the need for searching for individual functions if all you know is the category of function you need (e.g., `read`, `anlz`, or `show`).

The function [reference page](https://tbep-tech.github.io/tbeptools/reference/index.html) can also be viewed for a complete list of functions organized by category, with links to the help files. 

# Issues and suggestions

Please report any issues and suggestions on the [issues link](https://github.com/tbep-tech/tbeptools/issues) for the repository.  A guide to posting issues can be found [here](.github/ISSUE_TEMPLATE.md).

# Contributing

Please view our [contributing](.github/CONTRIBUTING.md) guidelines for any changes or pull requests.
