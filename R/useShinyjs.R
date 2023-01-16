#' Set up a Shiny app to use shinyjs
#'
#' This function must be called from a Shiny app's UI in order for all other
#' \code{shinyjs} functions to work.\cr\cr
#' You can call \code{useShinyjs()} from anywhere inside the UI, as long as the
#' final app UI contains the result of \code{useShinyjs()}.
#'
#' If you're a package author and including \code{shinyjs} in a function in your
#' your package, you need to make sure \code{useShinyjs()} is called either by
#' the end user's Shiny app or by your function's UI.
#'
#' To enable debug mode for shinyjs, set `options("shinyjs.debug" = TRUE)`.
#'
#' @param ... Used to catch deprecated arguments.
#' @return Scripts that \code{shinyjs} requires that are automatically inserted
#' to the app's \code{<head>} tag.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       actionButton("btn", "Click me"),
#'       textInput("element", "Watch what happens to me")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         # Run a simply shinyjs function
#'         toggle("element")
#'       })
#'     }
#'   )
#' }
#' @seealso \code{\link[shinyjs]{runExample}}
#' \code{\link[shinyjs]{extendShinyjs}}
#' @export
useShinyjs <- function(...) {
  params <- eval(substitute(alist(...)))
  if ("rmd" %in% names(params)) {
    warning("*** Good news! ***\nAs of shinyjs v3 (January 2023), the `rmd` parameter is no longer needed.\nPlease remove it from your code.")
  }
  if ("html" %in% names(params)) {
    warning("*** Good news! ***\nAs of shinyjs v3 (January 2023), the `html` parameter is no longer needed.\nPlease remove it from your code.")
  }
  if ("debug" %in% names(params)) {
    warning("As of shinyjs v3 (January 2023), the `debug` parameter is no longer in use. Instead, use `options(\"shinyjs.debug\" = TRUE)`.")
  }

  # all the default shinyjs methods that should be forwarded to javascript
  jsFuncs <- shinyjsFunctionNames("core")
  jsCodeFuncs <- jsFuncTemplate(jsFuncs)

  jsCodeVersion <- paste0("shinyjs.version = '", as.character(utils::packageVersion("shinyjs")), "';")
  if (identical(getOption("shinyjs.debug", FALSE), TRUE)) {
    jsCodeDebug <- "shinyjs.debug = true;"
  } else {
    jsCodeDebug <- "shinyjs.debug = false;"
  }

  jsCode <- paste(
    jsCodeVersion,
    jsCodeDebug,
    jsCodeFuncs,
    sep = "\n"
  )

  # include CSS for hiding elements
  cssCode <- ".shinyjs-hide { display: none !important; }"

  shinyjsContent <- htmltools::htmlDependency(
    name = "shinyjs-binding",
    version = as.character(utils::packageVersion("shinyjs")),
    package = "shinyjs",
    src = "srcjs",
    script = "shinyjs-default-funcs.js",
    head = paste0(
      "<script>", jsCode, "</script>",
      "<style>", cssCode, "</style>"
    )
  )

  shiny::tagList(
    shinyjsContent
  )
}
