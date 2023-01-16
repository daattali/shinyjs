library(shinytest2)

test_that("test1", {
  app <- AppDriver$new(name = "test1", expect_values_screenshot_args = FALSE)
  app$expect_values()
  app$click("go")
  app$expect_values()
})
