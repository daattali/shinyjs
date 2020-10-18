#' Reset input elements to their original values
#'
#' Reset any input element back to its original value. You can either reset
#' one specific input at a time by providing the id of a shiny input, or reset
#' all inputs within an HTML tag by providing the id of an HTML tag.\cr\cr
#' Reset can be performed on any traditional Shiny input widget, which
#' includes: textInput, numericInput, sliderInput, selectInput,
#' selectizeInput, radioButtons, dateInput, dateRangeInput, checkboxInput,
#' checkboxGroupInput, colourInput, passwordInput, textAreaInput. Note that
#' \code{actionButton} is not supported, meaning that you cannot reset
#' the value of a button back to 0.
#'
#' @param id The id of the input element to reset or the id of an HTML
#' tag to reset all input elements inside it.
#' @param asis If \code{TRUE}, use the ID as-is even when inside a module
#' (instead of adding the namespace prefix to the ID).
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),
#'       div(
#'         id = "form",
#'         textInput("name", "Name", "Dean"),
#'         radioButtons("gender", "Gender", c("Male", "Female")),
#'         selectInput("letter", "Favourite letter", LETTERS)
#'       ),
#'       actionButton("resetAll", "Reset all"),
#'       actionButton("resetName", "Reset name"),
#'       actionButton("resetGender", "Reset Gender"),
#'       actionButton("resetLetter", "Reset letter")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$resetName, {
#'         reset("name")
#'       })
#'       observeEvent(input$resetGender, {
#'         reset("gender")
#'       })
#'       observeEvent(input$resetLetter, {
#'         reset("letter")
#'       })
#'       observeEvent(input$resetAll, {
#'         reset("form")
#'       })
#'     }
#'   )
#' }
#' @export
reset <- function(id, asis = FALSE) {
  # get the Shiny session
  session <- getSession()

  # Make sure reset works with namespaces (shiny modules)
  nsName <- ""
  if (inherits(session, "session_proxy") && !asis) {
    id <- session$ns(id)
    nsName <- session$ns("")
  }

  # send a call to JavaScript to figure out what elements to reset and what
  # values to reset them to
  shinyInputId <- paste0("shinyjs-resettable-", id)
  shinyInputIdJs <- shinyInputId
  if (inherits(session, "session_proxy")) {
    shinyInputIdJs <- session$ns(shinyInputIdJs)
  }
  session$sendCustomMessage("shinyjs-reset", list(id = id,
                                          shinyInputId = shinyInputIdJs))

  # listen for a response from javascript
  shiny::observeEvent(session$input[[shinyInputId]], once = TRUE, {
    messages <- session$input[[shinyInputId]]

    # go through each input element that javascript told us about and call
    # the corresponding shiny::updateFooInput() with the correct arguments
    lapply(
      names(messages),
      function(x) {
        type <- messages[[x]][['type']]
        value <- messages[[x]][['value']]

        # password inputs don't have an updatePasswordInput, they use text
        if (type == "Password") {
          type <- "Text"
        }

        updateFunc <- sprintf("update%sInput", type)

        # Make sure reset works with namespecing (shiny modules)
        id <- x
        if (substring(id, 1, nchar(nsName)) == nsName) {
          id <- substring(id, nchar(nsName) + 1)
        }

        if (inherits(session, "session_proxy") && asis) {
          session_to_reset <- .subset2(session, "parent")
        } else {
          session_to_reset <- session
        }
        funcParams <- list(session_to_reset, id)

        # checkbox values need to be manually converted to TRUE/FALSE
        if (type == "Checkbox") {
          value <- as.logical(value)
        }

        if (type == "Date") {
          if (value == "NA") {
            value <- NA
          }
        }

        # most input update functions use 'value' argument, some use 'selected',
        # DateRange uses 'start' and 'end'
        if (type == "RadioButtons") {
          if (is.null(value)) {
            value <- character(0)
          }
          funcParams[['selected']] <- value
        } else if (type == "CheckboxGroup" || type == "Select") {
          if (value == '""') {
            funcParams[['selected']] <- ""
          } else {
            funcParams[['selected']] <- jsonlite::fromJSON(value)
          }
        } else if (type == "Slider") {
          value <- unlist(strsplit(value, ","))
          funcParams[['value']] <- value
        } else if (type == "DateRange") {
          dates <- unlist(strsplit(value, ","))
          dates[dates == "NA"] <- NA
          funcParams[['start']] <- dates[1]
          funcParams[['end']] <- dates[2]
        } else {
          funcParams[['value']] <- value
        }

        # radio buttons don't follow the regular shiny input naming conventions
        if (type == "RadioButtons") {
          updateFunc <- sprintf("update%s", type)
        }

        # for colour inputs, need to use the colourpicker package
        if (type == "Colour") {
          updateFunc <- utils::getFromNamespace(updateFunc, "colourpicker")
        }

        # update the input to its original values
        do.call(updateFunc, funcParams)
      }
    )
  })

  invisible(NULL)
}
