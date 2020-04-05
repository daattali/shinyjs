#' Refresh the page
#' 
#' @examples 
#' if (interactive()) {
#'   library(shiny)
#'   ui <- fluidPage(
#'     useShinyjs(),
#'     textInput("text", "Text", "text"),
#'     actionButton("refresh", "Refresh")
#'   )
#'
#'   server <- function(input, output, session) {
#'     observeEvent(input$refresh, {
#'       refresh()
#'     })
#'   }
#'
#'  shinyApp(ui, server)
#' }
#' 
#' @export
refresh <- function() {
  fxn <- "refresh"
  params <- list()
  jsFuncHelper(fxn, params)
}

 