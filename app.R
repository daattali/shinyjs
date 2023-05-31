library(shiny)

ui <-htmlTemplate("template.html",
             button = shinyjs::useShinyjs(),
             slider = sliderInput("x", "X", 1, 100, 50)
)



server <- function(input, output, session) {
#observeEvent(input$action, shinyjs::toggleState("x"))
}

shinyApp(ui, server)
