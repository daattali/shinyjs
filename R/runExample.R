#' Run shinyjs examples
#'
#' Launch a shinyjs example Shiny app that allows you to see how to use easily
#' use shinyjs in an app.
#'
#' @param example The add to launch
#' @return NULL
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

  invisible(NULL)
}
