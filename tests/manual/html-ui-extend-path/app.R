library(shiny)
library(shinyjs)

server <- function(input, output) {
  addResourcePath("assets", system.file("tests", package = "shinyjs"))

  insertUI("head", "beforeEnd", immediate = TRUE, ui = useShinyjs())
  insertUI("head", "beforeEnd", immediate = TRUE, ui = extendShinyjs(script = "assets/pagecol.js", functions = "pageCol"))

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

shinyApp(ui = htmlTemplate("www/index.html"), server)
