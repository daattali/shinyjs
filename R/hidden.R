#' Initialize a Shiny tag as hidden
#'
#' Create a Shiny tag that is invisible when the Shiny app starts. The tag can
#' be made visible later with \code{shinyjs::toggle} or \code{shinyjs::show}.
#'
#' @param tag Shiny tag to make invisible
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{toggle}},
#' \code{\link[shinyjs]{show}},
#' \code{\link[shinyjs]{hide}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @return The tag that was given as an argument in a hidden state.
#' @examples
#' if (interactive()) {
#'   shiny::shinyApp(
#'     ui = shiny::fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       shiny::actionButton("btn", "Click me"),
#'       hidden(
#'         shiny::p(id = "element", "I was born invisible")
#'       )
#'     ),
#'     server = function(input, output, session) {
#'       shiny::observeEvent(input$btn, {
#'         show("element")
#'       })
#'     }
#'   )
#' }
#' @export
hidden <- function(tag) {
  if (!inherits(tag, "shiny.tag")) {
    errMsg("'tag' is not a valid Shiny tag")
  }

  tag <- shiny::tagAppendAttributes(
    tag,
    class = "shinyjs-hide shinyjs-hidden-init")
  tag
}
