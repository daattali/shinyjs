#' @export
runExample <- function(example = "sandbox") {

  if (missing(example)) {
    message("No example was explicitly given, using the default 'sandbox'.\n",
            "Available examples are: '",
            paste(list.files(system.file("examples", package = "shinyjs")),
                  collapse = "', '"),
            "'")
  }

  appDir <- system.file("examples", example,
                         package = "shinyjs")
  if (appDir == "") {
    errMsg("could not find example app directory")
  }
  shiny::runApp(appDir, display.mode = "normal")
}
