library(shiny)
library(shinyjs)

source("helpers.R")

shinyServer(function(input, output, session) {
  observe({
    if (input$submitExpr == 0) {
      return()
    }

    isolate(
      eval(parse(text = examples[as.numeric(input$expr)]))
    )
  })
})
