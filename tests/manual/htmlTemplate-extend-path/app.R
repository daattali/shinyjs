library(shiny)
library(shinyjs)

addResourcePath("assets", system.file("tests", package = "shinyjs"))

ui <- htmlTemplate(
  "template.html",
  script = "assets/pagecol.js",
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
