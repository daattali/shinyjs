# main powerhorse that takes an R command and translates it to shinyjs JS function
jsFunc <- function(...) {
  params <- eval(substitute(alist(...)))

  if (!is.null(names(params)) && any(vapply(names(params), nzchar, 1L) == 0)) {
    errMsg("you cannot mix named and unnamed arguments in the same function call")
  }

  # evaluate the parameters in the appropriate environment
  parentFrame <- parent.frame(1)
  params <- lapply(params, function(x){ eval(x, envir = parentFrame) })

  # figure out what JS function to call, make sure to work with namespacing as well
  pkgName <- "shinyjs"
  extensionName <- "js"
  regex <- sprintf("^(%s:{2,3})?(%s\\$)?((\\w)+)$", pkgName, extensionName)
  fxn <- as.character(as.list(match.call()[1]))
  fxn <- sub(regex, "\\3", fxn)

  # grab the Shiny session from the caller - I'm assuming this will always work
  # and correctly get the sessin. If there are cases where this doesn't work,
  # can revert back to the approach pre V0.0.2.0 where the session was set
  # manually
  session <- dynGetCopy("session")

  # call the javascript function
  session$sendCustomMessage(
    type = fxn,
    message = params)

  invisible(NULL)
}
