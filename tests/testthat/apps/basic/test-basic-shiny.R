library(shiny)

test_that("basic app works", {
  driver <- shinytest2::AppDriver$new(".", expect_values_screenshot_args = FALSE)
  driver$wait_for_js("$('#disabled').is(':disabled')")
  expect_true(driver$get_js("$('#mydiv').is(':visible')"))
  driver$click("toggle")
  driver$wait_for_js("!$('#mydiv').is(':visible')")
  driver$click("toggle")
  driver$wait_for_js("$('#mydiv').is(':visible')")
})
