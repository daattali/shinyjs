library(shiny)
library(shinyjs)

server <- function(input, output) {
  dep <- htmltools::htmlDependency(
    name = "test",
    version = "1.0",
    package = "shinyjs",
    src = "tests",
    script = "pagecol.js"
  )

  insertUI("head", "beforeEnd", immediate = TRUE, ui = useShinyjs())
  insertUI("head", "beforeEnd", immediate = TRUE, ui = extendShinyjs(script = dep, functions = "pageCol"))

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
