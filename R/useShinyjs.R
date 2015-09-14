#' Set up a Shiny app to use shinyjs
#'
#' This function must be called from a Shiny app's UI in order for all other
#' \code{shinyjs} functions to work.\cr\cr
#' You can call \code{useShinyjs()} from anywhere inside the UI.
#'
#' @param rmd Set this to \code{TRUE} if you are using \code{shinyjs} inside an
#' interactive R markdown document. For regular Shiny apps use the
#' default value of \code{FALSE}.
#' @param debug Set this to \code{TRUE} if you want to see detailed debugging
#' statements in the JavaScript console. Can be useful when filing bug reports
#' to get more information about what is going on.
#' @return Scripts that \code{shinyjs} requires that are automatically inserted
#' to the app's \code{<head>} tag.
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       shiny::actionButton("btn", "Click me"),
#'       shiny::p(id = "element", "Watch what happens to me")
#'     ),
#'     server = function(input, output) {
#'       shiny::observe({
#'         if (input$btn == 0) {
#'           return(NULL)
#'         }
#'         # Run a simply shinyjs function
#'         toggle("element")
#'       })
#'     }
#'   )
#' }
#' @seealso \code{\link[shinyjs]{runExample}}
#' \code{\link[shinyjs]{extendShinyjs}}
#' @export
useShinyjs <- function(rmd = FALSE, debug = FALSE) {
  stopifnot(rmd == TRUE || rmd == FALSE)
  .globals$rmd <- rmd
  stopifnot(debug == TRUE || debug == FALSE)

  # all the default shinyjs methods that should be forwarded to javascript
  jsFuncs <- c("show", "hide", "toggle", "enable", "disable", "toggleState",
               "addClass", "removeClass", "toggleClass", "text",
               "onevent", "info", "logjs", "runjs", "reset", "delay")

  # grab the file with all the default shinyjs javascript functions
  jsFile <- system.file("srcjs", "shinyjs-default-funcs.js",
                        package = "shinyjs")
  if (jsFile == "") {
    errMsg("could not find shinyjs JavaScript file")
  }
  
  # JavaScript to include to turn debug mode on/off (used for seeing more messages)
  if (debug) {
    initJS <- "shinyjs.debug = true;" 
  } else {
    initJS <- "shinyjs.debug = false;"
  }
  
  # include CSS for hiding elements
  initCSS <- inlineCSS(".shinyjs-hide { display: none; }")
  
  # set up the message handlers and add some initial JS and CSS
  setupJS(jsFuncs, jsFile, initJS, initCSS)
}
