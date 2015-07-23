errMsg <- function(x) {
  stop(sprintf("shinyjs: %s", x), call. = FALSE)
}

# try grabbing the session var from a parent frame, which should work
# assuming the shinyServer function defines a "session" param
getSession <- function(x) {
  session <- dynGetCopy("session")
  if (is.null(session)) {
    errMsg(paste(
      "could not find `session` object in the server function.",
      "Are you sure you defined the Shiny server function as",
      "`server = function(input, output, session)`?"
    ))
  }
  session
}

# This is a copy of the base::dynGet function, but since it's new in R3.2.0
# I want to include this copy so that users of older R can still use it
dynGetCopy <- function (x) {
  n <- sys.nframe()
  while (n > 1L) {
    n <- n - 1L
    env <- sys.frame(n)
    if (exists(x, envir = env)) {
      return(get(x, envir = env))
    }
  }
  return(NULL)
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

  # ensure the same scripts don't get added to the HTML twice
  shiny::singleton(
    shiny::tags$head(
      # add the message handlers
      shiny::tags$script(shiny::HTML(controllers)),
      # add the actual javascript code
      shinyjsInlcudeScript(script),
      shinyjsInlineScript(text),
      # add any extra tags
      ...
    )
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
