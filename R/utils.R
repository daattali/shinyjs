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

# set up some javascript functions to work with shinyjs and any other resources
setupJS <- function(jsFuncs, script, text, ...) {
  # add a shiny message handler binding for each supported method
  tpl <- paste0(
    "Shiny.addCustomMessageHandler('shinyjs-%s', function(params) {",
    " shinyjs.debugMessage('shinyjs: calling function \"%s\" with parameters:');",
    " shinyjs.debugMessage(params);",
    " shinyjs.%s(params);",
    "});")
  controllers <-
    lapply(jsFuncs, function(x) {
      sprintf(tpl, x, x, x)})
  controllers <- paste(controllers, collapse = "\n")

  # ensure the same scripts don't get added to the HTML twice
  shinyjsContent <-
    #shiny::singleton(
      tagList(
        # add the message handlers
        shiny::tags$script(shiny::HTML(controllers)),
        # add the actual javascript code
        shinyjsInlcudeScript(script),
        shinyjsInlineScript(text),
        # add any extra tags
        ...
      )

  shinyjsContent
}

# insert content into the <head> tag of the document if this is a proper HTML
# Shiny app, but if it's inside an interactive Rmarkdown document then don't
# use <head> as it won't work
insertHead <- function(...) {
  runtime <- knitr::opts_knit$get("rmarkdown.runtime")
  if (!is.null(runtime) && runtime == "shiny") {
    # we're inside an Rmd document
    shiny::tagList(...)
  } else {
    # we're in a shiny app
    shiny::tags$head(...)
  }
}

# include a JavaScript script
shinyjsInlcudeScript <- function(script) {
  if (missing(script) || is.null(script)) {
    return(NULL)
  } else {
    shiny::tags$script(src = script)
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

# names of JS functions defined by shinyjs
shinyjsFunctionNames <- function(type = c("all", "core")) {
  type <- match.arg(type)

  # core functions are defined in JS and exported in R
  jsFuncs <- c(
    "show", "hide", "toggle", "enable", "disable", "toggleState",
    "addClass", "removeClass", "toggleClass", "html", "onevent", "removeEvent",
    "alert", "logjs", "runjs", "reset", "delay", "click", "refresh"
  )

  if (type == "all") {
    jsFuncs <- c(
      jsFuncs,
      # additional functions which are only defined on the JS side
      "debug", "debugMessage", "getParams", "initShinyjs"
    )
  }

  jsFuncs
}
