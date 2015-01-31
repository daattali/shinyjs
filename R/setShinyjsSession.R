#' @export
setShinyjsSession <- function(session) {
  session$onSessionEnded(closeSession)
  shinyjsEnv$session <- session
}
