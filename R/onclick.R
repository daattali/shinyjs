#' Add an onclick event handler
#'
#' Run an R expression when an HTML element is clicked
#'
#' @param id The id of the HTML element
#' @param expr The R expression to run after the element gets clicked
#' @param add If TRUE, add expr to be executed after any previously set onclick
#' handlers; otherwise (the default) expr will overwrite any previous onclick
#' expressions
#' @export
onclick <- function(id, expr, add = FALSE) {
  # evaluate expressions in the caller's environment
  parentFrame <- parent.frame(1)

  # grab the Shiny session that called us
  session <- get("session", parentFrame)

  # attach an onclick callback from JS to call this function to execute the
  # given expression. To support multiple onclick handlers, each time this
  # is called, a random number is attached to the Shiny input id
  shinyInputId <- paste0("shinyjs-", id, "-", sample(1000000000, 1), "-input-clicked")
  session$sendCustomMessage("onclick", list(id = id,
                                            shinyInputId = shinyInputId,
                                            add = add))

  # save the unevaluated expression so that it won't have a static value
  # every time the given element is clicked
  expr <- deparse(substitute(expr))

  shiny::observe({
    if (is.null(session$input[[shinyInputId]])) {
      return()
    }
    eval(parse(text = expr), envir = parentFrame)
  })

  invisible(NULL)
}
