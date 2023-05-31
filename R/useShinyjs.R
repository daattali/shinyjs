#' Set up a Shiny app to use shinyjs
#'
#' This function must be called from a Shiny app's UI in order for all other
#' \code{shinyjs} functions to work.\cr\cr
#' You can call \code{useShinyjs()} from anywhere inside the UI, as long as the
#' final app UI contains the result of \code{useShinyjs()}.
#'
#' If you're a package author and including \code{shinyjs} in a function in your
#' your package, you need to make sure \code{useShinyjs()} is called either by
#' the end user's Shiny app or by your function's UI.
#'
#' @param rmd Set this to \code{TRUE} only if you are using \code{shinyjs}
#' inside an interactive R markdown document. If using this option, view the
#' \href{https://github.com/daattali/shinyjs}{README} online to learn how to
#' use shinyjs in R markdown documents.
#' @param debug Set this to \code{TRUE} if you want to see detailed debugging
#' statements in the JavaScript console. Can be useful when filing bug reports
#' to get more information about what is going on.
#' @param html Set this to \code{TRUE} only if you are using \code{shinyjs} in
#' a Shiny app that builds the entire user interface with a custom HTML file. If
#' using this option, view the
#' \href{https://github.com/daattali/shinyjs}{README} online to learn
#' how to use shinyjs in these apps.
#' @return Scripts that \code{shinyjs} requires that are automatically inserted
#' to the app's \code{<head>} tag. A side effect of calling this function is that
#' a \code{shinyjs} directory is added as a resource path using
#' [shiny::addResourcePath()].
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       actionButton("btn", "Click me"),
#'       textInput("element", "Watch what happens to me")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         # Run a simply shinyjs function
#'         toggle("element")
#'       })
#'     }
#'   )
#' }
#' @seealso \code{\link[shinyjs]{runExample}}
#' \code{\link[shinyjs]{extendShinyjs}}
#' @export
useShinyjs <- function(rmd = FALSE, debug = FALSE, html = FALSE, force = FALSE) {
  stopifnot(identical(force, TRUE) || identical(force, FALSE))

  if (!force) {
    errMsg(paste0("*** Good news! ***\n\n",
                  "As of {shinyjs} v4.0 (January 2023), you no longer need to call `useShinyjs()`.\n",
                  "Please remove this line from your code.\n",
                  "If you really want to pre-load {shinyjs}, use `useShinyjs(force = TRUE)`.\n",
                  "IMPORTANT: If using the `reset()` function, you need to call `initReset()` in the UI."))
  }

  # TODO debug becomes an option instead of a parameter


  # all the default shinyjs methods that should be forwarded to javascript
  jsFuncs <- shinyjsFunctionNames("core")

  # grab the file with all the default shinyjs javascript functions
  shiny::addResourcePath("shinyjs", system.file("srcjs", package = "shinyjs"))
  jsFile <- file.path("shinyjs", "shinyjs-default-funcs.js")

  # JavaScript to include to turn debug mode on/off (used for seeing more messages)
  if (debug) {
    initJS <- "shinyjs.debug = true;"
  } else {
    initJS <- "shinyjs.debug = false;"
  }

  # Add the shinyjs package version as a debugging tool
  initJS <- paste0(initJS, "shinyjs.version = '", as.character(utils::packageVersion("shinyjs")), "';")

  # include CSS for hiding elements
  initCSS <- inlineCSS(".shinyjs-hide { display: none !important; }")

  # set up the message handlers and add some initial JS and CSS
  setupJS(jsFuncs, jsFile, initJS, initCSS)
}
