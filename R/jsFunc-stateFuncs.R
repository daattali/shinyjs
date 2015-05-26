#' Enable/disable an input element
#'
#' Enable or disable an input element. A disabled element is not usable and
#' not clickable, while an enabled element (default) can receive user input.
#' Any shiny input tag can be used with these functions, such as text inputs
#' (\code{shiny::textInput}), select lists (\code{shiny::selectInput}),
#' buttons (\code{shiny::actionButton}) and all others.\cr\cr
#' \strong{\code{enable}} enables an input, \strong{\code{disable}} disabled
#' an input,\strong{\code{toggleState}} enables an input if it is disabled
#' and disables an input if it is already enabled.\cr\cr
#' If \code{condition} is given to \code{toggleState}, that condition will be used
#' to determine if to enable or disable the input. The element will be enabled if
#' the condition evalutes to \code{TRUE} and disabled otherwise. If you find
#' yourself writing code such as \code{if (test()) enable(id) else disable(id)}
#' then you can use \code{toggleState} instead: \code{toggleState(id, test())}.
#'
#' @param ... The following parameters are available:
#' \tabular{ll}{
#'   \strong{\code{id}}         \tab The id of the input element/Shiny tag \cr
#'   \strong{\code{condition}}  \tab An optional argument to \code{toggleState},
#'                                   see 'Details' below. \cr
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
#'       shiny::observeEvent(input$btn, {
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
#'
#' ## toggleState can be given an optional `condition` argument, which
#' ## determines if to enable or disable the input
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),
#'       shiny::textInput("text", "Please type at least 3 characters"),
#'       shiny::actionButton("element", "Submit")
#'     ),
#'     server = function(input, output, session) {
#'       shiny::observe({
#'         toggleState(id = "element", condition = nchar(input$text) >= 3)
#'       })
#'     }
#'   )
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
