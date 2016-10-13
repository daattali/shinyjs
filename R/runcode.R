#' Construct to let you run arbitrary R code live in a Shiny app
#'
#' Sometimes when developing a Shiny app, it's useful to be able to run some R
#' code on-demand. This construct provides your app with a text input where you
#' can enter any R code and run it immediately.\cr\cr
#' This can be useful for testing
#' and while developing an app locally, but it \emph{should not be included in
#' an app that is accessible to other people}, as letting others run arbitrary R
#' code can open you up to security attacks.\cr\cr
#' To use this construct, you must add a call to \code{runcodeUI()} in the UI
#' of your app, and a call to \code{runcodeServer()} in the server function. You
#' also need to initialize shinyjs with a call to \code{useShinyjs()}.
#'
#' @param code The initial R code to show in the text input when the app loads
#' @param type One of \code{"text"} (default) or \code{"textarea"}. When using
#' a text input, the R code will be limited to be typed within a single line,
#' and is the recommended option. Textarea should be used if you want to write
#' long multi-line R code. Note that you can run multiple expressions even in
#' a single line by appending each R expression with a semicolon.
#' @param width The width of the text or textarea input
#' @param height The height of the textarea input (only applicable when
#' \code{type="textarea"})
#' @seealso \code{\link[shinyjs]{useShinyjs}}
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       runcodeUI(code = "shinyjs::info('Hello!')")
#'     ),
#'     server = function(input, output) {
#'       runcodeServer()
#'     }
#'   )
#' }
#' @name runcode

#' @rdname runcode
#' @export
runcodeUI <- function(code = "",
                      type = c("text", "textarea"),
                      width = NULL,
                      height = NULL) {
  type <- match.arg(type)
  placeholder <- "Enter R code"

  shiny::singleton(shiny::tagList(
    if(type == "text")
      shiny::textInput(
        "runcode_expr", label = NULL, value = code,
        width = width, placeholder = placeholder
      ),
    if(type == "textarea")
      shiny::textAreaInput(
        "runcode_expr", label = NULL, value = code,
        width = width, height = height, placeholder = placeholder
      ),
    shiny::actionButton("runcode_run", "Run", class = "btn-success"),
    shinyjs::hidden(
      shiny::div(
        id = "runcode_error",
        style = "color: red; font-weight: bold;",
        shiny::div("Oops, that resulted in an error! Try again."),
        shiny::div("Error: ", shiny::br(),
                   shiny::tags$i(shiny::span(
                     id = "runcode_errorMsg", style = "margin-left: 10px;")))
      )
    )
  ))
}

#' @rdname runcode
#' @export
runcodeServer <- function() {
  # evaluate expressions in the caller's environment
  parentFrame <- parent.frame(1)

  # get the Shiny session
  session <- getSession()

  shiny::observeEvent(session$input[['runcode_run']], {
    shinyjs::hide("runcode_error")

    tryCatch(
      shiny::isolate(
        eval(parse(text = session$input[['runcode_expr']]), envir = parentFrame)
      ),
      error = function(err) {
        shinyjs::html("runcode_errorMsg", as.character(err$message))
        shinyjs::show(id = "runcode_error", anim = TRUE, animType = "fade")
      }
    )
  })

  invisible(NULL)
}
