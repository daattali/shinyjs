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
#' @param id The id of the Shiny tag
#' @param anim if TRUE then animate the behaviour
#' @param animType The type of animation to use, one of 'slide' or 'fade'
#' @param time The number of seconds to make the animation last.
#' @usage
#' show(id, anim = FALSE, animType = "slide", time = 0.5)
#'
#' hide(id, anim = FALSE, animType = "slide", time = 0.5)
#'
#' toggle(id, anim = FALSE, animType = "slide", time = 0.5)
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
#'   \describe{
#'     \item{\strong{id}}{id of the Shiny tag}
#'     \item{class}{CSS class}
#'   }
#' \tabular{ll}{
#'   \code{\strong{first}}         \tab if of the shiny tag \cr
#'   \code{\strong{second item}}   \tab asdfdsaf dsadsa fdsa fasfa \cr
#'    }
#'   \itemize{
#'     \item \strong{First} item
#'     \item Second item
#'   }
#' @param class The CSS class
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
