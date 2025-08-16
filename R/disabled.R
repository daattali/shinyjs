#' Initialize a Shiny input as disabled
#'
#' Create a Shiny input that is disabled when the Shiny app starts. The input can
#' be enabled later with [toggleState()] or [enable()].
#'
#' @param ... Shiny input (or tagList or list of of tags that include inputs) to
#' disable.
#' @seealso [useShinyjs()], [toggleState()], [enable()], [disable()]
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @return The tag (or tags) that was given as an argument in a disabled state.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       actionButton("btn", "Click me"),
#'       disabled(
#'         textInput("element", NULL, "I was born disabled")
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         enable("element")
#'       })
#'     }
#'   )
#' }
#'
#' library(shiny)
#' disabled(numericInput("num", NULL, 5), dateInput("date", NULL))
#' @export
disabled <- function(...) {
  addClassEverywhere("shinyjs-disabled", "disabled", ...)
}
