library(shiny)
library(miniUI)

css2 <- "
body { background: #fcfcfc; }
#author {
font-size: 0.8em;
}
#anycolarea {
text-align: center;
}
#anycolarea .shiny-input-container {
text-align: left;
margin: 0 auto;
}
.rcol {
width: 20px;
height: 20px;
border: 1px solid #DDD;
cursor: pointer;
display: inline-block;
}
.rcolbig {
width: 60px;
height: 60px;
margin-right: 10px;
}
.rcolbig:last-child {
margin-right: 0;
}
.rcolname {
word-break: break-all;
font-size: 0.9em;
display: inline-block;
vertical-align: top;
}
"

col2hex <- function(col) {
  do.call(rgb, as.list(col2rgb(col) / 255))
}

NUM_CLOSE_COLS <- 10

closest_colour_hex <- function(target, n = NUM_CLOSE_COLS, superset = colours(distinct = TRUE)) {
  target <- as.numeric(col2rgb(target))

  # Find the manhattan distance from each colour to the target colour
  require(magrittr)

  superset %>%
    col2rgb %>%
    subtract(target) %>%
    apply(2, function(x) x %>% abs %>% sum) %>%
    order %>%
    .[1:n] %>%
    superset[.]
}

colourPickerGadget <- function() {

  ui <- miniPage(
    shinyjs::inlineCSS(css2),
    gadgetTitleBar(span(strong("Colour Picker"),
                        span(id = "author", "By", a(href = "http://deanattali.com", "Dean Attali"))),
                   right = NULL),
    miniTabstripPanel(
      id = "colourType",
      miniTabPanel(
        value = "anycolour",
        "Any colour",
        icon = icon("paint-brush"),
        miniContentPanel(
          div(
            id = "anycolarea",
            br(), br(), br(), br(), br(),
            shinyjs::colourInput("anyColInput", "Select any colour",
                                 showColour = "both", value = "orange"),
            br(),
            actionButton("submitAny", strong("Done"), class = "btn-primary")
          )
        )
      ),
      miniTabPanel(
        value = "rcolour",
        "R colour",
        icon = icon("search"),
        miniContentPanel(
          fluidRow(
            column(
              6,
              shinyjs::colourInput("rclosecol", "Show R colours similar to this colour:",
                                   showColour = "both", value = "orange")
            ),
            column(
              6,
              selectInput("returnType", "Return value", c('R colour name (eg. "orange")' = 'rcolname',
                                                          'HEX colour code (eg. "#FFA500")' = 'rcolhex'))
            )
          ),
          br(),
          strong("Click a colour to select it"),
          uiOutput("rclosecols"),
          tags$hr(),
          checkboxInput("allRcols", strong("Show all R colours")),
          conditionalPanel(
            condition = "input.allRcols",
            strong("Click a colour to select it"),
            br(),
            uiOutput("allcols")
          )
        )
      )
    )
  )

  server <- function(input, output, session) {

    values <- reactiveValues(rclosecols = NULL)

    observeEvent(input$cancel, {
      stopApp(stop("User canceled colour selection", call. = FALSE))
    })

    observeEvent(input$submitAny, {
      col <- input$anyColInput
      stopApp(col)
    })

    output$allcols <- renderUI({
      lapply(
        colours(distinct = TRUE),
        function(x) {
          actionLink(
            paste0("rcol-", x),
            label = NULL,
            class = "rcol",
            style = paste0("background: ", col2hex(x)),
            title = x
          )
        }
      )
    })

    lapply(
      colours(distinct = TRUE),
      function(x) {
        observeEvent(input[[paste0("rcol-", x)]], {
          if (input$returnType == "rcolname") {
            col <- x
          } else if (input$returnType == "rcolhex") {
            col <- col2hex(x)
          }
          stopApp(col)
        })
      }
    )

    lapply(
      seq_len(NUM_CLOSE_COLS),
      function(x) {
        observeEvent(input[[paste0("rclosecol-", x)]], {
          col <- values$rclosecols[x]
          if (input$returnType == "rcolname") {
            col <- col
          } else if (input$returnType == "rcolhex") {
            col <- col2hex(col)
          }
          stopApp(col)
        })
      }
    )

    output$rclosecols <- renderUI({
      rcols <- closest_colour_hex(input$rclosecol)
      values$rclosecols <- rcols

      tagList(
        div(
          id = "rcolsnames",
          lapply(
            seq_along(rcols),
            function(x) {
              actionLink(
                paste0("rclosecol-", x),
                label = NULL,
                class = "rcol rcolbig",
                style = paste0("background: ", col2hex(rcols[x])),
                title = rcols[x]
              )
            }
          )
        ),
        div(
          lapply(
            seq_along(rcols),
            function(x) {
              span(rcols[x], class = "rcolname rcolbig")
            }
          )
        )
      )

    })
  }

  viewer <- dialogViewer("Colour Picker", width = 800, height = 500)
  runGadget(ui, server, viewer = viewer, stopOnCancel = FALSE)
}

colourPicker <- function() {
  colourPickerGadget()
}

colourPickerAddin <- function() {
  col <- colourPickerGadget()
  rstudioapi::insertText(text = paste0('"', col, '"'))
}
