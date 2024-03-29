library(shiny)

test_that("{shinytest2} recording: reset elements works", {
  driver <- shinytest2::AppDriver$new(".", expect_values_screenshot_args = FALSE)
  driver$expect_values()
  driver$set_inputs(
    text = "text2",
    num = 8,
    slider = 7,
    realdate = "2009-05-14",
    radio = "e",
    radio2 = "d",
    date = "2010-05-27",
    date2 = c("2010-05-20", "2010-07-16"),
    datetime = "1279274400000",
    datetime2 = c("1275292800000", "1283932800000")
  )
  driver$expect_values()
  driver$click("reset")
  driver$wait_for_idle()
  driver$expect_values()
  driver$set_inputs(
    slider = 6,
    num = 9,
    text = "text3",
    realdate = "2008-03-06"
  )
  driver$set_inputs(id = "num")
  driver$expect_values()
  driver$click("reset")
  driver$wait_for_idle()
  driver$expect_values()
  driver$set_inputs(id = "realdate")
  driver$click("reset")
  driver$wait_for_idle()
  driver$expect_values()
})
