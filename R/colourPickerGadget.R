
colourPickerGadget <- function(numCols = 1) {
  if (!requireNamespace("rstudioapi", quietly = TRUE)) {
    stop("You must have RStudio v0.99.878 or newer to use the colour picker",
         call. = FALSE)
  }

  require(shiny)
  require(miniUI)

  ui <- miniPage(
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(functions = c(), text = getCpGadgetShinyjsText()),
    shinyjs::inlineCSS(getCpGadgetCSS()),

    gadgetTitleBar(
      span(strong("Colour Picker"),
           span(id = "author", "By",
                a(href = "http://deanattali.com", "Dean Attali")))
    ),

    # Header section - shows the selected colours
    div(
      id = "header-section",
      div(
        id = "header-title",
        "Selected colours"
      ),
      div(
        id = "selected-cols-row",style="",
        div(id = "addColBtn",
            icon("plus"),
            title = "Add another colour"
        ),
        div(id = "removeColBtn",
            icon("trash-o"),
            title = "Remove selected colour"
        ),
        uiOutput("selectedCols", inline = TRUE)
      ),
      checkboxInput(
        "returnTypeName",
        "Return colour name (eg. \"white\") instead of HEX value (eg. #FFFFFF) when possible",
        width = "100%"
      )
    ),

    miniTabstripPanel(

      # Tab 1 - choose any colour
      miniTabPanel(
        "Any colour",
        icon = icon("globe"),
        miniContentPanel(
          div(
            id = "anycolarea",
            br(),
            shinyjs::colourInput("anyColInput", "Select any colour",
                                 showColour = "both", value = "white")
          )
        )
      ),

      # Tab 2 - choose an R colour similar to a colour you choose
      miniTabPanel(
        "Find R colour",
        icon = icon("search"),
        miniContentPanel(
          fluidRow(
            column(
              6,
              shinyjs::colourInput("rclosecolInput", "Show R colours similar to this colour",
                                   showColour = "both", value = "orange")
            ),
            column(
              6,
              div(id = "customSliderContainer",
                  sliderInput("numSimilar", "How many colours to show",
                              min = 1, max = 40, value = 8, step = 1)
              )
            )
          ),
          br(),
          strong("Click a colour to select it"),
          uiOutput("rclosecolsSection")
        )
      ),

      # Tab 3 - choose any R colour
      miniTabPanel(
        "All R colours",
        icon = icon("paint-brush"),
        miniContentPanel(
          strong("Click a colour to select it"),
          br(),
          div(id = "allcols-spinner", icon("spinner", "fa-spin")),
          uiOutput("allColsSection")
        )
      )
    )
  )

  server <- function(input, output) {
    values <- reactiveValues(
      selectedCols = NULL,
      selectedNum = NULL
    )

    values$selectedCols <- rep("#FFFFFF", numCols)
    values$selectedNum <- 1

    # User canceled
    observeEvent(input$cancel, {
      stopApp(stop("User canceled colour selection", call. = FALSE))
    })

    # Don't allow user to remove the last colour
    observe({
      shinyjs::toggleState("removeColBtn",
                           condition = length(values$selectedCols) > 1)
    })

    # User is done selecting colours
    observeEvent(input$done, {
      cols <- values$selectedCols
      shinyjs::disable(selector = "#cancel, #done")

      if (input$returnTypeName) {
        cols <- lapply(cols, getColNameOrHex)
        cols <- unlist(cols)
      }

      stopApp(cols)
    })

    # Add another colour to select
    shinyjs::onclick("addColBtn", {
      values$selectedCols <- c(values$selectedCols, "#FFFFFF")
    })

    # Remove the selected colour
    shinyjs::onclick("removeColBtn", {
      if (length(values$selectedCols) == 1) {
        return()
      }

      values$selectedCols <- values$selectedCols[-values$selectedNum]
      if (values$selectedNum > length(values$selectedCols)) {
        values$selectedNum <- length(values$selectedCols)
      }
    })

    # Render the chosen colours
    output$selectedCols <- renderUI({
      lapply(seq_along(values$selectedCols), function(colNum) {
        if (colNum == values$selectedNum) {
          cls <- "col selected"
        } else {
          cls <- "col"
        }
        if (isColDark(values$selectedCols[colNum])) {
          cls <- paste0(cls, " col-dark")
        }
        div(
          style = paste0("background:", values$selectedCols[colNum]),
          `data-colnum` = colNum,
          class = cls,
          colNum
        )
      })
    })

    # Receive event from JS: a different colour number was selected
    observeEvent(input$jsColNum, {
      values$selectedNum <- input$jsColNum
    })

    # A colour from the "any colour" input is chosen
    observeEvent(input$anyColInput, {
      values$selectedCols[values$selectedNum] <- input$anyColInput
    })

    # Receive event from JS: an R colour was selected
    # Because of how Shiny works, the input from JS needs to also contain
    # a dummy random variable, so that when the user chooses the same colour
    # twice, it will register the second time as well
    observeEvent(input$jsCol, {
      values$selectedCols[values$selectedNum] <- input$jsCol[1]
    })

    # Render all the R colours
    output$allColsSection <- renderUI({
      lapply(
        colours(distinct = TRUE),
        function(x) {
          actionLink(
            paste0("rcol-", x),
            label = NULL,
            class = "rcol",
            style = paste0("background: ", col2hex(x)),
            title = x,
            `data-col` = col2hex(x)
          )
        }
      )
    })

    # After the user chooses a colour, show all the similar R colours
    output$rclosecolsSection <- renderUI({
      rcols <- closestColHex(input$rclosecolInput, n = input$numSimilar)

      tagList(
        div(
          id = "rcolsnames",
          lapply(
            seq_along(rcols),
            function(x) {
              div(
                class = "rcolbox",
                actionLink(
                  paste0("rclosecol-", x),
                  label = NULL,
                  class = "rcol rcolbig",
                  style = paste0("background: ", col2hex(rcols[x])),
                  title = rcols[x],
                  `data-col` = col2hex(rcols[x])
                ),
                span(rcols[x], class = "rcolname")
              )
            }
          )
        )
      )
    })
  }

  viewer <- shiny::dialogViewer("Colour Picker", width = 800, height = 700)
  shiny::runGadget(shiny::shinyApp(ui, server), viewer = viewer, stopOnCancel = FALSE)
}

#' Colour picker gadget
#'
#' This gadget lets you choose colours easily. You can select multiple colours,
#' and you can either choose any RGB colour, or browse through R colours.
#'
#' @param numCols The number of colours to select when the gadget launches (you
#' can add and remove more colours from the app itself too)
#' @note This gadget returns a vector of colours that can be assigned to a variable.
#' If instead you want to get a text representation of the colours that can
#' embedded into code, use the addin from the RStudio Addins menu.
#' @return Vector of selected colours
#' @export
#' @examples
#' if (interactive()) {
#'   cols <- colourPicker(3)
#' }
colourPicker <- function(numCols = 1) {
  colourPickerGadget(numCols)
}

colourPickerAddin <- function() {
  col <- colourPickerGadget()
  text <- paste0("c(\"", paste(col, collapse = "\", \""), "\")")
  rstudioapi::insertText(text = text)
}
