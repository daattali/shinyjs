#' Run shinyjs examples \[DEPRECATED\]
#'
#' Launch a \code{shinyjs} example Shiny app that shows how to
#' easily use \code{shinyjs} in an app.\cr\cr
#' Run without any arguments to see a list of available example apps.
#' The "demo" example is also
#' \href{https://daattali.com/shiny/shinyjs-demo/}{available online}
#' to experiment with.\cr\cr
#' **Deprecation Notice:** This function is no longer required since Shiny version
#' 1.8.1 (March 2024). This function will be removed in a future release of \{shinyjs\}.
#' You can use `shiny::runExample("demo", package = "shinyjs")` instead of
#' `shinyjs::runExample("demo")`.
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
  message("WARNING: `shinyjs::runExample()` is deprecated. Please upgrade to {shiny} version 1.8.1 ",
          "and use `shiny::runExample(package = \"shinyjs\")` instead.\n")

  validExamples <-
    paste0(
      'Valid examples are: "',
      paste(list.files(system.file("examples-shiny", package = "shinyjs")),
            collapse = '", "'),
      '"')

  if (missing(example) || !nzchar(example)) {
    message(
      'Please run `runExample()` with a valid example app as an argument.\n',
      validExamples)
    return(invisible(NULL))
  }

  appDir <- system.file("examples-shiny", example,
                         package = "shinyjs")
  if (appDir == "") {
    errMsg(sprintf("could not find example app `%s`\n%s",
                   example, validExamples))
  }

  shiny::runApp(appDir, display.mode = "normal")
}
