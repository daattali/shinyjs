#' Initialize a Shiny tag as hidden
#'
#' Create a Shiny tag that is invisible when the Shiny app starts. The tag can
#' be made visible later with \code{shinyjs::toggle} or \code{shinyjs::show}.
#'
#' @param ... Shiny tag (or tagList or list of of tags) to make invisible
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{toggle}},
#' \code{\link[shinyjs]{show}},
#' \code{\link[shinyjs]{hide}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @return The tag (or tags) that was given as an argument in a hidden state.
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
#'     server = function(input, output) {
#'       shiny::observeEvent(input$btn, {
#'         show("element")
#'       })
#'     }
#'   )
#' }
#'
#' hidden(shiny::span(id = "a"), shiny::div(id = "b"))
#' hidden(shiny::tagList(shiny::span(id = "a"), shiny::div(id = "b")))
#' hidden(list(shiny::span(id = "a"), shiny::div(id = "b")))
#' @export
hidden <- function(...) {
  tags <- list(...)

  # recursively add the hidden class to all tags
  if (length(tags) == 1 && inherits(tags[[1]], "shiny.tag")) {
    tags[[1]] <-
      shiny::tagAppendAttributes(
        tags[[1]],
        class = "shinyjs-hide shinyjs-hidden-init"
      )
    return( tags[[1]] )
  } else if (length(tags) == 1 && is.list(tags[[1]])) {
    return( lapply(tags[[1]], hidden) )
  } else if (length(tags) > 1) {
    return( lapply(tags, hidden) )
  } else {
    errMsg("Invalid shiny tags given to `hidden`")
  }
}
