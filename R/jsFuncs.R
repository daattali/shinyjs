jsFunc <- function(..., session = NULL) {
  params <- list(...)

  # see if the last parameter is an unnamed shiny session
  if (missing(session) && length(params) > 0 && isSession(tail(params, 1)[[1]])) {
    session <- tail(params, 1)[[1]]
    params <- head(params, -1)
  }

  if (!is.null(names(params)) && any(vapply(names(params), nzchar, 1L) == 0)) {
    errMsg("you cannot mix named and unnamed arguments in the same function call")
  }

  # evaluate the parameters in the appropriate environment
  parentFrame <- parent.frame(1)
  params <- lapply(params, function(x){ eval(x, envir = parentFrame) })

  # figure out what function to call
  pkgName <- "shinyjs"
  regex <- sprintf("^(%s:{2,3})((\\w)+)$", pkgName)
  fxn <- as.character(as.list(match.call()[1]))
  fxn <- sub(regex, "\\2", fxn)

  # TODO can this one little line be the solution to all my problems??
  # does it reliably always get the correct session object that fired this call?
  #session <- get("session", parent.frame(1))

  # get the shiny session that should run this expression
  if (is.null(session)) {
    if (!exists(".session", shinyjsGlobals)) {
      errMsg("you need to either provide a session or call shinyjs::setSession() first")
    }
    session <- get(".session", shinyjsGlobals)
  } else {
    if (!isSession(session)) {
      errMsg("'session' is not a valid Shiny session")
    }
  }

  # call the javascript function
  session$sendCustomMessage(
    type = fxn,
    message = params)
}

#' @export
show <- jsFunc
#' @export
hide <- jsFunc
#' @export
toggle <- jsFunc

#' @export
addClass <- jsFunc
#' @export
removeClass <- jsFunc
#' @export
toggleClass <- jsFunc

#' @export
enable <- jsFunc
#' @export
disable <- jsFunc

#' @export
innerHTML <- jsFunc
