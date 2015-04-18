jsFunc <- function(...) {
  params <- eval(substitute(alist(...)))

  if (!is.null(names(params)) && any(vapply(names(params), nzchar, 1L) == 0)) {
    errMsg("you cannot mix named and unnamed arguments in the same function call")
  }

  # evaluate the parameters in the appropriate environment
  parentFrame <- parent.frame(1)
  params <- lapply(params, function(x){ eval(x, envir = parentFrame) })

  # figure out what function to call, make sure to work with namespacing as well
  pkgName <- "shinyjs"
  regex <- sprintf("^(%s:{2,3})((\\w)+)$", pkgName)
  fxn <- as.character(as.list(match.call()[1]))
  fxn <- sub(regex, "\\2", fxn)

  # grab the Shiny session from the caller - I'm assuming this will always work
  # and correctly get the sessin. If there are cases where this doesn't work,
  # can revert back to the approach pre V0.0.2.0 where the session was set
  # manually
  session <- get("session", parentFrame)

  # call the javascript function
  session$sendCustomMessage(
    type = fxn,
    message = params)

  invisible(NULL)
}

# --- Below is only documentation for all functions that are aliased to jsFunc

#' Display/hide an element
#'
#' Display or hide an HTML element.
#'
#' \strong{\code{show}} makes an element visible, \strong{\code{hide}} makes
#' an element invisible, \strong{\code{toggle}} displays the element if it it
#' hidden and hides it if it is visible.
#'
#' @param ... The following parameters are available:
#' \tabular{ll}{
#'   \strong{\code{id}}         \tab The id of the element/Shiny tag \cr
#'   \strong{\code{anim}}       \tab If TRUE then animate the behaviour
#'                                   (default: \code{FALSE}) \cr
#'   \strong{\code{animType}}   \tab The type of animation to use,
#'                                   either "slide" or "fade"
#'                                   (default: \code{"slide"})\cr
#'   \strong{\code{time}}       \tab The number of seconds to make the
#'                                   animation last.
#'                                   (default: \code{0.5}) \cr
#' }
#' @seealso \code{\link[shinyjs]{useShinyjs}}
#' @seealso \code{\link[shinyjs]{runExample}}
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
#'   toggle("element", TRUE)
#'   toggle("element", TRUE, "fade", 2)
#'   toggle(id = "element", time = 1, anim = TRUE, animType = "slide")
#'   show("element")
#'   show(id = "element", anim = TRUE)
#'   hide("element")
#'   hide(id = "element", anim = TRUE)
#' }
#' @name visibilityFuncs
NULL

#' @export
#' @rdname visibilityFuncs
show <- jsFunc
#' @export
#' @rdname visibilityFuncs
hide <- jsFunc
#' @export
#' @rdname visibilityFuncs
toggle <- jsFunc

#' Add/remove CSS class
#'
#' Add or remove a CSS class from an HTML element.
#'
#' \strong{\code{addClass}} adds a CSS class, \strong{\code{removeClass}}
#' removes a cssClass,\strong{\code{toggleClass}} adds the class if it is
#' not set and removes the class if it is already set.
#'
#' CSS is a simple way to describe how elements on a web page should be
#' displayed (position, colour, size, etc.).  You can learn the basics
#' at \href{http://www.w3schools.com/css/}{W3Schools}.
#'
#' @param ... The following parameters are available:
#' \tabular{ll}{
#'   \strong{\code{id}}     \tab The id of the element/Shiny tag \cr
#'   \strong{\code{class}}  \tab The CSS class to add/remove \cr
#' }
#' @seealso \code{\link[shinyjs]{useShinyjs}}
#' @seealso \code{\link[shinyjs]{runExample}}
#' @seealso \code{\link[shinyjs]{hidden}}
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       # Add a CSS class for red text colour
#'       tags$head(tags$style(HTML("
#'         .red { background: red; }
#'       "))),
#'       shiny::actionButton("btn", "Click me"),
#'       shiny::p(id = "element", "Watch what happens to me")
#'     ),
#'     server = function(input, output, session) {
#'       shiny::observe({
#'         if (input$btn == 0) {
#'           return(NULL)
#'         }
#'         # Change the following line for more examples
#'         toggleClass("element", "red")
#'       })
#'     }
#'   )
#' }
#' \dontrun{
#'   # The shinyjs function call in the above app can be replaced by
#'   # any of the following examples to produce similar Shiny apps
#'   toggleClass(class = "red", id = "element")
#'   addClass("element", "red")
#'   removeClass("element", "red")
#' }
#' @name classFuncs
NULL

#' @export
#' @rdname classFuncs
addClass <- jsFunc
#' @export
#' @rdname classFuncs
removeClass <- jsFunc
#' @export
#' @rdname classFuncs
toggleClass <- jsFunc

#' Enable/disable an input element
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

#' @export
text <- jsFunc

#' @export
message <- jsFunc
#' @export
logjs <- jsFunc
