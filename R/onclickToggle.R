#' @export
onclickToggle <- function(tag, id) {
  if (!inherits(tag, "shiny.tag")) {
    errMsg("'tag' is not a valid Shiny tag")
  }

  # if this is <a>, add the action as href, otherwise as an onclick handler
  if (tag$name == "a") {
    tag <- shiny::tagAppendAttributes(
      tag,
      href = sprintf("javascript:shinyjs.toggle('%s');", id))
  } else {
    tag <- shiny::tagAppendAttributes(
      tag,
      onclick = sprintf("javascript:shinyjs.toggle('%s');", id))
  }
  tag
}
