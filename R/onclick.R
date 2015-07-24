#' Run R code when an element is clicked
#'
#' Run an R expression (either a \code{shinyjs} function or any other code)
#' when an element is clicked.  The most sensible use case is to run code after
#' clicking a button or a link, but this function can be used on any other
#' HTML element as well.
#'
#' @param id The id of the element/Shiny tag
#' @param expr The R expression to run after the element gets clicked
#' @param add If \code{TRUE}, then add \code{expr} to be executed after any
#' other code that was previously set using \code{onclick}; otherwise
#' \code{expr} will overwrite any previous onclick expressions. This parameter
#' works well in browsers but is buggy when using the RStudio Viewer.
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' # Note these examples use several other shinyjs functions as the onclick code
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       shiny::actionButton("btn", "Click me"),
#'       shiny::p(id = "element", "Click me to change my text")
#'     ),
#'     server = function(input, output) {
#'       # Change the following lines for more examples
#'       onclick("btn", info(date()))
#'       onclick("element", text("element", "Hello!"))
#'     }
#'   )
#' }
#' \dontrun{
#'   # The shinyjs function call in the above app can be replaced by
#'   # any of the following examples to produce similar Shiny apps
#'   onclick("btn", toggle("element"))
#'   onclick(expr = text("element", date()), id = "btn")
#'   {onclick("btn", info(date())); onclick("btn", info("Another message"), TRUE)}
#' }
#' @export
onclick <- function(id, expr, add = FALSE) {
  # evaluate expressions in the caller's environment
  parentFrame <- parent.frame(1)

  # get the Shiny session
  session <- getSession()

  # attach an onclick callback from JS to call this function to execute the
  # given expression. To support multiple onclick handlers, each time this
  # is called, a random number is attached to the Shiny input id
  shinyInputId <- paste0("shinyjs-", id, "-", sample(1000000000, 1), "-input-clicked")
  session$sendCustomMessage("onclick", list(id = id,
                                            shinyInputId = shinyInputId,
                                            add = add))

  # save the unevaluated expression so that it won't have a static value
  # every time the given element is clicked
  expr <- deparse(substitute(expr))

  shiny::observeEvent(session$input[[shinyInputId]], {
    eval(parse(text = expr), envir = parentFrame)
  })

  invisible(NULL)
}
