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
