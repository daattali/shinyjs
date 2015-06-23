#' Create a colour input control
#'
#' Create an input control to select a colour.
#'
#' A colour input allows users to select a colour by clicking on the desired
#' colour, or by entering a valid HEX colour in the input box. The input can
#' be initialized with either a colour name or a HEX value, but the value
#' returned from the input will be an uppercase HEX value in both cases.
#'
#' Since most functions in R that accept colours can also accept the value
#' "transparent", \code{colourInput} has an option to allow selecting the
#' "transparent" colour. When the user checks the checkbox for this special
#' colour, the returned value form the input is "transpanrent", otherwise the
#' return value is always a HEX value.
#'
#' @param inputId The \code{input} slot that will be used to access the value.
#' @param label Display label for the control, or `\code{NULL} for no label.
#' @param value Initial value (can be a colour name or HEX code)
#' @param showColour Whether to show the chosen colour as text inside the input,
#' as the background colour of the input, or both (default).
#' @param allowTransparent If \code{TRUE}, then add a checkbox that allows the
#' user to select the \code{transparent} colour.
#' @param transparentText The text to show beside the transparency checkbox
#' when \code{allowTransparent} is \code{TRUE}. The default value is
#' "Transparent", but you can change it to "None" or any other string. This has
#' no effect on the return value from the input; when the checkbox is checked,
#' the input will always return the string "transparent".
#' @seealso \code{\link[shinyjs]{updateColourInput}}
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       shiny::div("Selected colour:",
#'                  shiny::textOutput("value", inline = TRUE)),
#'       colourInput("col", "Choose colour", "red"),
#'       shiny::h3("Update colour input"),
#'       shiny::textInput("text", "New colour: (colour name or HEX value)"),
#'       shiny::selectInput("showColour", "Show colour",
#'         c("both", "text", "background")),
#'       shiny::checkboxInput("allowTransparent", "Allow transparent", FALSE),
#'       shiny::actionButton("btn", "Update")
#'     ),
#'     server = function(input, output, session) {
#'       shiny::observeEvent(input$btn, {
#'         updateColourInput(session, "col",
#'           value = input$text, showColour = input$showColour,
#'           allowTransparent = input$allowTransparent)
#'       })
#'       output$value <- shiny::renderText(input$col)
#'     }
#'   )
#' }
#' @note Unlike the rest of the \code{shinyjs} functions, this function does
#' not require you to call \code{useShinyjs()} first.
#' @note See \href{http://daattali.com/shiny/colourInput/}{http://daattali.com/shiny/colourInput/}
#' for a live demo.
#' @export
colourInput <- function(inputId, label, value = "white",
                        showColour = c("both", "text", "background"),
                        allowTransparent = FALSE, transparentText) {
  value <- formatHEX(value)
  showColour <- match.arg(showColour)

  jsInputBinding <- system.file("srcjs", "input_binding_colour.js",
                                package = "shinyjs")
  jsCP <- system.file("www", "shared", "colourpicker", "js", "colourpicker.min.js",
                      package = "shinyjs")
  cssCP <- system.file("www", "shared", "colourpicker", "css", "colourpicker.min.css",
                       package = "shinyjs")

  inputTag <-
    shiny::tags$input(
      id = inputId, type = "text",
      class = "form-control shiny-colour-input",
      `data-init-value` = value,
      `data-show-colour` = showColour
    )
  if (allowTransparent) {
    inputTag <- shiny::tagAppendAttributes(
                  inputTag,
                  `data-allow-transparent` = "true")
  }
  if (!missing(transparentText)) {
    inputTag <- shiny::tagAppendAttributes(
                  inputTag,
                  `data-transparent-text` = transparentText)
  }

  shiny::tagList(
    shiny::singleton(shiny::tags$head(
      shiny::includeScript(jsCP),
      shiny::includeCSS(cssCP),
      shiny::includeScript(jsInputBinding)
    )),
    shiny::div(class = "form-group shiny-input-container",
        `data-shiny-input-type` = "colour",
        label %AND% shiny::tags$label(label, `for` = inputId),
        inputTag
    )
  )
}

#' Change the value of a colour input
#'
#' Change the value of a colour input on the client.
#'
#' The update function sends a message to the client, telling it to change
#' the settings of a colour input object.\cr
#' This function works similarly to the update functions provided by shiny.\cr
#' Any argument with \code{NULL} values will be ignored.
#'
#' @param session The \code{session} object passed to function given to \code{shinyServer}.
#' @param inputId The id of the colour input object.
#' @param label The label to set for the input object.
#' @param value The value to set for the input object.
#' @param showColour Whether to shoW the chosen colour via text, background, or both.
#' @param allowTransparent If \code{TRUE}, then add a checkbox that allows the
#' user to select the \code{transparent} colour.
#' @param transparentText The text to show beside the transparency checkbox
#' when \code{allowTransparent} is \code{TRUE}
#' @seealso \code{\link[shinyjs]{colourInput}}
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       shiny::div("Selected colour:",
#'                  shiny::textOutput("value", inline = TRUE)),
#'       colourInput("col", "Choose colour", "red"),
#'       shiny::h3("Update colour input"),
#'       shiny::textInput("text", "New colour: (colour name or HEX value)"),
#'       shiny::selectInput("showColour", "Show colour",
#'         c("both", "text", "background")),
#'       shiny::checkboxInput("allowTransparent", "Allow transparent", FALSE),
#'       shiny::actionButton("btn", "Update")
#'     ),
#'     server = function(input, output, session) {
#'       shiny::observeEvent(input$btn, {
#'         updateColourInput(session, "col",
#'           value = input$text, showColour = input$showColour,
#'           allowTransparent = input$allowTransparent)
#'       })
#'       output$value <- shiny::renderText(input$col)
#'     }
#'   )
#' }
#' @note Unlike the rest of the \code{shinyjs} functions, this function does
#' not require you to call \code{useShinyjs()} first.
#' @note See \href{http://daattali.com/shiny/colourInput/}{http://daattali.com/shiny/colourInput/}
#' for a live demo.
#' @export
updateColourInput <- function(session, inputId, label = NULL, value = NULL,
                              showColour = NULL, allowTransparent = NULL,
                              transparentText = NULL) {
  message <- shiny:::dropNulls(list(
    label = label, value = formatHEX(value),
    showColour = showColour, allowTransparent = allowTransparent,
    transparentText = transparentText
  ))
  session$sendInputMessage(inputId, message)
}

formatHEX <- function(x) {
  if (is.null(x) || x == "") return()

  if (x == "transparent") {
    return(x)
  }

  # ensure x is a valid HEX colour or a valid named colour
  if (x %in% colors()) {
    x <- do.call(rgb, as.list(col2rgb(x) / 255))
  }
  if (!grepl("^#?([[:xdigit:]]{3}|[[:xdigit:]]{6})$", x)) {
    stop(sprintf("%s is not a valid colour", x), call. = FALSE)
  }

  # ensure x begins with a pound sign
  if (substr(x, 1, 1) != "#") {
    x <- paste0("#", x)
  }

  # expand x to a 6-character HEX colour if it's in shortform
  # wow this is ugly, think of a nicer solution when it's not 4am
  if (nchar(x) == 4) {
    x <- paste0("#", substr(x, 2, 2), substr(x, 2, 2),
                substr(x, 3, 3), substr(x, 3, 3),
                substr(x, 4, 4), substr(x, 4, 4))
  }

  toupper(x)
}

`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x))
    if (!is.null(y) && !is.na(y))
      return(y)
  return(NULL)
}
