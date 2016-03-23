library(shiny)

source("helpers.R")

shinyServer(function(input, output) {
  values <- reactiveValues(
    selectedCols = NULL,
    selectedNum = NULL
  )

  numCols <- 1
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
      cols <- lapply(cols, get_name_or_hex)
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
    rcols <- closest_colour_hex(input$rclosecolInput, n = input$numSimilar)

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
})
