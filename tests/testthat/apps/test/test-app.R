library(shiny)
library(shinytest2)

test_that("test1", {
  ui <- fluidPage(
    actionButton("go", "go"),
    textOutput("out")
  )

  server <- function(input, output, session) {
    output$out <- renderText({
      input$go
    })
  }

  app <- shinyApp(ui, server)

  app <- AppDriver$new(app, name = "test1", expect_values_screenshot_args = FALSE)
  app$expect_values()
  app$click("go")
  app$expect_values()
})
