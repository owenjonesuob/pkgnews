#' Read package news
#'
#' Retrieve the NEWS file of a package as a character vector.
#'
#' @param package Character string giving the name of an R package.
#' @param installed_only Only check installed packages.
#' @param allow_changelog Whether to try and find a ChangeLog file if the
#'   NEWS can't be found.
#' @param width An optional positive integer - see [base::strwrap()].
#'
#' @return A character vector containing the contents of the package's NEWS file
#'   (or possibly the ChangeLog file, if `allow_changelog = TRUE`). An error is
#'   thrown if no news could be found.
#'
#' @examples news("news")
#'
#' @export

news <- function(package, installed_only = FALSE, allow_changelog = TRUE, width = NULL) {

  if (installed_only) return(news_installed(package))

  # If we haven't stopped already, try each method in turn - move on if it fails
  for (f in c(news_installed, news_cran, news_bioc))
    tryCatch(
      return(f(package, allow_changelog = allow_changelog, width = width)),
      error = function(e) NULL
    )

  # If none of those worked, then we didn't manage to find a news file :(
  stop(sprintf("No news found for package '%s'", package))
}




news_installed <- function(package, allow_changelog = NULL, width = NULL) {

  n <- utils::news(package = package)

  if (is.null(n)) stop(sprintf("No news database entry found for '%s' - perhaps try again with `installed_only = FALSE`?", package))

  strwrap(utils::capture.output(print(n, doBrowse = FALSE)), width = if (!is.null(width)) width else Inf)
}





news_cran <- function(package, allow_changelog = TRUE, width = NULL) {

  requireNamespace("httr", quietly = TRUE)

  # There are a few different places that a CRAN news file can live!
  urls <- paste0(
    sprintf("https://cran.r-project.org/web/packages/%s/", package),
    c(
      "news.html",
      "news/news.html",
      "NEWS",
      if (allow_changelog) "ChangeLog"
    )
  )


  # Return the first one which works
  for (url in urls) {

    status <- httr::status_code(httr::GET(url))

    if (status == 200L) return(

      if (grepl("\\.html$", url)) {

        if (!nzchar(Sys.which("pandoc")))
          stop("'pandoc' is used to convert HTML files to markdown, and must be available on your PATH")

        system2(
          "pandoc",
          c(url, "-t markdown", if (is.null(width)) "--wrap none" else c("--columns", width)),
          stdout = TRUE
        )

      } else
        strwrap(readLines(url, warn = FALSE), width = if (!is.null(width)) width else Inf)
    )
  }


  # If we got this far, we failed!
  stop(sprintf("No CRAN news page found for '%s'", package))
}



news_bioc <- function(package, allow_changelog = TRUE, width = NULL) {

  requireNamespace("httr", quietly = TRUE)

  # Fewer options than for CRAN
  urls <- sprintf(c(
    "https://www.bioconductor.org/packages/release/bioc/news/%s/NEWS"
  ), package)


  for (url in urls) {
    status <- httr::status_code(httr::GET(url))

    if (status == 200L) return(
      strwrap(readLines(url, warn = FALSE), width = if (!is.null(width)) width else Inf)
    )
  }

  # If we got this far, we didn't find anything
  stop(sprintf("No Bioconductor news page found for '%s'", package))
}
