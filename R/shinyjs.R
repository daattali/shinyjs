# or should i use options() like devtools does?
pkgEnv <- new.env()
pkgEnv$session <- NULL

shinyjs <- function(...) {
  params <- as.list(match.call()[-1])
  if (is.null(names(params))) {
    params <- unlist(params)
  }
  print(params)
  pkgName <- "shinyjs"
  regex <- sprintf("^(%s:{2,3})((\\w)+)$", pkgName)
  fxn <- as.character(as.list(match.call()[1]))
  fxn <- sub(regex, "\\2", fxn)
  pkgEnv$session$sendCustomMessage(
    type = fxn,
    message = params)
}

closeSession <- function() {
  pkgEnv$session <- NULL
}

#' @export
setSession <- function(session) {
  session$onSessionEnded(closeSession)
  pkgEnv$session <- session
}

#' @export
show <- shinyjs
#' @export
hide <- shinyjs
#' @export
enable <- shinyjs
#' @export
disable <- shinyjs





#' @export
useShinyjs <- function() {
  #includeScript(file.path('www', 'shinyjs-message-handler.js'))
  supportedMethods <- c("show", "hide", "enable", "disable")
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
    stop("Could not find shinyjs script file")
  }

  shiny::tags$head(
    shiny::tags$style(".shinyjs-hide { display: none; }"),
    shiny::includeScript(handler),
    shiny::tags$script(shiny::HTML(script)))
}
