library(shiny)

source("helpers.R")

shinyUI(fluidPage(
  title = paste0("shinyjs package ", as.character(packageVersion("shinyjs"))),
  tags$head(
    includeCSS(file.path('www', 'style.css')),
    # Favicon
    tags$link(rel = "shortcut icon", type="image/x-icon", href="https://daattali.com/shiny/img/favicon.ico")
  ),
  tags$a(
    href="https://github.com/daattali/shinyjs",
    tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
             src="github-green-right.png",
             alt="Fork me on GitHub")
  ),

  shinyjs::useShinyjs(),

  div(id = "header",
      div(id = "title",
          "shinyjs package"
      ),
      div(id = "subtitle",
          "Easily improve the user experience of your Shiny apps in seconds"),
      div(id = "subsubtitle",
          "Created by",
          tags$a(href = "https://deanattali.com/", "Dean Attali"),
          HTML("&bull;"),
          "Available",
          tags$a(href = "https://github.com/daattali/shinyjs", "on GitHub"),
          HTML("&bull;"),
          tags$a(href = "https://daattali.com/shiny/", "More apps"), "by Dean"
      )
  ),

  fluidRow(
  column(6, wellPanel(
     h1("Write an R expression", class = "section-title"),
     shinyjs::runcodeUI(code = as.character(examples[1])),
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
      strong(a("shinyjs", href = "https://deanattali.com/shinyjs/",
               target = "_blank")),
      span("lets you improve the user experience in your Shiny apps using very simple functions.")),
    p("You can",
      "use the functions provided by", strong("shinyjs"), "as regular intuitive R code.",
      "These functions use JavaScript behind the scenes to let you manipulate the",
      "content (HTML) on the page, but you do not need to know any JavaScript to use shinyjs.",
      "If you do know JavaScript, you can also use", strong("shinyjs"), "to call",
      "you own JavaScript functions as if they were R code."),
    shiny::hr(),
    h3("Examples to try", class = "section-title"),
    p("Click on any of the examples below to quickly copy them into the box on the left,",
      "then click \"Run\"."),

    tags$ul(id = "examples-list",
      lapply(names(examples), function(ex) {
        ex <- examples[ex]
        tags$li(a(id = sprintf("example-%s", names(ex)),
                  (as.character(ex))))
      })
    ),

    p("The functions ending in", code("*Class"), "require basic understading of",
      a("CSS.", href = "https://www.w3schools.com/css/", target = "_blank"),
      "The following CSS rule was added to the app in order for their examples to work:",
      code(".green { color: green }"))
  ))
  )
))
