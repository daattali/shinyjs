#' Run R code when an event is triggered on an element
#'
#' \code{onclick} runs an R expression (either a \code{shinyjs} function or any other code)
#' when an element is clicked.\cr\cr
#' \code{onevent} is similar, but can be used when any event is triggered on the element,
#' not only a mouse click. See below for a list of possible event types. Using "click"
#' results in the same behaviour as calling \code{onclick}.
#'
#' @param event The event that needs to be triggered to run the code. See below
#' for a list of possible event types.
#' @param id The id of the element/Shiny tag
#' @param expr The R expression to run after the event is triggered
#' @param add If \code{TRUE}, then add \code{expr} to be executed after any
#' other code that was previously set using \code{onevent} or \code{onclick}; otherwise
#' \code{expr} will overwrite any previous expressions. Note that this parameter
#' works well in web browsers but is buggy when using the RStudio Viewer.
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @section Possible event types:
#' Any \href{http://api.jquery.com/category/events/mouse-events/}{mouse} or
#' \href{http://api.jquery.com/category/events/keyboard-events/}{keyboard} events
#' that are supported by JQuery can be used. The full list of events that can be used is:
#' \code{click}, \code{dblclick}, \code{hover}, \code{mousedown}, \code{mouseenter},
#' \code{mouseleave}, \code{mousemove}, \code{mouseout}, \code{mouseover}, \code{mouseup},
#' \code{keydown}, \code{keypress}, \code{keyup}.
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       shiny::p(id = "date", "Click me to see the date"),
#'       shiny::p(id = "disappear", "Move your mouse here to make the text below disappear"),
#'       shiny::p(id = "text", "Hello")
#'     ),
#'     server = function(input, output) {
#'       onclick("date", info(date()))
#'       onevent("mouseenter", "disappear", hide("text"))
#'       onevent("mouseleave", "disappear", show("text"))
#'     }
#'   )
#' }
#' \dontrun{
#'   # The shinyjs function call in the above app can be replaced by
#'   # any of the following examples to produce similar Shiny apps
#'   onclick("disappear", toggle("text"))
#'   onclick(expr = text("date", date()), id = "date")
#' }
#' @name onevent

#' @rdname onevent
#' @export
onclick <- function(id, expr, add = FALSE) {
  oneventHelper("click", id, substitute(expr), add)
}

#' @rdname onevent
#' @export
onevent <- function(event, id, expr, add = FALSE) {
  oneventHelper(event, id, substitute(expr), add)
}

oneventHelper <- function(event, id, expr, add) {
  # evaluate expressions in the caller's environment
  parentFrame <- parent.frame(2)

  # get the Shiny session
  session <- getSession()

  #################################
  # TODO only do this if shiny version is at least xxx
  #################################

  # Make sure reset works with namespecing (shiny modules)
  id <- session$ns(id)

  # attach the event callback from JS to call this function to execute the
  # given expression. To support multiple event handlers, each time this
  # is called, a random number is attached to the Shiny input id
  shinyInputId <- paste0("shinyjs-", id, "-", as.integer(stats::runif(1, 0, 1e9)), "-input-", event)
  session$sendCustomMessage("onevent", list(event = event,
                                            id = id,
                                            shinyInputId = session$ns(shinyInputId),
                                            add = add))

  # save the unevaluated expression so that it won't have a static value
  # every time the given event occurs
  expr <- deparse(expr)
  shiny::observeEvent(session$input[[shinyInputId]], {
    eval(parse(text = expr), envir = parentFrame)
  })

  invisible(NULL)
}
