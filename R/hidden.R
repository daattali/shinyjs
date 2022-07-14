#' Initialize a Shiny tag as hidden
#'
#' Create a Shiny tag that is invisible when the Shiny app starts. The tag can
#' be made visible later with [toggle()] or [show()].
#'
#' @param ... Shiny tag (or tagList or list of of tags) to make invisible
#' @seealso [useShinyjs()], [toggle()], [show()], [hide()]
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @return The tag (or tags) that was given as an argument in a hidden state.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       actionButton("btn", "Click me"),
#'       hidden(
#'         p(id = "element", "I was born invisible")
#'       )
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         show("element")
#'       })
#'     }
#'   )
#' }
#'
#' library(shiny)
#' hidden(span(id = "a"), div(id = "b"))
#' hidden(tagList(span(id = "a"), div(id = "b")))
#' hidden(list(span(id = "a"), div(id = "b")))
#' @export
hidden <- function(...) {
  tags <- rlang::list2(...)

  # recursively add the hidden class to all tags
  if (length(tags) == 1 && inherits(tags[[1]], "shiny.tag")) {
    tags[[1]] <-
      shiny::tagAppendAttributes(
        tags[[1]],
        class = "shinyjs-hide"
      )
    return( tags[[1]] )
  } else if (length(tags) == 1 && inherits(tags[[1]], "html_dependency")) {
    return( tags[[1]] )
  } else if (length(tags) == 1 && inherits(tags[[1]], "shiny.tag.list")) {
    return( do.call(shiny::tagList, lapply(tags[[1]], hidden)) )
  } else if (length(tags) == 1 && is.list(tags[[1]])) {
    return( lapply(tags[[1]], hidden) )
  } else if (length(tags) > 1) {
    return( lapply(tags, hidden) )
  } else {
    errMsg("Invalid shiny tags given to `hidden`")
  }
}
