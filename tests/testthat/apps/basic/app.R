library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  disabled(actionButton("disabled", "this is disabled")),
  actionButton("toggle", "toggle"),
  div(id = "mydiv", "hello")
)

server <- function(input, output, session) {
  observeEvent(input$toggle, {
    toggle("mydiv")
  })
}

shinyApp(ui, server)
