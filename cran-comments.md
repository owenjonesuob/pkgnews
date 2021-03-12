## Test environments

* local R installation (Fedora 33), R 4.0.3
* GitHub Actions (https://github.com/owenjonesuob/pkgnews/actions)
* R-hub (via `devtools::check_rhub()` with default platforms)
* winbuilder (via `devtools::check_win_devel()`)


## R CMD check results

0 errors | 0 warnings | 1 note

* Package was archived on CRAN
  CRAN repository db overrides:
    X-CRAN-Comment: Archived on 2021-02-10 as check problems were not
      corrected in time.

Several failing unit tests have now been remedied.
