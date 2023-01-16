library(shiny)
library(shinyjs)

server <- function(input, output) {
  insertUI("head", "beforeEnd", immediate = TRUE, ui = useShinyjs())
  jscode <- "shinyjs.pageCol = function(params) { $('body').css('background', params); }"
  insertUI("head", "beforeEnd", immediate = TRUE, ui = extendShinyjs(text = jscode, functions = "pageCol"))

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
