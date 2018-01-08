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
#' @param expr The R expression or function to run after the event is triggered.
#' If a function with an argument is provided, it will be called with the
#' JavaScript Event details as its argument. Using a function can be useful
#' when you want to know for example what key was pressed on a "keypress" event.
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
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       p(id = "date", "Click me to see the date"),
#'       p(id = "coords", "Click me to see the mouse coordinates"),
#'       p(id = "disappear", "Move your mouse here to make the text below disappear"),
#'       p(id = "text", "Hello")
#'     ),
#'     server = function(input, output) {
#'       onclick("date", alert(date()))
#'       onclick("coords", function(event) { alert(event) })
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

  # Make sure reset works with namespaces (shiny modules)
  if (inherits(session, "session_proxy")) {
    id <- session$ns(id)
  }

  # attach the event callback from JS to call this function to execute the
  # given expression. To support multiple event handlers, each time this
  # is called, a random number is attached to the Shiny input id
  shinyInputId <- sprintf("shinyjs-%s-%s-input-%s",
                          id,
                          as.integer(sample(1e9, 1)),
                          event)
  shinyInputIdJs <- shinyInputId
  if (inherits(session, "session_proxy")) {
    shinyInputIdJs <- session$ns(shinyInputIdJs)
  }
  session$sendCustomMessage("shinyjs-onevent", list(
                                            event = event,
                                            id = id,
                                            shinyInputId = shinyInputIdJs,
                                            add = add))

  # save the unevaluated expression so that it won't have a static value
  # every time the given event occurs
  expr <- deparse(expr)
  shiny::observeEvent(session$input[[shinyInputId]], {
    ret <- eval(parse(text = expr), envir = parentFrame)

    # If a callback function was provided, call it with the event as argument
    if (is.function(ret)) {
      if (length(formals(ret)) == 0) {
        ret()
      } else {
        event <- session$input[[shinyInputId]]
        event[['shinyjsRandom']] <- NULL
        ret(event)
      }
    }
    # If an expression was provided, evaluate it
    else {
      ret
    }
  })

  invisible(NULL)
}
