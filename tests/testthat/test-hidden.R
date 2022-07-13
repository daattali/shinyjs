getClasses <- function(tag) {
  unlist(strsplit(htmltools::tagGetAttribute(tag, "class"), " "))
}

clsName <- "shinyjs-hide"

test_that("hidden fails on plain text", {
  expect_error(hidden("abc"), "must have at least 1 standard tag object")
})

test_that("hidden works on simple div", {
  tag <- hidden(shiny::div("abc"))
  expect_true(clsName %in% getClasses(tag))
})

test_that("hidden works on complex div", {
  tag <- hidden(shiny::div(shiny::span("abc")))
  expect_true(clsName %in% getClasses(tag))
})

test_that("hidden works when div already contains a class", {
  tag <- hidden(shiny::div("abc", class = "test"))
  expect_true(clsName %in% getClasses(tag))
})

test_that("hidden errors when one of multiple tags is not a tag", {
  x <- hidden(shiny::p("abc"), "abc")
  expect_true(clsName %in% getClasses(x[[1]]))
  x <- hidden(list(shiny::p("abc"), "abc"))
  expect_true(clsName %in% getClasses(x[[1]]))
  x <- hidden(shiny::tagList(shiny::p("abc"), "abc"))
  expect_true(clsName %in% getClasses(x[[1]]))
})

test_that("hidden works when given multiple tags", {
  res <- hidden(shiny::p("abc"), shiny::span("abc"))
  expect_equal(length(res), 2)
  expect_true(clsName %in% getClasses(res[[1]]))
  expect_true(clsName %in% getClasses(res[[2]]))
})

test_that("hidden works when given list", {
  res <- hidden(list(shiny::p("abc"), shiny::span("abc")))
  expect_equal(length(res), 2)
  expect_true(clsName %in% getClasses(res[[1]]))
  expect_true(clsName %in% getClasses(res[[2]]))
})

test_that("hidden works when given tagList", {
  res <- hidden(shiny::tagList(shiny::p("abc"), shiny::span("abc")))
  expect_equal(length(res), 2)
  expect_true(clsName %in% getClasses(res[[1]]))
  expect_true(clsName %in% getClasses(res[[2]]))
})

test_that("hidden can accept a list with trailing comma", {
  res <- hidden(shiny::tagList(shiny::p("abc"), shiny::span("abc")),)
  expect_equal(length(res), 2)
})
