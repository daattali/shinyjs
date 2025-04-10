#' Reset input elements to their original values
#'
#' Reset any input element back to its original value. You can either reset
#' one specific input at a time by providing the id of a shiny input, or reset
#' all inputs within an HTML tag by providing the id of an HTML tag.\cr\cr
#' Reset can be performed on any traditional Shiny inputs, as well as many
#' inputs from the {colourpicker} and {shinyWidgets} packages. Note that
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

        # checkbox values need to be manually converted to TRUE/FALSE
        if (type == "Checkbox") {
          value <- as.logical(value)
        }
        if (type == "Date") {
          if (value == "NA") {
            value <- NA
          }
        }

        # most input update functions use 'value' argument, but some require special handling

        if (type == "RadioButtons") {
          if (is.null(value) && utils::packageVersion("shiny") > "1.5.0") {
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
          funcParams[['value']] <- strToVec(value)
        } else if (type == "SliderDate") {
          type <- "Slider"
          value <- strToVec(value)
          funcParams[['value']] <- as.Date(as.POSIXct(as.numeric(value) / 1000, origin = "1970-01-01"))
        } else if (type == "SliderDateTime") {
          type <- "Slider"
          value <- strToVec(value)
          funcParams[['value']] <- as.POSIXct(as.numeric(value) / 1000, origin = "1970-01-01")
        } else if (type == "DateRange") {
          dates <- strToVec(value)
          dates[dates == "NA"] <- NA
          funcParams[['start']] <- dates[1]
          funcParams[['end']] <- dates[2]
        }

        # {shinyWidgets} inputs
        else if (type == "CalendarPro") {
          funcParams[['value']] <- strToVec(value, " ")
        } else if (type == "NoUiSlider") {
          funcParams[['value']] <- strToVec(value)
        } else if (type == "NumericRange") {
          funcParams[['value']] <- strToVec(value)
        } else if (type == "RadioGroupButtons") {
          funcParams[['selected']] <- value
        } else if (type == "SliderText") {
          funcParams[['selected']] <- strToVec(value)
        } else if (type == "SlimSelect") {
          funcParams[['selected']] <- strToVec(value)
        } else if (type == "Spectrum") {
          funcParams[['selected']] <- value
        } else if (type == "VirtualSelect") {
          if (is.null(value)) {
            funcParams[['selected']] <- ""
          } else {
            funcParams[['selected']] <- strToVec(value)
          }
        }

        else {
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
  unlist(strsplit(str, sep))
}

getUpdateFunc <- function(type) {

  # get the name of the function
  inputsShortUpdateName <- c("RadioButtons", "CalendarPro", "ColorPickr", "RadioGroupButtons", "SlimSelect", "VirtualSelect")
  if (type %in% inputsShortUpdateName) {
    updateFunc <- sprintf("update%s", type)
  } else {
    updateFunc <- sprintf("update%sInput", type)
  }

  # get the package it's from
  pkg <- ""
  shinyWidgetsInputs <- c("CalendarPro", "ColorPickr", "Knob", "NoUiSlider", "NumericRange", "RadioGroupButtons", "SliderText", "SlimSelect", "Spectrum", "Time", "VirtualSelect")
  if (type == "Colour") {
    pkg <- "colourpicker"
  } else if (type %in% shinyWidgetsInputs) {
    pkg <- "shinyWidgets"
  }
  if (pkg != "") {
    updateFunc <- utils::getFromNamespace(updateFunc, pkg)
  }

  updateFunc
}
