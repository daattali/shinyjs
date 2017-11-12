#' Click on a Shiny button
#'
#' The \code{click()} function can be used to programatically simulate a click
#' on a Shiny \code{actionButton()}.
#'
#' @param id The id of the button
#' @seealso \code{\link[shinyjs]{useShinyjs}},
#' \code{\link[shinyjs]{runExample}}
#' @note \code{shinyjs} must be initialized with a call to \code{useShinyjs()}
#' in the app's ui.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyjs(),  # Set up shinyjs
#'       "Count:", textOutput("number", inline = TRUE), br(),
#'       actionButton("btn", "Click me"), br(),
#'       "The button will be pressed automatically every 3 seconds"
#'     ),
#'     server = function(input, output) {
#'       output$number <- renderText({
#'         input$btn
#'       })
#'       observe({
#'         click("btn")
#'         invalidateLater(3000)
#'       })
#'     }
#'   )
#' }
#' @export
click <- function(id) {
  fxn <- "click"
  params <- list(id = id)
  jsFuncHelper(fxn, params)
}
