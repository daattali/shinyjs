
#' @export
useShinyjs <- function() {
  #includeScript(file.path('www', 'shinyjs-message-handler.js'))
  supportedMethods <- c("show", "hide", "toggle", "enable", "disable",
                        "addClass", "removeClass", "toggleClass", "innerHTML")
  tpl <- paste0(
    "Shiny.addCustomMessageHandler('%s', function(params) {console.log(params);",
    " shinyjs.%s(params); ",
    "});")
  controllers <-
    lapply(supportedMethods, function(x) {
      sprintf(tpl, x, x)})
  controllers <- paste(controllers, collapse = "\n")

  script <- controllers

  handler <- try(
    system.file("templates", "shinyjs-message-handler.js", package = "shinyjs",
                mustWork = TRUE),
    silent = TRUE)
  if (class(handler) == "try-error") {
    errMsg("could not find shinyjs script file")
  }

  shiny::tags$head(
    shiny::tags$style(".shinyjs-hide { display: none; }"),
    shiny::includeScript(handler),
    shiny::tags$script(shiny::HTML(script)))
}
