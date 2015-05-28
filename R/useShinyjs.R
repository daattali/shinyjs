#' Set up a Shiny app to use shinyjs
#'
#' This function must be called from a Shiny app's UI in order for all other
#' \code{shinyjs} functions to work.
#'
#' @return Scripts that \code{shinyjs} requires that are automatically inserted
#' to the app's \code{<head>} tag.
#' @note When initializing the Shiny app's server, you must supply the
#' \code{session} parameter to the server function, ie. initialize the server
#' as \code{server = function(input, output, session)} rather than
#' \code{server = function(input, output)}
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       shiny::actionButton("btn", "Click me"),
#'       shiny::p(id = "element", "Watch what happens to me")
#'     ),
#'     server = function(input, output, session) {
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
useShinyjs <- function() {
  # all the default shinyjs methods that should be forwarded to javascript
  jsFuncs <- c("show", "hide", "toggle", "enable", "disable", "toggleState",
               "addClass", "removeClass", "toggleClass", "text",
               "onclick", "info", "logjs", "runjs", "reset")

  # grab the file with all the default shinyjs javascript functions
  jsFile <- system.file("srcjs", "shinyjs-default-funcs.js",
                        package = "shinyjs")
  if (jsFile == "") {
    errMsg("could not find shinyjs JavaScript file")
  }

  # set up the message handlers for all functions and add custom CSS for hiding elements
  setupJS(jsFuncs, jsFile, NULL,
          inlineCSS(".shinyjs-hide { display: none; }"))
}
