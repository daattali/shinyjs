context("hidden")

getClasses <- function(tag) {
  unlist(strsplit(tag$attribs$class, " "))
}

clsName <- "shinyjs-hide"

test_that("hidden fails on plain text", {
  expect_error(hidden("abc"), "Invalid shiny tag")
})

test_that("hidden works on simple div", {
  tag <- hidden(shiny::div("abc"))$attribs$class
  classes <- unlist(strsplit(tag, " "))
  expect_true(clsName %in% classes)
})

test_that("hidden works on complex div", {
  tag <- hidden(shiny::div(shiny::span("abc")))$attribs$class
  classes <- unlist(strsplit(tag, " "))
  expect_true(clsName %in% classes)
})

test_that("hidden works when div already contains a class", {
  expect_true(TRUE)
  # TODO if a tag has more than one class, $attribs stores each class as its
  # own element in the list. This means the list has multiple elements with the
  # same name. This feels wrong - $atrrbis$class should either return a vector
  # of classes or a string containing all the classes with a space separation.
  # Until that's fixed, I'm not checking for multiple classes because
  # $attribs$class only returns the first class
  # I sent a pull request to htmltools to fix this, still waiting for them
  # to incorporate my code
  #expect_true(clsName %in% hidden(div("abc", class = "test"))$attribs$class)
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
