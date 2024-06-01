library(shiny)
library(shinyjs)

source("helper-text.R")

shinyApp(
  ui = fixedPage(
    shinydisconnect::disconnectMessage2(),
    useShinyjs(),
    inlineCSS(list(.big = "font-size: 2em",
                   a = "cursor: pointer")),
    fixedRow(
      column(6, wellPanel(
        div(id = "myapp",
            h2("shinyjs demo"),
            checkboxInput("big", "Bigger text", FALSE),
            textInput("name", "Name", ""),
            a(id = "toggleAdvanced", "Show/hide advanced info"),
            hidden(
              div(id = "advanced",
                numericInput("age", "Age", 30),
                textInput("company", "Company", "")
              )
            ),
            p("Timestamp: ",
              span(id = "time", date()),
              a(id = "update", "Update")
            ),
            actionButton("submit", "Submit"),
            actionButton("reset", "Reset form")
        ),
        br(), br()
      )),
      column(6,
             getHelperText()
      )
    )
  ),

  server = function(input, output) {
    onclick("update", html("time", date()))
    onclick("toggleAdvanced", toggle(id = "advanced", anim = TRUE))

    observe({
      toggleClass("myapp", "big", input$big)
    })

    observe({
      toggleState("submit", !is.null(input$name) && input$name != "")
    })

    observeEvent(input$submit, {
      alert("Thank you!")
    })

    observeEvent(input$reset, {
      reset("myapp")
    })
  }
)
