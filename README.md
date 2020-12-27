
# pkgnews: Retrieve R Package News Files

<!-- badges: start -->
[![CRAN status](https:e//www.r-pkg.org/badges/version/pkgnews)](https://CRAN.R-project.org/package=pkgnews)
[![R build status](https://github.com/owenjonesuob/pkgnews/workflows/R-CMD-check/badge.svg)](https://github.com/owenjonesuob/pkgnews/actions)
[![Codecov test coverage](https://codecov.io/gh/owenjonesuob/pkgnews/branch/master/graph/badge.svg)](https://codecov.io/gh/owenjonesuob/pkgnews?branch=master)
<!-- badges: end -->

Read R package news files, regardless of whether or not the package is currently installed, into your R session as a character vector.


## Installation

You can install the released version from CRAN using:

```r
install.packages("pkgnews")
```


Alternatively, you can install the latest version from GitHub using:

```r
remotes::install_github("owenjonesuob/pkgnews")
```


## Usage

The package only contains one exported function, [`news()`](R/news.R), which can be used to retrieve the news for a specified package:

```r
library(pkgnews)
news("news")
```

Note that the package doesn't need to be installed - though an internet connection must be available if that's the case.

`news()` checks for an installed copy of the package, followed by valid locations for the NEWS (or ChangeLog, if `allow_changelog = TRUE`) file on CRAN and Bioconductor.
