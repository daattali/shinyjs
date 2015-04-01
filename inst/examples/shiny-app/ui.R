library(shiny)

source("helpers.R")

examples <- c(
  'toggle("test")',
  'hide("test")',
  'show("test")',
  'toggle("test", TRUE)',
  'toggle("test", TRUE, "fade", 2)',
  'toggle(id = "test", anim = TRUE, time = 2, animType = "slide")',
  'disable("btn")',
  'enable("btn")',
  'addClass("test", "green")',
  'removeClass("test", "green")',
  'toggleClass("test", "green")',
  'innerHTML("test", "change the text")',
  'innerHTML("btn", "I am a button!")',
  'innerHTML("test", paste0("Is 5 > 7? ", 5 > 7))'
)

shinyUI(fluidPage(
  tags$head(includeCSS(file.path('www', 'style.css'))),

  titlePanel("Experimenting with shinyjs"), br(),

  shinyjs::useShinyjs(),

  fluidRow(
  column(6,
    wellPanel(
      textInput("expr", "Write an R expression to experiment manipulating HTML with shinyjs:",
                examples[1]),
      actionButton("submitExpr", "Run", class = "btn-success"),
      br(),
      shinyjs::hidden(
        div(id = "error", br(),
          div("Oops, that resulted in an error! Try again."),
          div("Error: ", span(id = "errorMsg"))
        )
      ),
      br(),
      p("The results will be reflected in the sandbox area below.", br(),
        "To get you started, try some of the examples to the right.")
    ),

    h3("Sandbox area"),
    p(id = "test", "This text is an HTML element with id \"test\""),
    tags$button(
      id = "btn", class = "btn",
      "This is a button with id \"btn\"")
  ),

  column(6,
    h3("What is shinyjs?"),
    p(
      strong(a("shinyjs", href = "https://github.com/daattali/shinyjs",
               target = "_blank")),
      span("lets you perform common JavaScript operations in Shiny applications"),
      span("without having to know any JavaScript.")),
    p("Setup is minimal: this app has been set up to use", strong("shinyjs"),
      "with two simple function calls: "),
    tags$ul(
      tags$li(
        code("shinyjs::useShinyjs()"), "was added to the app's", code("ui")),
      tags$li(
        code("shinyjs::setSession(session)"), "was added to the app's", code("server"))
    ),
    p("After adding these two expressions to your Shiny app, you can",
      "use the functions provided by", strong("shinyjs"), "as regular intuitive R code.",
      "Usually these functions will be called from the app's",
      code("server"), "after some user action."),
    h3("Examples to try"),
    #p("Click on an example to quickly copy it into the box on the left, then click 'Run'."),
    p("Copy these examples into the box on the left, then click 'Run'."),
    tags$ul(id = "examples-list2",
      lapply(examples, function(ex) tags$li(code(ex)))
    ),
    p("The functions ending in", code("Class"), "require basic understading of",
      a("CSS.", href = "http://www.w3schools.com/css/", target = "_blank"),
      "The following CSS rule was added to the app in order for their examples to work:",
      code(".green { color: green }"))
  )),
  br(),
  fluidRow(
    em(
      span("Created by"),
      strong(a("Dean Attali", href = "http://deanattali.com", target = "_blank")),
      span(", January 2015"), br(), br()
    )
  )
))
