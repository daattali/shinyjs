library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),
  extendShinyjs(
    script = htmltools::htmlDependency(
      name = "test",
      version = "1.0",
      package = "shinyjs",
      src = "tests",
      script = "pagecol.js"
    ),
    functions = c("pageCol")
  ),
  selectInput("col", "Colour:", c("red", "white", "yellow", "blue"))
)

server <- function(input, output, session) {
  observeEvent(input$col, {
    js$pageCol(input$col)
  })
}

shinyApp(ui, server)
