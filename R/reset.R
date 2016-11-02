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
reset <- function(id) {
  # get the Shiny session
  session <- getSession()

  # Make sure reset works with namespaces (shiny modules)
  nsName <- ""
  if (inherits(session, "session_proxy")) {
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
  shiny::observeEvent(session$input[[shinyInputId]], {
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

        funcParams <- list(session, id)

        # checkbox values need to be manually converted to TRUE/FALSE
        if (type == "Checkbox") {
          value <- as.logical(value)
        }

        # most input update functions use 'value' argument, some use 'selected',
        # DateRange uses 'start' and 'end'
        if (type == "CheckboxGroup" ||
            type == "RadioButtons" ||
            type == "Select") {
          funcParams[['selected']] <- unlist(strsplit(value, ","))
        } else if (type == "Slider") {
          value <- unlist(strsplit(value, ","))
          funcParams[['value']] <- value
        } else if (type == "DateRange") {
          dates <- unlist(strsplit(value, ","))
          funcParams[['start']] <- dates[1]
          funcParams[['end']] <- dates[2]
        } else {
          funcParams[['value']] <- value
        }

        # radio buttons don't follow the regular shiny input naming conventions
        if (type == "RadioButtons") {
          updateFunc <- sprintf("update%s", type)
        }

        # update the input to its original values
        do.call(updateFunc, funcParams)
      }
    )
  })

  invisible(NULL)
}
