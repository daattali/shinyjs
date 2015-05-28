context("extendShinyjs")

# some platforms don't have V8 library available, so extendShinyjs won't
# work on them. If it's not available, don't run the tests
if (!requireNamespace("V8", quietly = TRUE)) {
  return()
}

test_that("extendShinyjs throws error when given a non-existent JS file", {
  file <- file.path("..", "nofile.js")
  expect_error(extendShinyjs(file), "Could not find JavaScript file")
})

test_that("extendShinyjs throws error when JS file doesn't have proper shinyjs functions", {
  file <- file.path("..", "test-nofunc.js")
  expect_error(extendShinyjs(file), "Could not find any shinyjs functions")
})

test_that("extendShinyjs throws error when given a bad JavaScript file", {
  file <- file.path("..", "test-error.js")
  expect_error(extendShinyjs(file), "Error parsing")
})

test_that("extendShinyjs finds the correct JS functions from script file", {
  file <- file.path("..", "test-success.js")
  extendShinyjs(file)
  expect_true(all(c("increment", "noop", "colour") %in% ls(js)))
})

test_that("extendShinyjs throws error when inline code doesn't have proper shinyjs functions", {
  code <- "sayhello = function() { alert('Hello!'); }"
  expect_error(extendShinyjs(text = code), "Could not find any shinyjs functions")
})

test_that("extendShinyjs throws error when given bad inline code", {
  code <- "sayhello = function() { alert('Hello!');"
  expect_error(extendShinyjs(text = code), "Error parsing")
})

test_that("extendShinyjs finds the correct JS functions from inline code", {
  code <- "shinyjs.sayhello = function() { alert('Hello!'); }"
  extendShinyjs(text = code)
  expect_true(all(c("sayhello") %in% ls(js)))
})

test_that("extendShinyjs finds the correct functions when both file and text are given", {
  file <- file.path("..", "test-empty.js")
  code <- "shinyjs.inline1 = function() {}; shinyjs.inline2 = function() {};"
  extendShinyjs(file, code)
  expect_true(all(c("test1", "test2", "inline1", "inline2") %in% ls(js)))
})
