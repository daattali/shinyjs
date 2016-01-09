library(shiny)

moduleTestUI <- function(id){

  ns <- NS(id)

  tagList(
    div(id = ns('dd'),
      textInput(ns('text'), 'text input', value = "tex"),
      colourInput(ns('col'), 'col input', value = "red"),
      actionButton(ns("btn"), "Button")
    )
  )
}


moduleTest <- function(input, output, session){
  #onclick("text", cat("fds"))
  observeEvent(input$btn,{
    #delay(1000, cat("DS"))
    reset("dd")
    #toggle(("text"))
   # updateTextInput(session, "text", value = "bar")
  })
}


ui <- fluidPage(
  useShinyjs(debug =TRUE),
  moduleTestUI('test')
)
server <- function(input, output, session) {
  callModule(moduleTest, 'test')
}
shinyApp(ui = ui, server = server)
