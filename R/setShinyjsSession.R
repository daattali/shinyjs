#' @export
setShinyjsSession <- function(session) {
  if (!inherits(session, "ShinySession")) {
    stop("'session' is not a ShinySession object.", call. = FALSE)
  }
  session$onSessionEnded(closeSession)
  assign(".session", session, shinyjsGlobals)
}
