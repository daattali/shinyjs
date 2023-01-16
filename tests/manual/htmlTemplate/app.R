library(shiny)
library(shinyjs)

ui <- htmlTemplate(
  "template.html",
  button = actionButton("toggle", "toggle"),
  num = numericInput("num", "num", 5)
)

server <- function(input, output, session) {
  observeEvent(input$toggle, {
    toggle("square")
  })

  output$square <- renderText({
    input$num ^ 2
  })
}

shinyApp(ui, server)
