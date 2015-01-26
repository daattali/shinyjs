#TODO function like hideOnLoad thatll add "shinyjs-hide" class
#TODO similar function to add  onfocus="this.select()" to input
#TODO similar function to add href = "javascript:toggleVisibility('adminTableSection');",



# or should i use options() like devtools does?
pkgEnv <- new.env()
pkgEnv$session <- NULL

shinyjs <- function(...) {
  params <- as.list(match.call()[-1])
  if (!is.null(names(params)) && any(vapply(names(params), nzchar, 1L) == 0)) {
    stop("You cannot mix named and unnamed arguments in the same funtion call in shinyjs",
         call. = FALSE)
  }
  parentFrame <- parent.frame(1)
  params <- lapply(params, function(x){ eval(x, envir = parentFrame) })
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
setShinyjsSession <- function(session) {
  session$onSessionEnded(closeSession)
  pkgEnv$session <- session
}



#' @export
show <- shinyjs
#' @export
hide <- shinyjs
#' @export
toggle <- shinyjs

#' @export
addClass <- shinyjs
#' @export
removeClass <- shinyjs
#' @export
toggleClass <- shinyjs

#' @export
enable <- shinyjs
#' @export
disable <- shinyjs

#' @export
innerHTML <- shinyjs

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
    stop("Could not find shinyjs script file")
  }

  shiny::tags$head(
    shiny::tags$style(".shinyjs-hide { display: none; }"),
    shiny::includeScript(handler),
    shiny::tags$script(shiny::HTML(script)))
}
