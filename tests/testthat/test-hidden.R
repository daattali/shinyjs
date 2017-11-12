context("hidden")

getClasses <- function(tag) {
  unlist(strsplit(htmltools::tagGetAttribute(tag, "class"), " "))
}

clsName <- "shinyjs-hide"

test_that("hidden fails on plain text", {
  expect_error(hidden("abc"), "Invalid shiny tag")
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
  expect_error(hidden(shiny::p("abc"), "abc"), "Invalid shiny tag")
  expect_error(hidden(list(shiny::p("abc"), "abc")), "Invalid shiny tag")
  expect_error(hidden(shiny::tagList(shiny::p("abc"), "abc")), "Invalid shiny tag")
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
