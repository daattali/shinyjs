jsFunc <- function(...) {
  params <- eval(substitute(alist(...)))

  if (!is.null(names(params)) && any(vapply(names(params), nzchar, 1L) == 0)) {
    errMsg("you cannot mix named and unnamed arguments in the same function call")
  }

  # evaluate the parameters in the appropriate environment
  parentFrame <- parent.frame(1)
  params <- lapply(params, function(x){ eval(x, envir = parentFrame) })

  # figure out what function to call, make sure to work with namespacing as well
  pkgName <- "shinyjs"
  regex <- sprintf("^(%s:{2,3})((\\w)+)$", pkgName)
  fxn <- as.character(as.list(match.call()[1]))
  fxn <- sub(regex, "\\2", fxn)

  # grab the Shiny session from the caller - I'm assuming this will always work
  # and correctly get the sessin. If there are cases where this doesn't work,
  # can revert back to the approach pre V0.0.2.0 where the session was set
  # manually
  session <- get("session", parentFrame)

  # call the javascript function
  session$sendCustomMessage(
    type = fxn,
    message = params)

  invisible(NULL)
}

#' Display/hide an element
#'
#' Display or hide an HTML element.
#'
#' show makes an element visible, hide makes an element invisible, toggle
#' displays the element if it it hidden and hides it if it is visible.
#'
#' @param ... The following parameters are available:
#' \tabular{ll}{
#'   \strong{\code{id}}         \tab The id of the Shiny tag \cr
#'   \strong{\code{anim}}       \tab If TRUE then animate the behaviour \cr
#'   \strong{\code{animType}}   \tab The type of animation to use,
#'                                   one of 'slide' or 'fade' \cr
#'   \strong{\code{time}}       \tab The number of seconds to make the
#'                                   animation last. \cr
#' }
#' @section Passing arguments:
#' The arguments can be passed either named or unnamed
#' @name visibilityFuncs
NULL

#' @export
#' @rdname visibilityFuncs
show <- jsFunc
#' @export
#' @rdname visibilityFuncs
hide <- jsFunc
#' @export
#' @rdname visibilityFuncs
toggle <- jsFunc

#' Add/remove CSS class
#'
#' Add or remove a CSS class from an HTML element.
#'
#' addClass adds a CSS class, removeClass removes a cssClass, toggleClass
#' adds the class if it is not set and removes the class if it is already
#' set.
#'
#' @param ... The following parameters are available:
#' \tabular{ll}{
#'   \strong{\code{first}}         \tab if of the shiny tag \cr
#'   \strong{\code{second item}}   \tab asdfdsaf dsadsa fdsa fasfa \cr
#' }
#' @name classFuncs
NULL

#' @export
#' @rdname classFuncs
addClass <- jsFunc
#' @export
#' @rdname classFuncs
removeClass <- jsFunc
#' @export
#' @rdname classFuncs
toggleClass <- jsFunc

#' @export
enable <- jsFunc
#' @export
disable <- jsFunc

#' @export
innerHTML <- jsFunc

#' @export
alert <- jsFunc
#' @export
logjs <- jsFunc
