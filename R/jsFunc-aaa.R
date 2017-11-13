# main powerhorse that takes an R command and translates it to shinyjs JS function
jsFunc <- function(...) {
  params <- eval(substitute(alist(...)))

  if (!is.null(names(params)) && any(vapply(names(params), nzchar, 1L) == 0)) {
    errMsg(paste0("you cannot mix named and unnamed arguments in the same function call",
                  " (function: ", as.character(match.call()[1]), ")"))
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

  jsFuncHelper(fxn, params)
}

# similar to jsFunc, but here we already know the function name and parameters
jsFuncHelper <- function(fxn, params) {
  # get the Shiny session
  session <- getSession()

  fxn <- paste0("shinyjs-", fxn)

  # respect Shiny modules/namespaces
  if (inherits(session , "session_proxy")) {
    if ("id" %in% names(params)) {
      if (!"asis" %in% names(params) || !params[['asis']]) {
        params[['id']] <- session$ns(params[['id']])
      }
    }
  }

  # call the javascript function
  session$sendCustomMessage(
    type = fxn,
    message = params)

  invisible(NULL)
}
