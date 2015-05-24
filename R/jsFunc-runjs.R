#' Run JavaScript code
#'
#' Run arbitrary JavaScript code. This is mainly useful when developing and
#' debugging a Shiny app, as it is generally considered dangerous to expose
#' a way for end users to evaluate arbitrary code.
#'
#' @param ... The following parameters are available:
#' \tabular{ll}{
#'   \strong{\code{code}}  \tab JavaScript code to run.
#' }
#' @seealso \code{\link[shinyjs]{useShinyjs}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       shiny::actionButton("btn", "Click me")
#'     ),
#'     server = function(input, output, session) {
#'       shiny::observeEvent(input$btn, {
#'         # Run JS code that simply shows a message
#'         runjs("var today = new Date(); alert(today);")
#'       })
#'     }
#'   )
#' }
#' @export
runjs <- jsFunc
