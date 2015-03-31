# TODO(daattali) This method will only work if there is only one session at a time
# if this is an app shared with multiple people, this won't work
#' @export
setShinyjsSession <- function(session) {
  if (!isSession(session)) {
    errMsg("'session' is not a ShinySession object.")
  }
  session$onSessionEnded(closeSession)
  assign(".session", session, shinyjsGlobals)
}
