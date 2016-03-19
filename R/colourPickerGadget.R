colourPickerGadget <- function(numCols = 1) {
  if (!requireNamespace("rstudioapi", quietly = TRUE)) {
    stop("You must have RStudio v0.99.878 or newer to use the colour picker",
         call. = FALSE)
  }
  .globals$numCols <- numCols

  viewer <- shiny::dialogViewer("Colour Picker", width = 800, height = 700)
  dir <- system.file("gadgets", "colourpicker", package = "shinyjs")
  shiny::runGadget(shiny::shinyAppDir(dir), viewer = viewer, stopOnCancel = FALSE)
}

#' This is a gadget, you can have in your script: `cols <- colourPicker(3)`
#' @export
colourPicker <- function(numCols = 1) {
  colourPickerGadget(numCols)
}

colourPickerAddin <- function() {
  col <- colourPickerGadget()
  text <- paste0("c(\"", paste(col, collapse = "\", \""), "\")")
  rstudioapi::insertText(text = text)
}
