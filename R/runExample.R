#' Run shinyjs examples
#'
#' Launch a \code{shinyjs} example Shiny app that shows how to
#' easily use \code{shinyjs} in an app.
#'
#' Run without any arguments to see a list of available example apps.
#' The "demo" example is also
#' \href{http://daattali.com:3838/shinyjs-demo/}{available online}
#' to experiment with.
#'
#' @param example The app to launch
#' @examples
#' ## Only run this example in interactive R sessions
#' if (interactive()) {
#'   # List all available example apps
#'   runExample()
#'
#'   runExample("sandbox")
#'   runExample("demo")
#' }
#' @export
runExample <- function(example) {

  validExamples <-
    paste0(
      'Valid examples are: "',
      paste(list.files(system.file("examples", package = "shinyjs")),
            collapse = '", "'),
      '"')

  if (missing(example) || !nzchar(example)) {
    message('Please run `runExample()` with a valid example app as an argument.\n',
            validExamples)
    return(invisible(NULL))
  }

  appDir <- system.file("examples", example,
                         package = "shinyjs")
  if (appDir == "") {
    errMsg(sprintf("could not find example app `%s`\n%s",
                   example, validExamples))
  }

  shiny::runApp(appDir, display.mode = "normal")

  invisible(NULL)
}
