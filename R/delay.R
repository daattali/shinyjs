#' Execute R code after a specified number of milliseconds has elapsed
#'
#' You can use \code{delay} if you want to wait a specific amount of time before
#' running code.  This function can be used in combination with other \code{shinyjs}
#' functions, such as hiding or resetting an element in a few seconds, but it
#' can also be used with any code as long as it's used inside a Shiny app.
#'
#' @param ms The number of milliseconds to wait (1000 milliseconds = 1 second)
#' before running the expression.
#' @param expr The R expression to run after the specified number of milliseconds
#' has elapsed.
#'
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' if (interactive()) {
#'   runApp(shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),
#'       p(id = "text", "This text will disappear after 3 seconds"),
#'       actionButton("close", "Close the app in half a second")
#'     ),
#'     server = function(input, output) {
#'       delay(3000, hide("text"))
#'       observeEvent(input$close, {
#'         delay(500, stopApp())
#'       })
#'     }
#'   ))
#' }
#' @export
delay <- function(ms, expr) {
  ms <- round(ms)

  # get the Shiny session
  session <- getSession()
  hashable <- sprintf("%s_%s_%s_%s",
                      ms,
                      as.integer(Sys.time()),
                      as.integer(runif(1, 0, 1e7)),
                      deparse(substitute(expr)))
  hash <- digest::digest(hashable, algo = "md5")

  # send a call to JavaScript to let us know when the delay is up
  shinyInputId <- paste0("shinyjs-delay-", hash)
  session$sendCustomMessage("delay", list(ms = ms,
                                          shinyInputId = shinyInputId))

  # listen for a response from javascript when the delay is up
  shiny::observeEvent(session$input[[shinyInputId]], {
    expr
  })
}
