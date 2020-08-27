library(shiny)

source("helpers.R")

share <- list(
  title = "shinyjs package",
  url = "https://daattali.com/shiny/shinyjs-demo/",
  image = "https://daattali.com/shiny/img/shinyjs.png",
  description = "Easily improve the user experience of your Shiny apps in seconds",
  twitter_user = "daattali"
)

fluidPage(
  shinydisconnect::disconnectMessage2(),
  title = paste0("shinyjs package ", as.character(packageVersion("shinyjs"))),
  tags$head(
    includeCSS(file.path('www', 'style.css')),
    # Favicon
    tags$link(rel = "shortcut icon", type="image/x-icon", href="https://daattali.com/shiny/img/favicon.ico"),
    # Facebook OpenGraph tags
    tags$meta(property = "og:title", content = share$title),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:url", content = share$url),
    tags$meta(property = "og:image", content = share$image),
    tags$meta(property = "og:description", content = share$description),

    # Twitter summary cards
    tags$meta(name = "twitter:card", content = "summary"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
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
     h1("Choose a shinyjs function", class = "section-title"),
     div(id = "expr-container",
         selectInput("expr", label = NULL,
                 choices = examplesNamed, selected = 1,
                 multiple = FALSE, selectize = TRUE, width = "100%"
         )
     ),
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
    tags$em("This demo only allows you to select from one of the given R expressions",
      "and does not allow you to run any arbitrary expression. To have more freedom",
      "in playing with shinyjs, install", strong("shinyjs"),
      "and run the sandbox demo using", code("shinyjs::runExample('sandbox')"))
  ))
  )
)
