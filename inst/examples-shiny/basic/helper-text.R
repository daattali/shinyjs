getHelperText <- function() {
  div(
    h3("shinyjs usage in this app"),
    tags$ul(
      tags$li(
        "Selecting 'Bigger text' uses", code("shinyjs::addClass()"),
        "to add a CSS class to the webpage that enlarges the font"),
      tags$li(
        "Typing text inside the 'Name' field uses", code("shinyjs::toggleState()"),
        "to enable the submit button, and similary to disable the button",
        "when there is no input"),
      tags$li(
        "Clicking 'Show/hide advanced info' uses", code("shinyjs::onclick()"),
        "and", code("shinyjs::toggle()"), "to toggle between showing and",
        "hiding the advanced info section when the link is clicked"),
      tags$li(
        "Clicking 'Update' uses", code("shinyjs::onclick()"), "and",
        code("shinyjs::html()"), "to update the HTML in the timestamp when",
        "the link is clicked"),
      tags$li(
        "Clicking 'Submit' uses", code("shinyjs::alert()"), "to show a",
        "message to the user")
    ),
    p("These are just a subset of the functions available in shinyjs."),
    p("This app is available at",
      a("https://daattali.com/shiny/shinyjs-basic/",
        href = "https://daattali.com/shiny/shinyjs-basic/"),
      "and the source code is",
      a("on GitHub",
        href = "https://github.com/daattali/shinyjs/blob/master/inst/examples/basic/app.R")
    ),
    a("Visit the shinyjs website to learn more",
      href = "https://deanattali.com/shinyjs/")
  )
}
