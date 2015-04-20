library(shiny)
library(shinyjs)

shinyApp(
  ui = fixedPage(
    useShinyjs(),
    inlineCSS(list(.big = "font-size: 2em",
                   a = "cursor: pointer")),
    fixedRow(
      column(6,
        h2("shinyjs demo"),
        checkboxInput("big", "Bigger text", FALSE),
        div(id = "myapp",
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
          actionButton("submit", "Submit")
        ),
        br(), br()
      ),
      column(6,
        h3("shinyjs usage in this app"),
        tags$ul(
          tags$li(
             "Selecting 'Bigger text' uses", code("shinyjs::addClass()"),
             "to add a CSS class to the webpage that enlarges the font"),
          tags$li(
             "Typing text inside the 'Name' field uses", code("shinyjs::enable()"),
             "to enable the submit button, and similary to disable the button",
             "when there is no input"),
          tags$li(
             "Clicking 'Show/hide advanced info' uses", code("shinyjs::onclick()"),
             "and", code("shinyjs::toggle()"), "to toggle between showing and",
             "hiding the advanced info section when the link is clicked"),
          tags$li(
             "Clicking 'Update' uses", code("shinyjs::onclick()"), "and",
             code("shinyjs::text()"), "to update the text in the timestamp when",
             "the link is clicked"),
          tags$li(
             "Clicking 'Submit' uses", code("shinyjs::info()"), "to show a",
             "message to the user")
        ),
        p("These are just a subset of the functions available in shinyjs."),
        p("This app is available at",
          a("http://daattali.com:3838/shinyjs-basic",
            href = "http://daattali.com:3838/shinyjs-basic/"),
          "and the source code is",
          a("on GitHub",
            href = "https://github.com/daattali/shinyjs/blob/master/inst/examples/basic/app.R")
        ),
        a("Visit GitHub to learn more about shinyjs",
          href = "https://github.com/daattali/shinyjs")
      )
    )
  ),

  server = function(input, output, session) {
    onclick("update", text("time", date()))
    onclick("toggleAdvanced", toggle(id = "advanced", anim = TRUE))
    observe({
      if (input$big) {
        addClass("myapp", "big")
      } else {
        removeClass("myapp", "big")
      }
    })

    observe({
      if (is.null(input$name) || input$name == "") {
        disable("submit")
      } else {
        enable("submit")
      }
    })

    observe({
      if (input$submit > 0) {
        info("Thank you!")
      }
    })
  }
)
