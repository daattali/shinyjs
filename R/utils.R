# TODO should i use options() like devtools does?
# TODO check if this works when multiple users are connected at the same time. deploy on shinyapps.io to test
shinyjsEnv <- new.env()
shinyjsEnv$session <- NULL

closeSession <- function() {
  shinyjsEnv$session <- NULL
}
