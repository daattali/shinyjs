#' Initialize a Shiny tag as hidden
#'
#' Create a Shiny tag that is invisible when the app starts.
#'
#' @param tag Shiny tag
#' @return The tag that was passed in as a parameter hidden
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
