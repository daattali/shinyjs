library(shiny)
library(shinyjs)

source("helpers.R")

shinyServer(function(input, output) {

  # show helper text for each selected function
  output$helpText <- renderUI({
    p(
      strong(names(helpText[helpTextMap[as.numeric(input$expr)]])),
      as.character(helpText[helpTextMap[as.numeric(input$expr)]])
    )
  })

  # run the selected expression
  observeEvent(input$submitExpr, {
    isolate(
      eval(parse(text = examples[as.numeric(input$expr)]))
    )
  })
})
