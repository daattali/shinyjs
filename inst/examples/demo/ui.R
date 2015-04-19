library(shiny)

source("helpers.R")

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
     h1("Choose an R expression", class = "section-title"),
     div(id = "expr-container",
         selectInput("expr", label = NULL,
                   choices = examplesNamed, selected = 1,
                   multiple = FALSE, selectize = TRUE, width = "100%"
     )),
     actionButton("submitExpr", "Run", class = "btn-success"),
     shiny::hr(),
     uiOutput("helpText"),
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
      "by simply adding", code("shinyjs::useShinyjs()"), "to the app's", code("ui"), "."),
    p("After adding this call to your Shiny app, you can",
      "use the functions provided by", strong("shinyjs"), "as regular intuitive R code.",
      "These functions use JavaScript behind the scenes to let you manipulate the",
      "content (HTML) on the page."),
    p(a("shinyjs is available on GitHub", href = "https://github.com/daattali/shinyjs",
        target = "_blank")),
    shiny::hr(),
    p("Note: This demo only allows you to select from one of the given R expressions",
      "and does not allow you to run any arbitrary expression. To have more freedom",
      "in playing with shinyjs or see what else it can do, install",
      strong("shinyjs"), "and run the sandbox demo using",
      code("shinyjs::runExample('sandbox')"))
  ))
  )
))
