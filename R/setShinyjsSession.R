#' @export
setShinyjsSession <- function(session) {
  session$onSessionEnded(closeSession)
  assign(".session", session, shinyjsGlobals)
}
