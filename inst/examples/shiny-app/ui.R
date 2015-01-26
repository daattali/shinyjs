library(shiny)

source("helpers.R")

shinyUI(fluidPage(
  titlePanel("Experimenting with shinyjs package"),

  shinyjs::useShinyjs(),

  shiny::tags$style(".green { color: green; }"),

  column(6,

  p(
    strong(a("shinyjs", href = "https://github.com/daattali/shinyjs",
             target = "_blank")),
    span("lets you perform common JavaScript operations in Shiny applications"),
    span("without having to know any JavaScript.")),
  p("This app has been set up to use", strong("shinyjs"),
    "with two simple function calls: "),
  tags$ul(
    tags$li(
      code("shinyjs::useShinyjs()"), "was added to", code("ui.R")),
    tags$li(
      code("shinyjs::setShinyjsSession(session)"), "was added to", code("server.R"))
  ),
  p("After adding these two expressions to your Shiny app, you can now",
    "use the functions provided by", strong("shinyjs"), "with regular intuitive R code."),
  wellPanel(
    textInput("expr", "Write an R expression to experiment manipulating HTML with shinyjs:",
              "toggle(\"test\"); toggleClass(\"btn\", \"green\")"),
    actionButton("submitExpr", "Go!"),
    div(id = "error", class = "shinyjs-hide", style = "color: #FF0000;", br(),
        div("Oops, that resulted in an error! Try again."),
        div("Error: ", span(id = "errorMsg"))
    ),
    br(), br(),wellPanel(
    p(id = "test", "This is an HTML element with id \"test\""),
    tags$button(
      id = "btn",
      "Try enabling/disabling this button. My id is \"btn\"")
  ))
  ),

  column(6, div(
    getExplainText(),
    div(
      h4("Supported functions"),
      p(
        "Here is a list of supported functions, along with their arguments.",
        "Note that the arguments can either be passed in order without names,",
        "or can be named and in any order."
      ),
      tags$ul(
        tags$li(
          strong("show(), hide(), toggle()"), ": these functions control the visibility",
          "of an element.", strong("toggle()"), "will alternate between visible",
          "and hidden. Arguments:",
          tags$ul(
            tags$li(strong("id"), ": the id of the HTML element"),
            tags$li(strong("anim"), ": if TRUE, then animate the effect"),
            tags$li(strong("animType"), ": animation type, one of \"slide\" or \"fade\""),
            tags$li(strong("time"), ": the number of seconds for the animation to run")
          )
        ),
        tags$li(
          strong("addClass(), removeClass(), toggleClass()"), ": these functions",
          "can be used to add or remove CSS classes from an HTML element. Arguments:",
          tags$ul(
            tags$li(strong("id"), ": the id of the HTML element"),
            tags$li(strong("class"), ": the name of the CSS class to apply/remove")
          )
        ),
        tags$li(
          strong("enable(), disable()"), ": these functions can be used to enable",
          "or disable a button from being clicked. Arguments:",
          tags$ul(
            tags$li(strong("id"), ": the id of the HTML button")
          )
        ),
        tags$li(
          strong("innerHTML()"), ": this function is used to set the HTML code inside",
          "another element. The HTML can be a simple text or actual HTML with",
          "tags and expressions. Arguments:",
          tags$ul(
            tags$li(strong("id"), ": the id of the HTML element"),
            tags$li(strong("expr"), ": the expression to set the HTML to")
          )
        )
      ),
      h4("Examples to try"),
      tags$ul(
        tags$li(code(
          "innerHTML('btn', paste0('Is 5 > 7? ', 5 > 7))"
        ))
      )
    )
  )),

  em(
    span("Created by"),
    a("Dean Attali", href = "https://github.com/daattali", target = "_blank"),
    span(", January 2015"), br(), br()
  )
))
