colourPickerGadget <- function() {
  if (!requireNamespace("rstudioapi", quietly = TRUE)) {
    stop("You must have RStudio v0.99.878 or newer to use the colour picker",
         call. = FALSE)
  }

  viewer <- shiny::dialogViewer("Colour Picker", width = 800, height = 700)
  dir <- system.file("gadgets", "colourpicker", package = "shinyjs")
  shiny::runGadget(shiny::shinyAppDir(dir), viewer = viewer, stopOnCancel = FALSE)
}

#' Colour picker gadget
#'
#' This gadget lets you choose colours easily. You can select multiple colours,
#' and you can either choose any RGB colour, or browse through R colours.
#'
#' @note This gadget returns a vector of colours that can be assigned to a variable.
#' If instead you want to get a text representation of the colours that can
#' embedded into code, use the addin from the RStudio Addins menu.
#' @return Vector of selected colours
#' @export
#' @examples
#' if (interactive()) {
#'   cols <- colourPicker()
#' }
colourPicker <- function() {
  colourPickerGadget()
}

colourPickerAddin <- function() {
  col <- colourPickerGadget()
  text <- paste0("c(\"", paste(col, collapse = "\", \""), "\")")
  rstudioapi::insertText(text = text)
}
