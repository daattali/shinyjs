#' Add inline CSS
#'
#' Add inline CSS to a Shiny app. This is simply a convenience function that
#' gets called from a Shiny app's UI to make it less tedious to add inline CSS.
#' If there are many CSS rules, it is recommended to use an external stylesheet.
#' \cr\cr
#' CSS is a simple way to describe how elements on a web page should be
#' displayed (position, colour, size, etc.).  You can learn the basics
#' at \href{https://www.w3schools.com/css/}{W3Schools}.
#'
#' @param rules The CSS rules to add. Can either be a string with valid
#' CSS code, or a named list of the form
#' \code{list(selector = declarations)}, where \code{selector} is a valid
#' CSS selector and \code{declarations} is a string or vector of declarations.
#' See examples for clarification.
#' @param minify If `TRUE`, the CSS rules will be condensed as much as possible
#' to save on bandwidth. If `FALSE`, whitespace is added to make the CSS more
#' human-readable, which is easier for debugging.
#'
#' @return Inline CSS code that is automatically inserted to the app's
#'
#' \code{<head>} tag.
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   # Method 1 - passing a string of valid CSS
#'   shinyApp(
#'     ui = fluidPage(
#'       inlineCSS("#big { font-size:30px; }
#'                  .red { color: red; border: 1px solid black;}"),
#'       p(id = "big", "This will be big"),
#'       p(class = "red", "This will be red and bordered")
#'     ),
#'     server = function(input, output) {}
#'   )
#'
#'   # Method 2 - passing a list of CSS selectors/declarations
#'   # where each declaration is a full declaration block
#'   shinyApp(
#'     ui = fluidPage(
#'       inlineCSS(list(
#'         "#big" = "font-size:30px",
#'         ".red" = "color: red; border: 1px solid black;"
#'       )),
#'       p(id = "big", "This will be big"),
#'       p(class = "red", "This will be red and bordered")
#'     ),
#'     server = function(input, output) {}
#'   )
#'
#'   # Method 3 - passing a list of CSS selectors/declarations
#'   # where each declaration is a vector of declarations
#'   shinyApp(
#'     ui = fluidPage(
#'       inlineCSS(list(
#'         "#big" = "font-size:30px",
#'         ".red" = c("color: red", "border: 1px solid black")
#'       )),
#'       p(id = "big", "This will be big"),
#'       p(class = "red", "This will be red and bordered")
#'     ),
#'     server = function(input, output) {}
#'   )
#'
#'   # Use `minify = FALSE` to result in more human-readable CSS
#'   shinyApp(
#'     ui = fluidPage(
#'       inlineCSS(list(
#'         "#big" = "font-size:30px",
#'         ".red" = c("color: red", "border: 1px solid black")
#'       ), minify = FALSE),
#'       p(id = "big", "This will be big"),
#'       p(class = "red", "This will be red and bordered")
#'     ),
#'     server = function(input, output) {}
#'   )
#' }
#' @export
inlineCSS <- function (rules, minify = TRUE)
{
  if (minify) {
    space <- ""
    indent <- ""
    cr <- ""
    collapse <- ";"
  } else {
    space <- " "
    indent <- "  "
    cr <- "\n"
    collapse <- paste0(";", cr)
  }
  if (is.list(rules)) {
    rules <-
      paste0(
        lapply(
          names(rules),
          function(x) {
            paste0(
              cr,
              x, space, "{", cr,
              paste0(indent, rules[[x]], collapse = collapse),
              cr,
              "}"
            )
          }
        ),
        cr,
        collapse = ""
      )
  }
  insertHead(shiny::tags$style(shiny::HTML(rules)))
}
