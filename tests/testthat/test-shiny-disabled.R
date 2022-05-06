testthat::skip_on_cran()

library(shiny)
library(shinytest2)

ui_shinyjs <- fluidPage(
  useShinyjs(),
  disabled(
    textInput("text1", "text1", "text1"),
    fileInput("file1", "file1"),
  )
)
ui_no_shinyjs <- fluidPage(
  disabled(
    textInput("text1", "text1", "text1"),
    fileInput("file1", "file1"),
  )
)
get_app <- function(ui) shinyApp(ui, function(input, output) {})

test_that("{shinytest2} disabled elements get disabled class", {
  app_shinyjs <- AppDriver$new(get_app(ui_shinyjs))
  expect_true(app_shinyjs$get_js('$("#text1").hasClass("disabled")'))
  expect_true(app_shinyjs$get_js('$("#file1").closest(".btn-file").hasClass("disabled")'))

  app_no_shinyjs <- AppDriver$new(get_app(ui_no_shinyjs))
  expect_false(app_no_shinyjs$get_js('$("#text1").hasClass("disabled")'))
  expect_false(app_no_shinyjs$get_js('$("#file1").closest(".btn-file").hasClass("disabled")'))
})
