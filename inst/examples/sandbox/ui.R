library(shiny)

examples <- c(
  'toggle("test")',
  'toggle("test", TRUE, "fade", 2)',
  'toggle(id = "test", anim = TRUE, time = 2, animType = "slide")',
  'hide("test")',
  'show("test")',
  'alert(R.Version())',
  'disable("btn")',
  'enable("btn")',
  'innerHTML("btn", "What a nice button")',
  'innerHTML("test", paste("The time is", date()))',
  'addClass("test", "green")',
  'removeClass("test", "green")',
  'toggleClass("test", "green")'
)

shinyUI(fluidPage(
  title = "Experimenting with shinyjs",
  tags$head(includeCSS(file.path('www', 'style.css'))),

  shinyjs::useShinyjs(),

  fluidRow(
  column(9,
    h1(id = "page-title", class = "section-title",
       "Experimenting with", tags$i("shinyjs"))
  ),
  column(3,
    div(id = "author-name",
          div(a("Dean Attali", href = "http://deanattali.com", target = "_blank")),
          div("Jan - Apr 2015"))
  )),

  fluidRow(
  column(6, wellPanel(
     h1("Write an R expression", class = "section-title"),
     textInput("expr", label = NULL, value = examples[1]),
     actionButton("submitExpr", "Run", class = "btn-success"),
     shinyjs::hidden(
       div(id = "error", br(),
           div("Oops, that resulted in an error! Try again."),
           div("Error: ", br(), span(id = "errorMsg"))
       )
     ),
     shiny::hr(),

     h1("Sandbox area", class = "section-title"),
     p(id = "test", "I'm an HTML element with id \"test\""),
     tags$button(
       id = "btn", class = "btn",
       "I'm a button with id \"btn\"")
   )
  ),

  column(6, wellPanel(
    h3("What is shinyjs?", class = "section-title"),
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
      "use the functions provided by", strong("shinyjs"), "as regular intuitive R code."),
    p("These functions use JavaScript behind the scenes to let you manipulate the",
      "content (HTML) on the page. Usually, you'll want to call these functions from",
      "the app's", code("server"), "after some user action."),
    shiny::hr(),
    h3("Examples to try", class = "section-title"),
    p("Copy these examples into the box on the left, then click \"Run\"."),

    tags$ul(id = "examples-list",
      lapply(examples, function(ex) tags$li(code(ex)))
    ),

    p("The functions ending in", code("*Class"), "require basic understading of",
      a("CSS.", href = "http://www.w3schools.com/css/", target = "_blank"),
      "The following CSS rule was added to the app in order for their examples to work:",
      code(".green { color: green }"))
  ))
  )
))
