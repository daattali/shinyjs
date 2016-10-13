library(shiny)
library(shinyjs)

source("helpers.R")

shinyServer(function(input, output, session) {
  # when an example is clicked, copy that expression to the input box
  lapply(names(examples), function(ex) {
    ex <- examples[ex]
    onclick(sprintf("example-%s", names(ex)),
            updateTextInput(session, "runcode_expr", value = as.character(ex)))
  })

  runcodeServer()
})
