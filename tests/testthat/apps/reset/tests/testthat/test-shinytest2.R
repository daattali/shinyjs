library(shinytest2)

test_that("{shinytest2} recording: reset elements works", {
  app <- AppDriver$new(name = "reset-general", expect_values_screenshot_args = FALSE)
  app$expect_values()
  app$set_inputs(
    text = "text2",
    num = 8,
    slider = 7,
    realdate = "2009-05-14",
    radio = "e",
    radio2 = "d",
    date = "2010-05-27"
  )
  app$expect_values()
  app$click("reset")
  app$wait_for_idle()
  app$expect_values()
  app$set_inputs(
    slider = 6,
    num = 9,
    text = "text3",
    realdate = "2008-03-06"
  )
  app$set_inputs(id = "num")
  app$expect_values()
  app$click("reset")
  app$wait_for_idle()
  app$expect_values()
  app$set_inputs(id = "realdate")
  app$click("reset")
  app$wait_for_idle()
  app$expect_values()
})

test_that("{shinytest2} recording: reset() with no arguments works", {
  app <- AppDriver$new(name = "reset-no-args", expect_values_screenshot_args = FALSE)
  app$expect_values()
  app$set_inputs(
    text = "text2",
    num = 8,
    slider = 7,
    realdate = "2009-05-14",
    radio = "e",
    radio2 = "d",
    date = "2010-05-27"
  )
  app$set_inputs(id = "")
  app$expect_values()
  app$click("reset")
  app$wait_for_idle()
  app$expect_values()
  app$click("reset")
  app$wait_for_idle()
  app$expect_values()
})
