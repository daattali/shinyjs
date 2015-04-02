errMsg <- function(x) {
  stop(sprintf("shinyjs: %s", x), call. = FALSE)
}

# This code was used prior to V0.0.2.0 - see 'setSession.R' file for details.
# closeSession <- function() {
#   assign(".session", NULL, shinyjsGlobals)
# }
#
# isSession <- function(x) {
#   # the dev version of Shiny which isn't on CRAN has a better check for shiny
#   # objects since I filed a bug report for it
#   if (compareVersion(as.character(packageVersion("shiny")), "0.11.1.9003") == -1) {
#     is.environment(x)
#   } else {
#     inherits(x, "ShinySession")
#   }
# }
