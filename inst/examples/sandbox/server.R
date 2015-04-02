library(shiny)

shinyServer(function(input, output, session) {
  shinyjs::setSession(session)

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
        shinyjs::innerHTML("errorMsg", as.character(shiny::tags$i(err$message)))
        shinyjs::show(id = "error", anim = TRUE, animType = "fade")
      }
    )
  })
})
