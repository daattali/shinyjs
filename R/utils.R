errMsg <- function(x) {
  stop(sprintf("shinyjs: %s", x), call. = FALSE)
}

# get the shiny session object
getSession <- function() {
  session <- getDefaultReactiveDomain()
  if (is.null(session)) {
    errMsg(paste(
      "could not find the Shiny session object. This usually happens when a",
      "shinyjs function is called from a context that wasn't set up by a Shiny session."
    ))
  }
  session
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
