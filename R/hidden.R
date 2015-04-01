#' @export
hidden <- function(tag) {
  if (!inherits(tag, "shiny.tag")) {
    errMsg("'tag' is not a valid Shiny tag")
  }

  tag <- shiny::tagAppendAttributes(
    tag,
    class = "shinyjs-hide")
  tag
}
