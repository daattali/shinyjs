library(shiny)
library(shinyjs)

share <- list(
  title = "colourInput",
  url = "http://daattali.com/shiny/colourInput/",
  image = "http://daattali.com/shiny/img/colourinput.png",
  description = "An input control that allows users to select colours in Shiny apps (from shinyjs package)",
  twitter_user = "daattali"
)

shinyApp(
  ui = fluidPage(
    tags$head(
      includeCSS(file.path("www", "app.css")),
      # Favicon
      tags$link(rel = "shortcut icon", type="image/x-icon", href="http://daattali.com/shiny/img/favicon.ico"),
      # Facebook OpenGraph tags
      tags$meta(property = "og:title", content = share$title),
      tags$meta(property = "og:type", content = "website"),
      tags$meta(property = "og:url", content = share$url),
      tags$meta(property = "og:image", content = share$image),
      tags$meta(property = "og:description", content = share$description),

      # Twitter summary cards
      tags$meta(name = "twitter:card", content = "summary"),
      tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
      tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
      tags$meta(name = "twitter:title", content = share$title),
      tags$meta(name = "twitter:description", content = share$description),
      tags$meta(name = "twitter:image", content = share$image)
    ),
    tags$a(
      href="https://github.com/daattali/shinyjs",
      tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
               src="github-gray-right.png",
               alt="Fork me on GitHub")
    ),
    div(id = "header",
        div(id = "title",
            "colourInput"
        ),
        div(id = "subtitle",
            "An input control that allows users to select colours in Shiny apps (from shinyjs package)"),
        div(id = "subsubtitle",
            "By",
            tags$a(href = "http://deanattali.com/", "Dean Attali"),
            HTML("&bull;"),
            "Package available",
            tags$a(href = "https://github.com/daattali/shinyjs", "on GitHub"),
            HTML("&bull;"),
            tags$a(href = "http://daattali.com/shiny/", "More apps"), "by Dean"
        )
    ),
    div(
      class = "section",
      div(class = "title", "Simple"),
      div(class = "output", "Selected colour:",
          textOutput("valueSimple", inline = TRUE)),
      colourInput("colSimple", NULL, "blue"),
      tags$pre('colourInput("col", NULL, "blue")')
    ),

    div(
      class = "section",
      div(class = "title", "Limited colour palette"),
      div(class = "output", "Selected colour:",
          textOutput("valueLimited", inline = TRUE)),
      colourInput("colLimited", NULL, "yellow", palette = "limited"),
      tags$pre(HTML(paste0(
        'colourInput(<br>',
        '  "col", NULL, "yellow",<br>',
        '  palette = "limited")'
      )))
    ),

    div(
      class = "section",
      div(class = "title", "Return R colour name"),
      div(class = "output", "Selected colour:",
          textOutput("valueName", inline = TRUE)),
      colourInput("colName", NULL, "green", returnName = TRUE, palette = "limited"),
      tags$pre(HTML(paste0(
        'colourInput(<br>',
        '  "col", NULL, "green",<br>',
        '  returnName = TRUE, <br>',
        '  palette = "limited")'
      )))
    ),

    div(
      class = "section",
      div(class = "title", "Only show background"),
      div(class = "output", "Selected colour:",
          textOutput("valueBg", inline = TRUE)),
      colourInput("colBg", NULL, "red", showColour = "background"),
      tags$pre(HTML(paste0(
        'colourInput(<br>',
        '  "col", NULL, "red",<br>',
        '  showColour = "background")'
      )))
    ),

    div(
      class = "section",
      div(class = "title", "Allow \"transparent\""),
      div(class = "output", "Selected colour:",
          textOutput("valueTransparent", inline = TRUE)),
      colourInput("colTransparent", NULL, "orange", allowTransparent = TRUE),
      tags$pre(HTML(paste0(
        'colourInput(<br>',
        '  "col", NULL, "orange",<br>',
        '  allowTransparent = TRUE)'
      )))
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
      shiny::selectInput("palette", "Colour palette",
                         c("square", "limited")),
      checkboxInput("allowTransparent", "Allow transparent", FALSE),
      checkboxInput("returnName", "Return R colour name", FALSE),
      actionButton("update", "Update")
    ),

    div(
      class = "section",
      div(class = "title", "Use output in a plot"),
      colourInput("colPlotFill", "Points colour", "purple"),
      colourInput("colPlotOutline", "Points outline", "black", allowTransparent = TRUE),
      plotOutput("plot")
    ),

    div(
      class = "section",
      div(class = "title", "Custom colour list"),
      div(class = "output", "Selected colour:",
          textOutput("valueCustom", inline = TRUE)),
      colourInput("colCustom", NULL, palette = "limited",
                  allowedCols = c("white", "black", "red", "blue", "yellow",
                                  "purple", "green", "#DDD")),
      tags$pre(HTML(paste0(
        'colourInput(<br>',
        '  "col", NULL,<br>',
        '  palette = "limited",<br>',
        '  allowedCols = c(<br>',
        '    "white", "black", "red",<br>',
        '    "blue", "yellow", "purple",<br>',
        '    "green", "#DDD"))'
      )))
    )
  ),
  server = function(input, output, session) {
    # show the selected colours
    output$valueSimple      <- renderText(input$colSimple)
    output$valueBg          <- renderText(input$colBg)
    output$valueTransparent <- renderText(input$colTransparent)
    output$valueUpdate      <- renderText(input$colUpdate)
    output$valueLimited     <- renderText(input$colLimited)
    output$valueName        <- renderText(input$colName)
    output$valueCustom      <- renderText(input$colCustom)

    # allow user to update an input control
    observeEvent(input$update, {
      updateColourInput(session, "colUpdate",
                        value = input$text, showColour = input$showColour,
                        palette = input$palette,
                        allowTransparent = input$allowTransparent,
                        returnName = input$returnName)
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
