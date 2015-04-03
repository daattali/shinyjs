# This function is more complicated than the rest of the shinyjs functions and
# does not go through the same workflow since the JS layer needs to call Shiny back
#' @export
onclick <- function(id, expr) {
  # grab the Shiny session that called us
  session <- get("session", parent.frame(1))

  # attach an onclick callback from JS to call this function to execute the
  # given expression
  shinyInputId <- paste0("shinyjs-", id, "-input-clicked")
  session$sendCustomMessage("onclick", list(id = id,
                                            shinyInputId = shinyInputId))

  observe({
    if (is.null(session$input[[shinyInputId]])) {
      return()
    }
    eval(parse(text = expr))
  })
}
