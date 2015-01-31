jsFunc <- function(...) {
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
  shinyjsEnv$session$sendCustomMessage(
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
