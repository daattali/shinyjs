# Prior to V0.0.2.0 this function was exported and was the preferred way
# to set the Shiny session when an app was local or had at most one session
# running at a time.  Since 0.0.2.0 a new approach to setting sessions
# is implemented and this is no longer needed. I want to keep this code around
# in case the new approach turns out to not always work. If an app needed more
# than one concurrent sessions, the session had to be passed as a parameter
# to every shinyjs function call. The new approach dynamically finds the session
# and completely abstracts this away from the user.

# Do not call this function if the Shiny app has multiple simultaneous users.
# It will not work when multiple sessions are active at the same time. You
# need to provide the session object to each function call.
# setSession <- function(session) {
#   if (!isSession(session)) {
#     errMsg("'session' is not a valid Shiny session")
#   }
#   session$onSessionEnded(closeSession)
#   assign(".session", session, shinyjsGlobals)
# }
