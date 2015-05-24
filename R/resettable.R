#' Reset input elements to their original values
#'
#' Reset an input element back to its original value by initializing
#' it with \code{resettable} and calling \code{reset} whenever you
#' want to reset the value.
#'
#' If the tag given to \code{resettable} is a single Shiny input, then
#' that input can be reset back to its original value with \code{reset}.
#' If the tag given to \code{resettable} is a more complex tag, then
#' you can either reset all inputs together or reset individual input
#' elements inside the tag.
#'
#' Reset can be performed on any traditional Shiny input wiget, which
#' includes: textInput, numericInput, sliderInput, selectInput,
#' selectizeInput, radioButtons, dateInput, dateRangeInput,
#' checkboxInput, checkboxGroupInput.  Note that buttons are not supported,
#' meaning that you cannot use this function to reset the value of an
#' action button back to 0.
#'
#' Note that this function only works on input widgets that are rendered in
#' the UI. Any input that is created dynamically using \code{uiOutput} +
#' \code{renderUI} will not be resettable.
#'
#' @param tag Shiny tag that will support every input element within it
#' to be resettable later.
#' @param id The id of the input element to reset or the id of an HTML
#' tag to reset all input elements inside it.
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' if (interactive()) {
#'   runApp(shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),
#'       resettable(textInput("name", "Name", "Dean")),
#'       resettable(
#'         div(id = "advancedInfo",
#'             radioButtons("gender", "Gender", c("Male", "Female")),
#'             selectInput("letter", "Favourite letter", LETTERS)
#'         )
#'       ),
#'       actionButton("resetName", "Reset name"),
#'       actionButton("resetGender", "Reset Gender"),
#'       actionButton("resetLetter", "Reset letter"),
#'       actionButton("resetAdvanced", "Reset both advanced info")
#'     ),
#'     server = function(input, output, session) {
#'       observeEvent(input$resetName, {
#'         reset("name")
#'       })
#'       observeEvent(input$resetGender, {
#'         reset("gender")
#'       })
#'       observeEvent(input$resetLetter, {
#'         reset("letter")
#'       })
#'       observeEvent(input$resetAdvanced, {
#'         reset("advancedInfo")
#'       })
#'     }
#'   ))
#' }
#' @name reset
NULL

#' @export
#' @rdname reset
resettable <- function(tag) {
  if (!inherits(tag, "shiny.tag")) {
    errMsg("'tag' is not a valid Shiny tag")
  }

  tag <- shiny::tagAppendAttributes(
    tag,
    class = "shinyjs-resettable-init")
  tag
}

#' @export
#' @rdname reset
reset <- function(id) {
  # grab the Shiny session that called us
  session <- dynGetCopy("session")

  # send a call to JavaScript to figure out what elements to reset and what
  # values to reset them to
  shinyInputId <- paste0("shinyjs-resettable-", id)
  session$sendCustomMessage("reset", list(id = id,
                                          shinyInputId = shinyInputId))

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

        updateFunc <- sprintf("update%sInput", type)
        funcParams <- list(session, x)

        # checkbox values need to be manually converted to TRUE/FALSE
        if (type == "Checkbox") {
          value <- as.logical(value)
        }

        # most input update functions use 'value' argument, some use 'selected',
        # DateRange uses 'start' and 'end'
        if (type == "CheckboxGroup" ||
            type == "RadioButtons" ||
            type == "Select") {
          funcParams[['selected']] <- strsplit(value, ",")[[1]]
        } else if (type == "DateRange") {
          dates <- strsplit(value, ",")[[1]]
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
