context("extendShinyjs")

test_that("extendShinyjs throws error when gives a non-existent JS file", {
  file <- file.path("..", "nofile.js")
  expect_error(extendShinyjs(file), "Could not find JavaScript file")
})

test_that("extendShinyjs throws error when JS file doesn't have proper shinyjs functions", {
  file <- file.path("..", "test-nofunc.js")
  expect_error(extendShinyjs(file), "Could not find any shinyjs functions")
})

test_that("extendShinyjs throws error when gives a bad JavaScript file", {
  file <- file.path("..", "test-error.js")
  expect_error(extendShinyjs(file), "Error parsing")
})

test_that("extendShinyjs finds the correct JS functions", {
  file <- file.path("..", "test-success.js")
  extendShinyjs(file)
  expect_identical(names(js), c("increment", "noop"))
})
