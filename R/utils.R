errMsg <- function(x) {
  stop(sprintf("shinyjs: %s", x), call. = FALSE)
}

closeSession <- function() {
  assign(".session", NULL, shinyjsGlobals)
}

isSession <- function(x) {
  inherits(x, "ShinySession")
}
