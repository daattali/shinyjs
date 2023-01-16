library(shiny)
library(shinyjs)

to_posix <- function(s) as.POSIXct(s, format = "%Y-%m-%d %H:%M:%S", tz = "UTC")

ui <- fluidPage(
  useShinyjs(),
  actionButton("reset", "Reset"),
  textInput("id", "ID", "all"),
  div(
    id = "all",
    textInput("text", "text", "text"),
    numericInput("num", "num", 5),
    sliderInput("slider", "slider", 0, 10, 3),
    dateInput("realdate", "realdate", "2009-04-02"),
    radioButtons("radio", "radio", letters[1:5], selected = "b", inline = TRUE),
    radioButtons("radio2", "radio2", letters[1:5], selected = character(0), inline = TRUE),
    sliderInput(
      "date", "date",
      min = as.Date("2010-01-01"), max = as.Date("2010-10-01"),
      value = as.Date("2010-03-10")
    ),
    sliderInput(
      "date2", "date2",
      min = as.Date("2010-01-01"), max = as.Date("2010-10-01"),
      value = c(as.Date("2010-04-10"), as.Date("2010-07-10"))
    ),
    sliderInput(
      "datetime", "datetime",
      min = to_posix("2010-01-01 10:00:00"), max = to_posix("2010-10-01 16:00:00"),
      value = to_posix("2010-04-09 14:00:00")
    ),
    sliderInput(
      "datetime2", "datetime2",
      min = to_posix("2010-01-01 08:00:00"), max = to_posix("2010-10-01 11:00:00"),
      value = c(to_posix("2010-03-09 19:00:00"), to_posix("2010-07-16 22:00:00"))
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$reset, {
    if (nzchar(input$id)) {
      shinyjs::reset(input$id)
    } else {
      shinyjs::reset()
    }
  })
}

shinyApp(ui, server)
