#' @export
resettable <- function(tag) {
  if (!inherits(tag, "shiny.tag")) {
    errMsg("'tag' is not a valid Shiny tag")
  }

  tag <- shiny::tagAppendAttributes(
    tag,
    class = "shinyjs-resettable-init")
  tag
}

#' @export
reset <- function(id) {
  # grab the Shiny session that called us
  session <- dynGetCopy("session")
  shinyInputId <- paste0("shinyjs-resettable-", id)
  session$sendCustomMessage("reset", list(id = id))

  shiny::observeEvent(session$input[[shinyInputId]], {
    messages <- session$input[[shinyInputId]]

    lapply(
      names(messages),
      function(x) {
        type <- messages[[x]][['type']]
        value <- messages[[x]][['value']]

        updateFunc <- sprintf("update%sInput", type)
        funcParams <- list(session, x)

        if (type == "Checkbox") {
          value <- as.logical(value)
        }

        if (type == "CheckboxGroup" ||
            type == "RadioButtons" ||
            type == "Select") {
          funcParams[['selected']] <- strsplit(value, ",")[[1]]
        } else if (type == "DateRange") {
          dates <- strsplit(value, ",")[[1]]
          funcParams[['start']] <- dates[1]
          funcParams[['end']] <- dates[2]
        } else {
          funcParams[['value']] <- value
        }

        if (type == "RadioButtons") {
          updateFunc <- sprintf("update%s", type)
        }

        do.call(updateFunc, funcParams)
      }
    )
  })

  invisible(NULL)
}
