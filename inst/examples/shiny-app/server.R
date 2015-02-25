library(shiny)
library(shinyjs)

shinyServer(function(input, output, session) {
  shinyjs::setShinyjsSession(session)

  observe({
    if (input$submitExpr == 0) {
      return()
    }

    shinyjs::hide("error")

    tryCatch(
      isolate(
        eval(parse(text = input$expr))
      ),
      error = function(err) {
        innerHTML("errorMsg", err$message)
        shinyjs::show(id = "error", anim = TRUE, animType = "fade")
      }
    )
  })
})
