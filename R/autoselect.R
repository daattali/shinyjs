#' @export
autoselect <- function(input) {
  # check that input$children[[2]] is <input>
  input$children[[2]] <-
    shiny::tagAppendAttributes(input$children[[2]], onfocus = "this.select();")
  input
}
