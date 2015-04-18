#' Set up a Shiny app to use shinyjs
#'
#' This function must be called from a Shiny app's UI in order for all other
#' \code{shinyjs} functions to work.
#'
#' @return Scripts that \code{shinyjs} requires that are automatically inserted
#' to the app's \code{<head>} tag.
#' @examples
#' shiny::shinyUI(
#'   useShinyjs()
#' )
#'
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
#' @export
useShinyjs <- function() {
  # all the methods that should be forwarded to javascript
  jsFuncs <- c("show", "hide", "toggle", "enable", "disable", "toggleState",
               "addClass", "removeClass", "toggleClass", "text",
               "onclick", "info", "logjs")

  # add a shiny message handler binding for each supported method
  tpl <- paste0(
    "Shiny.addCustomMessageHandler('%s', function(params) {",
    " shinyjs.%s(params);",
    "});")
  controllers <-
    lapply(jsFuncs, function(x) {
      sprintf(tpl, x, x)})
  controllers <- paste(controllers, collapse = "\n")

  # grab the file with all the message handlers (javascript functions)
  handler <- system.file("srcjs", "shinyjs-message-handler.js",
                         package = "shinyjs")
  if (handler == "") {
    errMsg("could not find shinyjs message handler file")
  }

  shiny::tags$head(
    # add custom CSS for hiding elements
    shiny::tags$style(".shinyjs-hide { display: none; }"),
    # add the message handler bindings
    shiny::tags$script(shiny::HTML(controllers)),
    # add the message handlers
    shiny::includeScript(handler)
  )
}
