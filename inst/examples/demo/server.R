library(shiny)
library(shinyjs)

source("helpers.R")

shinyServer(function(input, output, session) {

  # show helper text for each selected function
  output$helpText <- renderUI({
    p(
      strong(names(helpText[helpTextMap[as.numeric(input$expr)]])),
      as.character(helpText[helpTextMap[as.numeric(input$expr)]])
    )
  })

  # run the selected expression
  observe({
    if (input$submitExpr == 0) {
      return()
    }

    isolate(
      eval(parse(text = examples[as.numeric(input$expr)]))
    )
  })
})
