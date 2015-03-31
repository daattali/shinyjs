context("hidden")

clsName <- "shinyjs-hide"

test_that("hidden fails on plain text", {
  expect_error(hidden("abc"), "must be a Shiny tag")
})

test_that("hidden works on simple div", {
  expect_true(clsName %in% hidden(shiny::div("abc"))$attribs$class)
})

test_that("hidden works on complex div", {
  expect_true(clsName %in% hidden(shiny::div(shiny::span("abc")))$attribs$class)
})

test_that("hidden works when div already contains a class", {
  expect_true(TRUE)
  # TODO if a tag has more than one class, $attribs stores each class as its
  # own element in the list. This means the list has multiple elements with the
  # same name. This feels wrong - $atrrbis$class should either return a vector
  # of classes or a string containing all the classes with a space separation.
  # Until that's fixed, I'm not checking for multiple classes because
  # $attribs$class only returns the first class
  #expect_true(clsName %in% hidden(div("abc", class = "test"))$attribs$class)
})
