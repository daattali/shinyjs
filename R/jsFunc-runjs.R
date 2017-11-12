#' Run JavaScript code
#'
#' Run arbitrary JavaScript code.
#'
#' @param code JavaScript code to run.
#' @seealso \code{\link[shinyjs]{useShinyjs}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       actionButton("btn", "Click me")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         # Run JS code that simply shows a message
#'         runjs("var today = new Date(); alert(today);")
#'       })
#'     }
#'   )
#' }
#' @export
runjs <- function(code) {
  fxn <- "runjs"
  params <- list(code = code)
  jsFuncHelper(fxn, params)
}
