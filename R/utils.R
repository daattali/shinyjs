errMsg <- function(x) {
  stop(sprintf("shinyjs: %s", x), call. = FALSE)
}

# try grabbing the session var from the parent frame, which should almost
# always work, assuming the shinyServer function defines a "session"
# param and that the shinyjs function was called from the shinyServer
# function rather than from a helper function. If called from a helper
# function, we need to climb up the parent frames until we find session.
# We can use the dynGet function for that, but it's new since R 3.2.0
# so instead I'm copying dynGet's code.
dynGetCopy <- function (x) {
  n <- sys.nframe()
  while (n > 1L) {
    n <- n - 1L
    env <- sys.frame(n)
    if (exists(x, envir = env)) {
      return(get(x, envir = env))
    }
  }
  stop(gettextf("%s not found", sQuote(x)))
}

setupJS <- function(jsFuncs, script, text, ...) {
  # add a shiny message handler binding for each supported method
  tpl <- paste0(
    "Shiny.addCustomMessageHandler('%s', function(params) {",
    " shinyjs.%s(params);",
    "});")
  controllers <-
    lapply(jsFuncs, function(x) {
      sprintf(tpl, x, x)})
  controllers <- paste(controllers, collapse = "\n")
  
  shiny::tags$head(
    # add the message handlers
    shiny::tags$script(shiny::HTML(controllers)),
    # add the actual javascript code
    shinyjsInlcudeScript(script),
    shinyjsInlineScript(text),
    # add any extra tags
    ...
  )
}

shinyjsInlcudeScript <- function(script) {
  if (missing(script) || is.null(script)) {
    return(NULL)
  } else {
    shiny::includeScript(script)
  }
}

shinyjsInlineScript <- function(text) {
  if (missing(text) || is.null(text)) {
    return(NULL)
  } else {
    shiny::tags$script(shiny::HTML(text))
  }
}