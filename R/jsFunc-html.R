#' Change the HTML (or text) inside an element
#'
#' Change the text or HTML inside an element.  The given HTML can be any
#' R expression, and it can either be appended to the currentcontents of the element
#' or overwrite it (default).
#'
#' @param id The id of the element/Shiny tag
#' @param html The HTML/text to place inside the element. Can be either simple
#' plain text or valid HTML code.
#' @param add If \code{TRUE}, then append \code{html} to the contents of the element;
#' otherwise overwrite it.
#' @param selector JQuery selector of the elements to target. Ignored if the \code{id}
#' argument is given.
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}}
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
#'         html("element", paste0("The date is ", date()))
#'       })
#'     }
#'   )
#' }
#' \dontrun{
#'   # The shinyjs function call in the above app can be replaced by
#'   # any of the following examples to produce similar Shiny apps
#'   html("element", "Hello!")
#'   html("element", " Hello!", TRUE)
#'   html("element", "<strong>bold</strong> that was achieved with HTML")
#'   local({val <- "some text"; html("element", val)})
#'   html(id = "element", add = TRUE, html = input$btn)
#' }
#' @export
html <- function(id = NULL, html = NULL, add = FALSE, selector = NULL) {
  fxn <- "html"
  params <- list(id = id, html = html, add = add, selector = selector)
  jsFuncHelper(fxn, params)
}
