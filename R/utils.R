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

# Given a Shiny tag, add a class to all tags inside it
addClassEverywhere <- function(cls, name, ...) {
  addClassRecursive <- function(...) {
    tags <- rlang::list2(...)

    # recursively add the class to all tags
    if (length(tags) == 1 && inherits(tags[[1]], "shiny.tag")) {
      # don't do anything if an input has a head tag associated to it
      if (tags[[1]][['name']] == "head") {
        return(tags[[1]])
      }
      tags[[1]] <-
        shiny::tagAppendAttributes(
          tags[[1]],
          class = cls
        )
      return( tags[[1]] )
    } else if (length(tags) == 1 && inherits(tags[[1]], "html_dependency")) {
      return( tags[[1]] )
    } else if (length(tags) == 1 && inherits(tags[[1]], "shiny.tag.list")) {
      return( do.call(shiny::tagList, lapply(tags[[1]], addClassRecursive)) )
    } else if (length(tags) == 1 && is.list(tags[[1]])) {
      return( lapply(tags[[1]], addClassRecursive) )
    } else if (length(tags) > 1) {
      return( lapply(tags, addClassRecursive) )
    } else {
      errMsg(paste0("Invalid shiny tags given to `", name, "`"))
    }
  }
  addClassRecursive(...)
}

jsFuncTemplate <- function(funcs) {
  tpl <- paste0(
    "Shiny.addCustomMessageHandler('shinyjs-%s', function(params) {",
    " shinyjs.debugMessage('shinyjs: calling function \"%s\" with parameters:');",
    " shinyjs.debugMessage(params);",
    " shinyjs.%s(params);",
    "});")
  controllers <- lapply(funcs, function(x) { sprintf(tpl, x, x, x) })
  controllers <- paste(controllers, collapse = "\n")
  controllers
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
  } else if (is.character(script)) {
    shiny::tags$script(src = script)
  } else if (inherits(script, "html_dependency")) {
    script
  } else {
    stop("`script` must be either a URL or an `htmltools::htmlDependency()`", call. = FALSE)
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
