
#' @export
useShinyjs <- function() {
  # all the methods that should be forwarded to javascript
  supportedMethods <- c("show", "hide", "toggle", "enable", "disable",
                        "addClass", "removeClass", "toggleClass", "innerHTML")

  # add a shiny message handler binding for each supported method
  tpl <- paste0(
    "Shiny.addCustomMessageHandler('%s', function(params) {",
    " console.log(params);",
    " shinyjs.%s(params);",
    "});")
  controllers <-
    lapply(supportedMethods, function(x) {
      sprintf(tpl, x, x)})
  controllers <- paste(controllers, collapse = "\n")

  # grab the file with all the message handlers (javascript functions)
  handler <- try(
    system.file("templates", "shinyjs-message-handler.js", package = "shinyjs",
                mustWork = TRUE),
    silent = TRUE)
  if (class(handler) == "try-error") {
    errMsg("could not find shinyjs message handler file")
  }

  shiny::tags$head(
    # add custom CSS for hiding elements
    shiny::tags$style(".shinyjs-hide { display: none; }"),
    # add the message handler bindings
    shiny::tags$script(shiny::HTML(controllers)),
    # add the message handlers
    shiny::includeScript(handler)
  )
}
