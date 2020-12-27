test_that("installed", {

  expect_equal(
    tail(news("pkgnews", installed_only = TRUE), 1),
    "- First development release of the package."
  )

  expect_error(
    news("base", installed_only = TRUE),
    "No news database entry found for 'base' - perhaps try again with `installed_only = FALSE`?"
  )

})



test_that("web", {

  skip_if_offline()


  # This one doesn't have a NEWS file or changelog
  expect_error(
    news("mangoTraining"),
    "No news found for package 'mangoTraining'"
  )



  # Check that we can read changelog instead, if NEWS isn't available
  expect_equal(
    tail(news("abind"), 1),
    "one will be dropped."
  )

  expect_error(
    news("abind", allow_changelog = FALSE),
    "No news found for package 'abind'"
  )



  # Try a couple of Bioconductor packages
  expect_equal(
    tail(news("affy"), 1),
    "o extensive set of tests in the directory 'tests/'"
  )

  expect_equal(
    tail(news("KEGGREST"), 1),
    "o Package introduced."
  )



  # Try a few CRAN packages
  skip_if(!nzchar(Sys.which("pandoc")))

  expect_match(
    # Drop zero-length elements with Filter(), in particular the last empty line!
    tail(Filter(nzchar, news("dplyr")), 1),
    "download size from 2.8 MB to 0.5 MB.",
    fixed = TRUE
  )

  expect_equal(
    tail(Filter(nzchar, news("checkLuhn")), 1),
    "-   First release"
  )

  expect_equal(
    tail(Filter(nzchar, news("goodpractice")), 1),
    "First public release."
  )


})
