library(shiny)
library(shinyjs)

server <- function(input, output) {
  insertUI("head", "beforeEnd", immediate = TRUE, ui = useShinyjs())

  observeEvent(input$toggle, {
    toggle("square")
  })

  output$square <- renderText({
    input$num ^ 2
  })
}

shinyApp(ui = htmlTemplate("www/index.html"), server)
