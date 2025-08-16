#' Construct to let you run arbitrary R code live in a Shiny app
#'
#' Sometimes when developing a Shiny app, it's useful to be able to run some R
#' code on-demand. This construct provides your app with a text input where you
#' can enter any R code and run it immediately.\cr\cr
#' This can be useful for testing
#' and while developing an app locally, but it \strong{should not be included in
#' an app that is accessible to other people}, as letting others run arbitrary R
#' code can open you up to security attacks.\cr\cr
#' To use this construct, you must add a call to \code{runcode()} in the UI
#' of your app, and initialize shinyjs with a call to \code{useShinyjs()}.
#'
#' @note You can only have one `runcode` construct in your shiny app, do not
#' call it more than once in the UI.
#'
#' @param code The initial R code to show in the text input when the app loads
#' @param type One of \code{"text"} (default), \code{"textarea"}, or \code{"ace"}.
#' When using a text input, the R code will be limited to be typed within a single line,
#' and is the recommended option. Textarea should be used if you want to write
#' long multi-line R code. Note that you can run multiple expressions even in
#' a single line by appending each R expression with a semicolon.
#' Use of the \code{"ace"} editor requires the \code{shinyAce} package.
#' @param width The width of the editable code input (ignored when
#' \code{type="ace"})
#' @param height The height of the editable code input (ignored when
#' \code{type="text"})
#' @param ns The [`namespace`][shiny::NS()] object of the current module if inside a Shiny module.
#' @seealso \code{\link[shinyjs]{useShinyjs}}
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       runcode(code = "shinyjs::alert('Hello!')")
#'     ),
#'     server = function(input, output) {}
#'   )
#' }
#' @export
runcode <- function(code = "",
                    type = c("text", "textarea", "ace"),
                    width = NULL,
                    height = NULL,
                    ns = shiny::NS(NULL)) {
  type <- match.arg(type)

	if (type == "ace") {
	  if (!requireNamespace("shinyAce", quietly = TRUE)) {
	    errMsg("You need to install the 'shinyAce' package in order to use 'shinyAce' editor.")
	  }
	}

  placeholder <- "Enter R code"
  id <- ns(paste0("runcode_expr"))
  codeTag <-
    if (type == "text") {
      shiny::textInput(
        id, label = NULL, value = code,
        width = width, placeholder = placeholder
      )
    } else if (type == "textarea") {
      shiny::textAreaInput(
        id, label = NULL, value = code,
        width = width, height = height, placeholder = placeholder
      )
    } else if (type == "ace") {
      shinyAce::aceEditor(id, mode = 'r', value = code,
                          height = height, theme = "github", fontSize = 16)
    }

  callback <- paste0(
    "Shiny.setInputValue(",
    "'runcode:shinyjspkg',",
    "{ ns : '", ns(""), "', code : document.getElementById('", id, "').value },",
    "{ priority : 'event' }",
    ");")

  shiny::tagList(
    codeTag,
    shiny::tags$button("Run", onclick = shiny::HTML(callback), class = "btn btn-success action-button"),
    shinyjs::hidden(
      shiny::div(
        id = ns(paste0("runcode_error")),
        style = "color: red; font-weight: bold;",
        shiny::div("Oops, that resulted in an error! Try again."),
        shiny::div("Error: ", shiny::br(),
                   shiny::tags$i(shiny::span(
                     id = ns(paste0("runcode_errorMsg")),
                     style = "margin-left: 10px;")))
      )
    )
  )
}

#' Deprecated - use `runcode()` instead
#' @param ... All parameters acceptd by [shinyjs::runcode()]
#' @export
runcodeUI <- function(...) {
  warning("shinyjs: `runcodeUI()` is now deprecated in favour of `runcode()`")
  runcode(...)
}

#' Deprecated - use `runcode()` instead
#' @export
runcodeServer <- function() {
  warning("shinyjs: `runcodeServer()` is now deprecated. You no longer need to call any function in the server, simply call `runcode()` in the UI.")
}
