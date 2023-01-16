library(shiny)

ui <- fluidPage(
  actionButton("go", "go"),
  textOutput("out")
)

server <- function(input, output, session) {
  output$out <- renderText({
    input$go
  })
}

shinyApp(ui, server)
