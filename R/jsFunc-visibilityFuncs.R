#' Display/hide an element
#'
#' Display or hide an HTML element.\cr\cr
#' \strong{\code{show}} makes an element visible, \strong{\code{hide}} makes
#' an element invisible, \strong{\code{toggle}} displays the element if it it
#' hidden and hides it if it is visible.\cr\cr
#' \strong{\code{showElement}}, \strong{\code{hideElement}}, and
#' \strong{\code{toggleElement}} are synonyms that may be safer to use if you're
#' working with S4 classes (since they don't mask any existing S4 functions).\cr\cr
#' If \code{condition} is given to \code{toggle}, that condition will be used
#' to determine if to show or hide the element. The element will be shown if the
#' condition evaluates to \code{TRUE} and hidden otherwise. If you find
#' yourself writing code such as \code{if (test()) show(id) else hide(id)}
#' then you can use \code{toggle} instead: \code{toggle(id = id, condition = test())}.
#'
#' If you want to hide/show an element in a few seconds rather than immediately,
#' you can use the \code{\link[shinyjs]{delay}} function.
#'
#' @note If you use S4 classes, you should be aware of the fact that both S4 and
#' \code{shinyjs} use the \code{show()} function. This means that when using S4,
#' it is recommended to use \code{showElement()} from \code{shinyjs}, and to
#' use \code{methods::show()} for S4 object.
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
#'       textInput("text", "Text")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         # Change the following line for more examples
#'         toggle("text")
#'       })
#'     }
#'   )
#' }
#' \dontrun{
#'   # The shinyjs function call in the above app can be replaced by
#'   # any of the following examples to produce similar Shiny apps
#'   toggle(id = "text")
#'   delay(1000, toggle(id = "text")) # toggle in 1 second
#'   toggle("text", TRUE)
#'   toggle("text", TRUE, "fade", 2)
#'   toggle(id = "text", time = 1, anim = TRUE, animType = "slide")
#'   show("text")
#'   show(id = "text", anim = TRUE)
#'   hide("text")
#'   hide(id = "text", anim = TRUE)
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
show <- function(id, anim, animType, time, selector) {
  fxn <- "show"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}

#' @export
#' @rdname visibilityFuncs
showElement <- function(id, anim, animType, time, selector) {
  fxn <- "show"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}

#' @export
#' @rdname visibilityFuncs
hide <- function(id, anim, animType, time, selector) {
  fxn <- "hide"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}

#' @export
#' @rdname visibilityFuncs
hideElement <- function(id, anim, animType, time, selector) {
  fxn <- "hide"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}

#' @export
#' @rdname visibilityFuncs
toggle <- function(id, anim, animType, time, selector, condition) {
  fxn <- "toggle"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}

#' @export
#' @rdname visibilityFuncs
toggleElement <- function(id, anim, animType, time, selector, condition) {
  fxn <- "toggle"
  params <- as.list(match.call())[-1]
  jsFuncHelper(fxn, params)
}
