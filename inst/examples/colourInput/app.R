library(shiny)
library(shinyjs)

shinyApp(
  ui = fluidPage(
    tags$head(includeCSS(file.path("www", "app.css"))),
    titlePanel(tags$strong("Demo of colourInput"),
               "Demo of colourInput"
    ),
    h4(p(
      tags$strong("colourInput"),
      "is an input control that allows users to select colours in Shiny apps"
    ),
    p("It is available as part of the",
      tags$a("shinyjs package", href = "https://github.com/daattali/shinyjs", target = "_blank")
    ),
    p("shinyjs::colourInput() behaves just like any other built-in Shiny input"),
    p("The code for this demo is avaiable",
      a("on GitHub", href = "https://github.com/daattali/shiny-server/tree/master/colourInput", target = "_blank")
    )
    ),
    tags$hr(),

    div(
      class = "section",
      div(class = "title", "Simple"),
      div(class = "output", "Selected colour:",
          textOutput("valueSimple", inline = TRUE)),
      colourInput("colSimple", NULL, "blue")
    ),

    div(
      class = "section",
      div(class = "title", "Only show background"),
      div(class = "output", "Selected colour:",
          textOutput("valueBg", inline = TRUE)),
      colourInput("colBg", NULL, "red", showColour = "background")
    ),

    div(
      class = "section",
      div(class = "title", "Only show text"),
      div(class = "output", "Selected colour:",
          textOutput("valueText", inline = TRUE)),
      colourInput("colText", NULL, "#ABC123", showColour = "text")
    ),

    div(
      class = "section",
      div(class = "title", "Allow \"transparent\""),
      div(class = "output", "Selected colour:",
          textOutput("valueTransparent", inline = TRUE)),
      colourInput("colTransparent", NULL, "orange", allowTransparent = TRUE)
    ),

    div(
      class = "section",
      div(class = "title", "Update input control"),
      div(class = "output", "Selected colour:",
          textOutput("valueUpdate", inline = TRUE)),
      colourInput("colUpdate", NULL, "brown"),
      tags$hr(),
      textInput("text", "New colour: (colour name or HEX value)"),
      selectInput("showColour", "Show colour",
                  c("both", "text", "background")),
      checkboxInput("allowTransparent", "Allow transparent", FALSE),
      actionButton("update", "Update")
    ),

    div(
      class = "section",
      div(class = "title", "Use output in a plot"),
      colourInput("colPlotFill", "Points colour", "purple"),
      colourInput("colPlotOutline", "Points outline", "black", allowTransparent = TRUE),
      plotOutput("plot")
    )

  ),
  server = function(input, output, session) {
    # show the selected colours
    output$valueSimple      <- renderText(input$colSimple)
    output$valueBg          <- renderText(input$colBg)
    output$valueText        <- renderText(input$colText)
    output$valueTransparent <- renderText(input$colTransparent)
    output$valueUpdate      <- renderText(input$colUpdate)

    # allow user to update an input control
    observeEvent(input$update, {
      updateColourInput(session, "colUpdate",
                        value = input$text, showColour = input$showColour,
                        allowTransparent = input$allowTransparent)
    })

    # show plot based on colours selected
    output$plot <- renderPlot({
      par('bg' = '#EEEEEE');
      plot(cars, pch = 22, cex = 1.5,
           col = input$colPlotOutline,
           bg = input$colPlotFill)
    })
  }
)
