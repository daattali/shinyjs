closeSession <- function() {
  assign(".session", NULL, shinyjsGlobals)
}

errMsg <- function(x) {
  stop(sprintf("shinyjs: %s", x), call. = FALSE)
}

isSession <- function(x) {
  inherits(x, "ShinySession")
}
