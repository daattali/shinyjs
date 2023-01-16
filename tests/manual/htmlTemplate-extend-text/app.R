library(shiny)
library(shinyjs)

ui <- htmlTemplate(
  "template.html",
  jscode = "shinyjs.pageCol = function(params) { $('body').css('background', params); }",
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

  observeEvent(input$col, {
    js$pageCol(input$col)
  })
}

shinyApp(ui, server)
