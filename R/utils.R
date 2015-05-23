errMsg <- function(x) {
  stop(sprintf("shinyjs: %s", x), call. = FALSE)
}

# try grabbing the session var from the parent frame, which should almost
# always work, assuming the shinyServer function defines a "session"
# param and that the shinyjs function was called from the shinyServer
# function rather than from a helper function. If called from a helper
# function, we need to climb up the parent frames until we find session.
# We can use the dynGet function for that, but it's new since R 3.2.0
# so instead I'm copying dynGet's code.
dynGetCopy <- function (x) {
  n <- sys.nframe()
  while (n > 1L) {
    n <- n - 1L
    env <- sys.frame(n)
    if (exists(x, envir = env)) {
      return(get(x, envir = env))
    }
  }
  stop(gettextf("%s not found", sQuote(x)))
}
