# connected and disconnected and sessioninitialized don't work because shiny is not ready yet/has already been killed
#' @export
onshiny <- function(event, expr, id = NULL, asis = FALSE) {
  # get the Shiny session
  session <- getSession()

  # Make sure onshiny works with namespaces (shiny modules)
  if (inherits(session, "session_proxy")) {
    if (!is.null(id) && !asis) {
      id <- session$ns(id)
    }
  }

  hashable <- sprintf("%s_%s_%s_%s",
                      id,
                      as.integer(Sys.time()),
                      as.integer(sample(1e9, 1)),
                      deparse(substitute(expr)))
  hash <- digest::digest(hashable, algo = "md5")

  # send a call to JavaScript to register this event
  shinyInputId <- paste0("shinyjs-onshiny-cb-", hash)
  shinyInputIdJs <- shinyInputId
  if (inherits(session, "session_proxy")) {
    shinyInputIdJs <- session$ns(shinyInputIdJs)
  }

  session$sendCustomMessage(
    "shinyjs-onshiny",
    list(
      event = event,
      id = id,
      shinyInputId = shinyInputIdJs
    )
  )

  # listen for a response from javascript when the event occurs
  shiny::observeEvent(session$input[[shinyInputId]], {
    cat('HERE')
   expr
  })

  invisible(NULL)
}