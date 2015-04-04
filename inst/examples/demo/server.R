library(shiny)
library(shinyjs)

source("helpers.R")

shinyServer(function(input, output, session) {

  output$helpText <- renderUI({
    p(
      strong(names(helpText[helpTextMap[as.numeric(input$expr)]])),
      as.character(helpText[helpTextMap[as.numeric(input$expr)]])
    )
  })

  observe({
    if (input$submitExpr == 0) {
      return()
    }

    isolate(
      eval(parse(text = examples[as.numeric(input$expr)]))
    )
  })
})
