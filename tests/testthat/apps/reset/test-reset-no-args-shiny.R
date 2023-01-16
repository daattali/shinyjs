library(shiny)

test_that("{shinytest2} recording: reset() with no arguments works", {
  driver <- shinytest2::AppDriver$new(".", expect_values_screenshot_args = FALSE)
  driver$expect_values()
  driver$set_inputs(
    text = "text2",
    num = 8,
    slider = 7,
    realdate = "2009-05-14",
    radio = "e",
    radio2 = "d",
    date = "2010-05-27"
  )
  driver$set_inputs(id = "")
  driver$expect_values()
  driver$click("reset")
  driver$wait_for_idle()
  driver$expect_values()
  driver$click("reset")
  driver$wait_for_idle()
  driver$expect_values()
})
