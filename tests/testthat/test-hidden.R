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

test_that("hidden can accept a list with trailing comma", {
  res <- hidden(shiny::tagList(shiny::p("abc"), shiny::span("abc")),)
  expect_equal(length(res), 2)
})

test_that("hidden on a nested element only hides the top-level element", {
  res <- hidden(shiny::div("one", shiny::div("two")))
  exp <- shiny::div("one", class = clsName, shiny::div("two"))
  expect_identical(res, exp)
})

test_that("hidden differentiates between list and tagList", {
  res_list <- hidden(list(shiny::div(), shiny::span()))
  res_tagList <- hidden(shiny::tagList(shiny::div(), shiny::span()))
  exp_list <- list(shiny::div(class = clsName), shiny::span(class = clsName))
  exp_tagList <- shiny::tagList(shiny::div(class = clsName), shiny::span(class = clsName))
  expect_false(identical(exp_list, exp_tagList))
  expect_identical(res_list, exp_list)
  expect_identical(res_tagList, exp_tagList)
})
