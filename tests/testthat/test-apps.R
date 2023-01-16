testthat::skip_on_cran()

lapply(list.files("apps", full.names = TRUE), function(folder) {
  testthat::test_dir(folder)
})
