# Do not call this function if the Shiny app has multiple simultaneous users.
# It will not work when multiple sessions are active at the same time. You
# need to provide the session object to each function call.
#' @export
setSession <- function(session) {
  if (!isSession(session)) {
    errMsg("'session' is not a valid Shiny session")
  }
  session$onSessionEnded(closeSession)
  assign(".session", session, shinyjsGlobals)
}
