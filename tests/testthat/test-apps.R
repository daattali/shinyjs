testthat::skip_on_cran()

library(shinytest2)

lapply(list.files("apps", full.names = TRUE), function(folder) {
  #shinytest2::test_app(folder)
})
