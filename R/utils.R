closeSession <- function() {
  assign(".session", NULL, shinyjsGlobals)
}
