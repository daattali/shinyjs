# This function is more complicated than the rest of the shinyjs functions and
# does not go through the same workflow since the JS layer needs to call Shiny back
#' @export
onclick <- function(id, expr, add = FALSE) {
  # grab the Shiny session that called us
  session <- get("session", parent.frame(1))

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

  observe({
    if (is.null(session$input[[shinyInputId]])) {
      return()
    }
    eval(parse(text = expr))
  })
}
