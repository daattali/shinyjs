library(shiny)
library(shinyjs)

source("helpers.R")

shinyServer(function(input, output, session) {

  # when an example is clicked, copy that expression to the input box
  lapply(names(examples), function(ex) {
    ex <- examples[ex]
    onclick(sprintf("example-%s", names(ex)),
            updateTextInput(session, "expr", value = as.character(ex)))
  })

  # run the given expression (make sure it's in this environment
  # and not in a temporary closure environment so that objectes
  # created in an expression can be accessed later)
  sessionEnv <- environment()
  observeEvent(input$submitExpr, {
    shinyjs::hide("error")

    tryCatch(
      isolate(
        eval(parse(text = input$expr), envir = sessionEnv)
      ),
      error = function(err) {
        shinyjs::html("errorMsg", as.character(shiny::tags$i(err$message)))
        shinyjs::show(id = "error", anim = TRUE)
      }
    )
  })
})
