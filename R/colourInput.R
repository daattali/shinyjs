formatHEX <- function(x) {
  if (is.null(x)) return()
  
  # ensure x is a valid HEX colour or a valid named colour
  if (x %in% colors()) {
    x <- do.call(rgb, as.list(col2rgb(x) / 255))
  }
  if (!grepl("^#?([[:xdigit:]]{3}|[[:xdigit:]]{6})$", x)) {
    stop(sprintf("%s is not a valid colour", x), call. = FALSE)
  }
  
  # ensure x begins with a pound sign
  if (substr(x, 1, 1) != "#") {
    x <- paste0("#", x)
  }
  
  # expand x to a 6-character HEX colour if it's in shortform
  # wow this is ugly, think of a nicer solution when it's not 4am
  if (nchar(x) == 4) {
    x <- paste0("#", substr(x, 2, 2), substr(x, 2, 2),
                substr(x, 3, 3), substr(x, 3, 3),
                substr(x, 4, 4), substr(x, 4, 4))
  }
  
  toupper(x)
}

`%AND%` <- function(x, y) {
  if (!is.null(x) && !is.na(x)) 
    if (!is.null(y) && !is.na(y)) 
      return(y)
  return(NULL)
}

updateColourInput <- function(session, inputId, label = NULL, value = NULL,
                              showColour = NULL) {
  message <- shiny:::dropNulls(list(label = label, value = formatHEX(value),
                                    showColour = showColour))
  session$sendInputMessage(inputId, message)
}

colourInput <- function(inputId, label, value = "#FFFFFF",
                        showColour = c("both", "text", "background")) {
  value <- formatHEX(value)
  showColour <- match.arg(showColour)
  tagList(
    singleton(tags$head(tags$script(src="jqColorPicker.min.js"),
                        # tags$script(src = "test.js"),
                        tags$script(src = "js.js"),
                        tags$style(HTML(".nobg { background-color: transparent !important; color: #222 !important; }
                                        .notext { color: transparent !important; }")))),
    div(class = "form-group shiny-input-container",
        `data-shiny-input-type` = "colour",
        label %AND% tags$label(label, `for` = inputId),
        tags$input(
          id = inputId, type = "text",
          class = "form-control shiny-colour-input",
          `data-init-col` = value,
          `data-show-colour` = showColour
        )
    )
                        )
}