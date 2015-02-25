NULL

# use this for clicking on examples and for "toggleElement".
# examples (in server.R):
# click("expr", "cat(date())")
# click("examples-list", "toggle('btn')")
# click("examples-list", "toggle('test')")
#' @export
click <- function(id, expr) {
  session <- get(".session", shinyjsGlobals)
  shinyInputId <- paste0("shinyjs-", id, "-input-clicked")
  session$sendCustomMessage("click", list(id = id,
                                          shinyInputId = shinyInputId))

  observe({
    if (is.null(session$input[[shinyInputId]])) {
      return()
    }
    eval(parse(text = expr))
  })
}

# Shiny.addCustomMessageHandler("click", function(message) {
#   var elId = "#" + message.id;
#   var shinyInputId = message.shinyInputId;
#   $(elId).attr("data-shinyjs-click", 0);
#   $(elId).click(function() {
#     $(elId).attr("data-shinyjs-click", parseInt($(elId).attr("data-shinyjs-click")) + 1)
#     Shiny.onInputChange(shinyInputId, parseInt($(elId).attr("data-shinyjs-click")));
#   });
# });

