#' Enable/disable an input element
#'
#' Enable or disable an input element. A disabled element is not usable and
#' not clickable, while an enabled element (default) can receive user input.
#' Many input tags can be used with these functions, such as text inputs
#' (\code{shiny::textInput}), select lists (\code{shiny::selectInput}),
#' buttons (\code{shiny::actionButton}) and many others.
#'
#' \strong{\code{enable}} enables an input, \strong{\code{disable}} disabled
#' an input,\strong{\code{toggleState}} enables an input if it is disabled
#' and disables an input if it is already enabled.
#'
#' @param ... The following parameters are available:
#' \tabular{ll}{
#'   \strong{\code{id}}     \tab The id of the input element/Shiny tag \cr
#' }
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       shiny::actionButton("btn", "Click me"),
#'       shiny::textInput("element", "Watch what happens to me")
#'     ),
#'     server = function(input, output, session) {
#'       shiny::observe({
#'         if (input$btn == 0) {
#'           return(NULL)
#'         }
#'         # Change the following line for more examples
#'         toggleState("element")
#'       })
#'     }
#'   )
#' }
#' \dontrun{
#'   # The shinyjs function call in the above app can be replaced by
#'   # any of the following examples to produce similar Shiny apps
#'   toggleState(id = "element")
#'   enable("element")
#'   disable("element")
#'
#'   # Similarly, the "element" text input can be changed to many other
#'   # input tags, such as the following examples
#'   shiny::actionButton("element", "I'm a button")
#'   shiny::fileInput("element", "Choose a file")
#'   shiny::selectInput("element", "I'm a select box", 1:10)
#' }
#' @name stateFuncs
NULL

#' @export
#' @rdname stateFuncs
enable <- jsFunc
#' @export
#' @rdname stateFuncs
disable <- jsFunc
#' @export
#' @rdname stateFuncs
toggleState <- jsFunc
