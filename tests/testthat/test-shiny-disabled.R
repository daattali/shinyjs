testthat::skip_on_cran()

library(shiny)
library(shinytest2)

app <- shinyApp(
  ui = fluidPage(
    useShinyjs(),
    disabled(
      textInput("text1", "text1", "text1"),
      fileInput("file1", "file1"),
    )
  ),
  server = function(input, output) {}
)

test_that("{shinytest2} disabled elements get disabled class", {
  app <- AppDriver$new(app, name = "disabled-class")
  expect_true(app$get_js('$("#text1").hasClass("disabled")'))
  expect_true(app$get_js('$("#file1").closest(".btn-file").hasClass("disabled")'))
})
