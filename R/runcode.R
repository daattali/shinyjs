#' Construct to let you run arbitrary R code live in a Shiny app
#'
#' Sometimes when developing a Shiny app, it's useful to be able to run some R
#' code on-demand. This construct provides your app with a text input where you
#' can enter any R code and run it immediately.\cr\cr
#' This can be useful for testing
#' and while developing an app locally, but it \strong{should not be included in
#' an app that is accessible to other people}, as letting others run arbitrary R
#' code can open you up to security attacks.\cr\cr
#' To use this construct, you must add a call to \code{runcodeUI()} in the UI
#' of your app, and a call to \code{runcodeServer()} in the server function. You
#' also need to initialize shinyjs with a call to \code{useShinyjs()} in the UI.
#'
#' If a function is provided to the \code{preprocss} argument of
#' \code{runcodeServer}, this will be called on the user-provided R code before
#' evaluating it.  This allows, for instance, conversion of non-ASCII open and
#' closing quote characters (unhelpfully) created by some browsers to standard
#' ASCII quote characters (see the second example).
#'
#' If \code{show_output=TRUE}, the results of executing the R code will be
#' placed into \code{output$runcode_output} using \code{shiny::renderText} to
#' allow you to display this, if desired, by adding
#' \code{textOutput("runcode_output", container=pre)} to the UI of your
#' app (see the second example).
#'
#' @note You can only have one \code{runcode} construct in your shiny app.
#' Calling this function multiple times within the same app will result in
#' unpredictable behaviour.
#'
#' @param code The initial R code to show in the text input when the app loads
#' @param type One of \code{"text"} (default), \code{"textarea"}, or \code{"ace"}.
#' When using a text input, the R code will be limited to be typed within a single line,
#' and is the recommended option. Textarea should be used if you want to write
#' long multi-line R code. Note that you can run multiple expressions even in
#' a single line by appending each R expression with a semicolon.
#' Use of the \code{"ace"} option requires the \code{shinyAce} package.
#' @param width The width of the editable code input (ignored when
#' \code{type="ace"})
#' @param height The height of the editable code input (ignored when
#' \code{type="text"})
#' @param includeShinyjs Set this to \code{TRUE} only if your app does not have
#' a call to \code{useShinyjs()}. If you are already calling \code{useShinyjs()}
#' in your app, do not use this parameter.
#' @param show_output If \code{TRUE} the results of executing the R code will be
#' placed into \code{output$runcode_output} using \code{shiny::renderText} to
#' allow display via adding \code{textOutput("runcode_output", container=pre)}.
#' @param preprocessor Function accepting a single vector argument, which will
#' be called on the user-provided R code before evaluating it.
#' @seealso \code{\link[shinyjs]{useShinyjs}}
#' @examples
#'
#' # One-line of code, no display of output
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       runcodeUI(code = "shinyjs::alert('Hello!')")
#'     ),
#'     server = function(input, output) {
#'       runcodeServer()
#'     }
#'   )
#' }
#'
#' # Muti-line code - pre-process input to convert non-ASCII character to ASCII
#' # and then display output as if entered on the console
#' if (interactive()) {
#'   library(shiny)
#'   library(stringi)
#'
#'   to_ascii <- function(x) stri_trans_general(x, "Any-Latin; Latin-ASCII")
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       shiny::tags$label("R code to execute:"),
#'       useShinyjs(),  # Set up shinyjs
#'       runcodeUI(code = "shinyjs::alert('Hello!')\nx <- rnorm(10)\nstem(x)",
#'                 type = "textarea",
#'                 height="10em",
#'                 width="80em"),
#'       shiny::tags$br(),
#'       shiny::tags$label("Output:"),
#'       textOutput("runcode_output", container=pre)
#'     ),
#'     server = function(input, output) {
#'       runcodeServer(show_output=TRUE, preprocess=to_ascii)
#'     }
#'   )
#' }
#' @name runcode

#' @rdname runcode
#' @export
runcodeUI <- function(code = "",
                      type = c("text", "textarea", "ace"),
                      width = NULL,
                      height = NULL,
                      includeShinyjs = FALSE) {
  type <- match.arg(type)

	if (type == "ace") {
	  if (!requireNamespace("shinyAce", quietly = TRUE)) {
	    errMsg("You need to install the 'shinyAce' package in order to use 'shinyAce' editor.")
	  }
	}

  placeholder <- "Enter R code"
  shiny::singleton(shiny::tagList(
    if (includeShinyjs)
      useShinyjs(),
    if (type == "text")
      shiny::textInput(
        "runcode_expr", label = NULL, value = code,
        width = width, placeholder = placeholder
      ),
    if (type == "textarea")
      shiny::textAreaInput(
        "runcode_expr", label = NULL, value = code,
        width = width, height = height, placeholder = placeholder
      ),
    if (type == "ace")
			shinyAce::aceEditor("runcode_expr", mode = 'r', value = code,
				height = height, theme = "github", fontSize = 16),
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
runcodeServer <- function(show_output=FALSE, preprocessor=NULL) {
  # evaluate expressions in the caller's environment
  parentFrame <- parent.frame(1)

  # get the Shiny session
  session <- getSession()

  shiny::observeEvent(session$input[['runcode_run']], {
    shinyjs::hide("runcode_error")

    tryCatch(
      shiny::isolate({
        expr_text <- session$input[['runcode_expr']]
        if(is.function(preprocessor))
          expr_text <- preprocessor(expr_text)

        output <- paste0(
          capture.output(
            do.call(withAutoprint,
                    list(parse(text=expr_text)),
                    envir=parentFrame)
          ),
          collapse="\n")

        if(show_output)
          session$output$runcode_output <- renderText(output)
      }
      ),
      error = function(err) {
        shinyjs::html("runcode_errorMsg", as.character(err$message))
        shinyjs::show(id = "runcode_error", anim = TRUE, animType = "fade")
      }
    )
  })

  invisible(NULL)
}
