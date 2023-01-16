library(shiny)
library(shinyjs)

dep <- htmltools::htmlDependency(
  name = "test",
  version = "1.0",
  package = "shinyjs",
  src = "tests",
  script = "pagecol.js"
)

ui <- htmlTemplate(
  "template.html",
  script = dep,
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
