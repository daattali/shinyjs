#' Set up a Shiny app to use shinyjs
#'
#' This function must be called from a Shiny app's UI in order for all other
#' \code{shinyjs} functions to work.\cr\cr
#' You can call \code{useShinyjs()} from anywhere inside the UI.
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
#' @param showLog Deprecated.
#' @return Scripts that \code{shinyjs} requires that are automatically inserted
#' to the app's \code{<head>} tag.
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
useShinyjs <- function(rmd = FALSE, debug = FALSE, html = FALSE,
                       showLog = NULL) {
  stopifnot(rmd == TRUE || rmd == FALSE)
  stopifnot(debug == TRUE || debug == FALSE)
  stopifnot(html == TRUE || html == FALSE)

  if (!missing(showLog)) {
    warning("'useShinyjs(showLog = TRUE)' has been deprecated. You do not need to call it anymore.",
            call. = FALSE)
  }

  # `astext` is FALSE in normal shiny apps where the shinyjs content is returned
  # as a shiny tag that gets rendered by the Shiny UI, and TRUE in interactive
  # Rmarkdown documents or in Shiny apps where the user builds the entire UI
  # manually with HTML, because in those cases the content of shinyjs needs to
  # be returned as plain text that can be added to the HTML
  .globals$astext <- rmd || html

  # inject is TRUE when the user builds the entire UI manually with HTML,
  # because in that case the shinyjs content needs to be injected into the page
  # using JavaScript
  .globals$inject <- html

  # all the default shinyjs methods that should be forwarded to javascript
  jsFuncs <- c("show", "hide", "toggle", "enable", "disable", "toggleState",
               "addClass", "removeClass", "toggleClass", "html", "onevent",
               "alert", "logjs", "runjs", "reset", "delay")

  # grab the file with all the default shinyjs javascript functions
  shiny::addResourcePath("shinyjs", system.file("srcjs", package = "shinyjs"))
  jsFile <- file.path("shinyjs", "shinyjs-default-funcs.js")

  # JavaScript to include to turn debug mode on/off (used for seeing more messages)
  if (debug) {
    initJS <- "shinyjs.debug = true;"
  } else {
    initJS <- "shinyjs.debug = false;"
  }

  # include CSS for hiding elements
  initCSS <- inlineCSS(".shinyjs-hide { display: none !important; }")

  # set up the message handlers and add some initial JS and CSS
  setupJS(jsFuncs, jsFile, initJS, initCSS)
}
