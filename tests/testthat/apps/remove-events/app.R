library(shiny)
library(shinyjs)

inputEventsUI <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("field"), "Click this input"),
    p(id = ns("plain"), "Click this paragraph"),
    actionButton(ns("remove_one"), "Remove first input handler"),
    actionButton(ns("remove_all"), "Remove remaining click handlers"),
    actionButton(ns("checkpoint"), "Checkpoint"),
    textOutput(ns("first")), textOutput(ns("second")),
    textOutput(ns("plain_count")), textOutput(ns("status")),
    textOutput(ns("checked"))
  )
}

inputEventsServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    first <- reactiveVal(0)
    second <- reactiveVal(0)
    plain_count <- reactiveVal(0)
    status <- reactiveVal("ready")
    checked <- reactiveVal(0)

    event_id <- onclick("field", first(first() + 1))
    onclick("field", second(second() + 1), add = TRUE)
    onclick("plain", plain_count(plain_count() + 1))

    observeEvent(input$remove_one, {
      removeEvent(event_id, "field")
      status("removed one")
    })
    observeEvent(input$remove_all, {
      removeEvent("click", "field")
      removeEvent("click", "plain")
      status("removed all")
    })
    observeEvent(input$checkpoint, checked(checked() + 1))

    output$first <- renderText(first())
    output$second <- renderText(second())
    output$plain_count <- renderText(plain_count())
    output$status <- renderText(status())
    output$checked <- renderText(checked())
  })
}

shinyApp(
  fluidPage(useShinyjs(), inputEventsUI("m")),
  function(input, output, session) inputEventsServer("m")
)
