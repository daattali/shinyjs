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

  # send a call to JavaScript to figure out what elements to reset and what
  # values to reset them to
  shinyInputId <- paste0("shinyjs-resettable-", id)
  session$sendCustomMessage("reset", list(id = id,
                                          shinyInputId = shinyInputId))

  # listen for a response from javascript
  shiny::observeEvent(session$input[[shinyInputId]], {
    messages <- session$input[[shinyInputId]]

    # go through each input element that javascript told us about and call
    # the corresponding shiny::updateFooInput() with the correct arguments
    lapply(
      names(messages),
      function(x) {
        type <- messages[[x]][['type']]
        value <- messages[[x]][['value']]

        updateFunc <- sprintf("update%sInput", type)
        funcParams <- list(session, x)

        # checkbox values need to be manually converted to TRUE/FALSE
        if (type == "Checkbox") {
          value <- as.logical(value)
        }

        # most input update functions use 'value' argument, some use 'selected',
        # DateRange uses 'start' and 'end'
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

        # radio buttons don't follow the regular shiny input naming conventions
        if (type == "RadioButtons") {
          updateFunc <- sprintf("update%s", type)
        }

        # update the input to its original values
        do.call(updateFunc, funcParams)
      }
    )
  })

  invisible(NULL)
}
