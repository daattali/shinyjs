# TODO name and usspendresume/destroy observers

library(shiny)
library(miniUI)

css <- "
body { background: #fff; }
#author {
text-align: center;
font-style: italic;
margin-top: 100px;
}
.col-section { position: relative; }
.col-section .col-remove {
visibility: hidden;
opacity: 0;
transition: visibility 0s, opacity 0.5s;
font-size: 0.9em;
position: absolute;
right: 15px;
top: 0;
}
.col-section:hover .col-remove {
visibility: visible;
opacity: 1;
}
"

multiColourPickerGadget <- function(num = 1) {

  MAX_COLS <- 25

  ui <- miniPage(
    shinyjs::useShinyjs(),
    shinyjs::inlineCSS(css),
    gadgetTitleBar(strong("Multiple Colour Picker"), left = NULL, right = NULL),
    miniContentPanel(
      padding = 20,
      uiOutput("colourInputs"),
      br(),
      div(
        id = "author",
        "By", a(href = "http://deanattali.com", "Dean Attali")
      )
    ),
    miniButtonBlock(
      actionButton("cancel", "Cancel"),
      actionButton("add", "Add colour"),
      actionButton("submit", "Done", class = "btn-primary")
    )
  )

  server <- function(input, output, session) {

    values <- reactiveValues(
      numColours = num,
      numRemove = NULL,
      added = FALSE
    )

    observeEvent(input$cancel, {
      stopApp(stop("User canceled colour selection", call. = FALSE))
    })

    observe({
      shinyjs::toggleState("add", condition = values$numColours < MAX_COLS)
    })

    observeEvent(input$add, {
      values$numColours <- values$numColours + 1
      values$added <- TRUE
    })

    colours <- reactive({
      input$submit
      values$numColours

      isolate({
        cols <- rep("white", values$numColours)

        if (values$numColours <= 0) {
          return()
        }
        cols <- vapply(
          seq_len(values$numColours),
          function(x) {
            inputId <- paste0("colInput", x)
            inputIdNext <- paste0("colInput", x+1)

            if (!is.null(input[[inputId]])) {
              if (!is.null(values$numRemove) && values$numRemove <= x) {
                input[[inputIdNext]]
              } else {
                input[[inputId]]
              }
            } else {
              cols[x]
            }

          },
          character(1)
        )

        if (values$added) {
          cols[values$numColours] <- "white"
        }

        values$added <- FALSE
        values$numRemove <- NULL
      })

      cols
    })

    output$colourInputs <- renderUI({
      cols <- colours()
      isolate({
        lapply(seq_len(values$numColours), function(x) {
          div(class = "col-section",
              shinyjs::colourInput(
                inputId    = paste0("colInput", x),
                label      = paste0("Colour ", x),
                showColour = "both",
                value      = cols[x]
              ),
              actionLink(paste0("col-remove", x), "Remove", class = "col-remove")
          )
        })
      })
    })

    lapply(seq_len(MAX_COLS), function(x) {
      removeInputId <- paste0("col-remove", x)
      observeEvent(input[[removeInputId]], {
        values$numRemove <- x
        values$numColours <- values$numColours - 1
      })
    })

    observeEvent(input$submit, {
      stopApp(colours())
    })
  }

  viewer <- dialogViewer("Multiple Colour Picker", width = 350, height = 500)
  runGadget(ui, server, viewer = viewer, stopOnCancel = FALSE)
}

multiColourPicker <- function() {
  multiColourPickerGadget()
}

multiColourPickerAddin <- function() {
  cols <- multiColourPickerGadget()
  text <- sprintf('c("%s")', paste(cols, collapse = '", "'))
  rstudioapi::insertText(text = text)
}
