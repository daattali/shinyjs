#' Reset input elements to their original values
#'
#' Reset any input element back to its original value. You can either reset
#' one specific input at a time by providing the id of a shiny input, or reset
#' all inputs within an HTML tag by providing the id of an HTML tag.\cr\cr
#' Reset can be performed on any traditional Shiny inputs, as well as inputs
#' from the \{colourpicker\} and \{shinyWidgets\} packages. Note that
#' \code{actionButton} is not supported, meaning that you cannot reset
#' the value of a button back to 0.
#'
#' @param id The id of the input element to reset or the id of an HTML
#' tag to reset all inputs inside it. If no id is provided, then
#' all inputs on the page are reset.
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
reset <- function(id = "", asis = FALSE) {
  # get the Shiny session
  session <- getSession()

  # Make sure reset works with namespaces (shiny modules)
  nsName <- ""
  if (id != "" && inherits(session, "session_proxy") && !asis) {
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
        # Make sure reset works with namespacing (shiny modules)
        id <- x
        if (substring(id, 1, nchar(nsName)) == nsName) {
          id <- substring(id, nchar(nsName) + 1)
        }

        if (inherits(session, "session_proxy") && asis) {
          session_to_reset <- .subset2(session, "parent")
        } else {
          session_to_reset <- session
        }
        funcParams <- list(session = session_to_reset, id)

        type <- messages[[x]][['type']]
        value <- messages[[x]][['value']]

        # list of inputs that can have multiple values and need the value parsed from a
        # comma-separated list to a vector
        inputsStrToVec <- c("Slider", "SliderDate", "SliderDateTime", "DateRange", "AirDate", "NoUiSlider", "NumericRange", "SliderText", "SlimSelect", "Tree", "VirtualSelect")

        if (type %in% inputsStrToVec) {
          value <- strToVec(value)
        }

        # list of inputs that use a 'selected' instead of 'value' argument
        inputsParamSelected <- c("RadioButtons", "CheckboxGroup", "Select", "CheckboxGroupButtons", "RadioGroupButtons", "SliderText", "SlimSelect", "Spectrum", "Tree", "VirtualSelect")
        # list of inputs that don't use 'selected' or 'value' arguments
        inputsParamOther <- c("DateRange")

        # some inputs need custom ways to extract the value

        # native shiny inputs
        if (type == "Checkbox") {
          value <- as.logical(value)
        } else if (type == "Date") {
          if (value == "NA") {
            value <- NA
          }
        } else if (type == "RadioButtons" || type == "RadioGroupButtons") {
          if (is.null(value) && utils::packageVersion("shiny") > "1.5.0") {
            value <- character(0)
          }
        } else if (type == "CheckboxGroup" || type == "Select" || type == "CheckboxGroupButtons") {
          if (value == '""') {
            value <- ""
          } else {
            value <- jsonlite::fromJSON(value)
          }
        } else if (type == "SliderDate") {
          type <- "Slider"
          value <- as.Date(as.POSIXct(as.numeric(value) / 1000, origin = "1970-01-01"))
        } else if (type == "SliderDateTime") {
          type <- "Slider"
          value <- as.POSIXct(as.numeric(value) / 1000, origin = "1970-01-01")
        } else if (type == "DateRange") {
          value[value == "NA"] <- NA
          funcParams[['start']] <- value[1]
          funcParams[['end']] <- value[2]
        }

        # {shinyWidgets} inputs
        else if (type == "CalendarPro") {
          value <- strToVec(value, " ")
        }

        if (type %in% inputsParamSelected) {
          funcParams[['selected']] <- value
        } else if (type %in% inputsParamOther) {
          # assume the correct argument was already added above
        } else {
          funcParams[['value']] <- value
        }

        updateFunc <- getUpdateFunc(type)

        # update the input to its original values
        do.call(updateFunc, funcParams)
      }
    )
  })

  invisible(NULL)
}

strToVec <- function(str, sep = ",") {
  if (is.null(str) || str == "") {
    return("")
  }
  unlist(strsplit(str, sep))
}

getUpdateFunc <- function(type) {

  # list of inputs whose update function doesn't include the word "Input" at the end
  inputsShortUpdateName <- c("RadioButtons", "CalendarPro", "CheckboxGroupButtons", "ColorPickr", "RadioGroupButtons", "SlimSelect", "VirtualSelect")

  if (type %in% inputsShortUpdateName) {
    updateFuncName <- sprintf("update%s", type)
  } else {
    updateFuncName <- sprintf("update%sInput", type)
  }

  # list of inputs whose update function is taken from {shinyWidgets}
  shinyWidgetsInputs <- c("AirDate", "CalendarPro", "CheckboxGroupButtons", "ColorPickr", "Knob", "NoUiSlider", "NumericRange", "RadioGroupButtons", "SliderText", "SlimSelect", "Spectrum", "Time", "Tree", "VirtualSelect")

  if (type == "Colour") {
    pkg <- "colourpicker"
  } else if (type %in% shinyWidgetsInputs) {
    pkg <- "shinyWidgets"
  } else {
    pkg <- "shiny"
  }
  updateFunc <- utils::getFromNamespace(updateFuncName, pkg)

  updateFunc
}
