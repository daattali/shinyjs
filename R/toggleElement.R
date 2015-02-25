#' @export
toggleElement <- function(a, id) {
  # check that this is an <a>
  a <- shiny::tagAppendAttributes(
    a,
    href = sprintf("javascript:shinyjs.toggle('%s');", id))
  a
}
