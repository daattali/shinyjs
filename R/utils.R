# common way to print error messages
errMsg <- function(x) {
  stop(sprintf("shinyjs: %s", x), call. = FALSE)
}

# get the shiny session object
getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()
  if (is.null(session)) {
    errMsg(paste(
      "could not find the Shiny session object. This usually happens when a",
      "shinyjs function is called from a context that wasn't set up by a Shiny session."
    ))
  }
  session
}

# set up some javascript functions to work with shinyjs
setupJS <- function(jsFuncs, script, text, ...) {
  # add a shiny message handler binding for each supported method
  tpl <- paste0(
    "Shiny.addCustomMessageHandler('%s', function(params) {",
    " shinyjs.debugMessage('shinyjs: calling function \"%s\" with parameters:');",
    " shinyjs.debugMessage(params);",
    " shinyjs.%s(params);",
    "});")
  controllers <-
    lapply(jsFuncs, function(x) {
      sprintf(tpl, x, x, x)})
  controllers <- paste(controllers, collapse = "\n")

  # ensure the same scripts don't get added to the HTML twice
  shiny::singleton(
    insertHead(
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

# insert content into the <head> tag of the document if this is a proper HTML
# Shiny app, but if it's inside an interactive Rmarkdown document then don't
# use <head> as it won't work
insertHead <- function(...) {
  if (is.null(.globals$rmd) || .globals$rmd) {
    shiny::tagList(...)
  } else {
    shiny::tags$head(...)
  }
}

# include a JavaScript script
shinyjsInlcudeScript <- function(script) {
  if (missing(script) || is.null(script)) {
    return(NULL)
  } else {
    resourcePrefix <- sprintf("shinyjs-%s", digest::digest(script, algo = "md5"))
    shiny::addResourcePath(resourcePrefix, dirname(script))
    shiny::tags$script(src = file.path(resourcePrefix, basename(script)))
  }
}

# include a JavaScript string
shinyjsInlineScript <- function(text) {
  if (missing(text) || is.null(text)) {
    return(NULL)
  } else {
    shiny::tags$script(shiny::HTML(text))
  }
}
