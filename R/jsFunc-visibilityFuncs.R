#' Display/hide an element
#'
#' Display or hide an HTML element.\cr\cr
#' \strong{\code{show}} makes an element visible, \strong{\code{hide}} makes
#' an element invisible, \strong{\code{toggle}} displays the element if it it
#' hidden and hides it if it is visible.\cr\cr
#' If \code{condition} is given to \code{toggle}, that condition will be used
#' to determine if to show or hide the element. The element will be shown if the
#' condition evaluates to \code{TRUE} and hidden otherwise. If you find
#' yourself writing code such as \code{if (test()) show(id) else hide(id)}
#' then you can use \code{toggle} instead: \code{toggle(id = id, condition = test())}.
#'
#' If you want to hide/show an element in a few seconds rather than immediately,
#' you can use the \code{\link[shinyjs]{delay}} function.
#'
#' @param id The id of the element/Shiny tag
#' @param anim If \code{TRUE} then animate the behaviour (default: \code{FALSE})
#' @param animType The type of animation to use, either \code{"slide"} or \code{"fade"}
#' (default: \code{"slide"})
#' @param time The number of seconds to make the animation last (default: \code{0.5})
#' @param selector JQuery selector of the elements to show/hide. Ignored if the
#' \code{id} argument is given. For example, to select all span elements with
#' class x, use \code{selector = "span.x"}
#' @param condition An optional argument to \code{toggle}, see 'Details' below.
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}},
#' \code{\link[shinyjs]{hidden}},
#' \code{\link[shinyjs]{delay}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       actionButton("btn", "Click me"),
#'       p(id = "element", "Watch what happens to me")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         # Change the following line for more examples
#'         toggle("element")
#'       })
#'     }
#'   )
#' }
#' \dontrun{
#'   # The shinyjs function call in the above app can be replaced by
#'   # any of the following examples to produce similar Shiny apps
#'   toggle(id = "element")
#'   delay(1000, toggle(id = "element")) # toggle in 1 second
#'   toggle("element", TRUE)
#'   toggle("element", TRUE, "fade", 2)
#'   toggle(id = "element", time = 1, anim = TRUE, animType = "slide")
#'   show("element")
#'   show(id = "element", anim = TRUE)
#'   hide("element")
#'   hide(id = "element", anim = TRUE)
#' }
#'
#' ## toggle can be given an optional `condition` argument, which
#' ## determines if to show or hide the element
#' if (interactive()) {
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),
#'       checkboxInput("checkbox", "Show the text", TRUE),
#'       p(id = "element", "Watch what happens to me")
#'     ),
#'     server = function(input, output) {
#'       observe({
#'         toggle(id = "element", condition = input$checkbox)
#'       })
#'     }
#'   )
#' }
#' @name visibilityFuncs
NULL

#' @export
#' @rdname visibilityFuncs
show <- function(id = NULL, anim = FALSE, animType = "slide", time = "0.5", selector = NULL) {
  fxn <- "show"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}

#' @export
#' @rdname visibilityFuncs
hide <- function(id = NULL, anim = FALSE, animType = "slide", time = "0.5", selector = NULL) {
  fxn <- "hide"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}

#' @export
#' @rdname visibilityFuncs
toggle <- function(id = NULL, anim = FALSE, animType = "slide", time = "0.5", selector = NULL, condition = NULL) {
  fxn <- "toggle"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}
