#' @export
runExample <- function() {
  example <- "sandbox"
  appDir <- system.file("examples", example,
                         package = "shinyjs")
  if (appDir == "") {
    errMsg("could not find example app directory")
  }
  shiny::runApp(appDir, display.mode = "normal")
}
