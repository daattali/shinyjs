---
layout: page
title: Advanced
subtitle: Including shinyjs in different types of apps
---

- [Basic use of shinyjs](#usage-basic)
- [Using shinyjs in Shiny Dashboards](#usage-dashboard)
- [Using shinyjs with navbarPage layout](#usage-navbarpage)
- [Using shinyjs in R Markdown documents](#usage-rmd)
    - [Rmd documents with Tabbed Sections](#usage-tabbed)
    - [Rmd documents using `shiny_prerendered` engine](#usage-prerendered)
- [Using shinyjs when the user interface is built using an HTML file](#usage-html)

<h1 id="usage-basic" class="linked-section">Basic use of shinyjs</h1>

A typical Shiny app has a UI portion and a server portion. Before using most shinyjs functions, you need to call `useShinyjs()` in the app's UI. It's best to include it near the top as a convention.

Here is a minimal Shiny app that uses `shinyjs`:

```
library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),  # Include shinyjs

  actionButton("button", "Click me"),
  textInput("text", "Text")
)

server <- function(input, output) {
  observeEvent(input$button, {
    toggle("text")  # toggle is a shinyjs function
  })
}

shinyApp(ui, server)
```

This is how most Shiny apps should initialize `shinyjs` - by calling `useShinyjs()` near the top of the UI.

However, if you use shinyjs in any of the following cases:

- In Shiny dashboards (built using the `shinydashboard` package)
- In Shiny apps that use a `navbarPage` layout
- In Rmd documents
- In Shiny apps that manually build the user interface with an HTML file or template (instead of using Shiny's UI functions)

Then the following sections will show you how you to include shinyjs.

<h1 id="usage-dashboard" class="linked-section">Using shinyjs in Shiny Dashboards</h1>

`shinydashboard` is an R package that lets you create nice dashboards with Shiny. Since it has a different structure than typical Shiny apps, it can be unclear where to include the call to `useShinyjs()` in these apps. It is recommended to place the call to `useShinyjs()` in the beginning of `dashboardBody()`. For example, here is a minimal Shiny dashboard that uses `shinyjs`:

```
library(shiny)
library(shinydashboard)
library(shinyjs)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    useShinyjs(),
    actionButton("button", "Click me"),
    div(id = "hello", "Hello!")
  )
)

server <- function(input, output) {
  observeEvent(input$button, {
    toggle("hello")
  })
}

shinyApp(ui, server)
```

<h1 id="usage-navbarpage" class="linked-section">Using shinyjs with navbarPage layout</h1>

When creating a Shiny app that uses a `navbarPage` layout, the call to `useShinyjs()` can be placed inside any of the tabs (since the only real requirement is that it will be present *somewhere* in the UI). While having `useShinyjs()` inside the contents of any tab will work, there is another method that is preferred. You can wrap the `navbarPage` in a `tagList`, and call `useShinyjs()` within the `tagList`. This way, `shinyjs` gets set up in a way that is independent of each of the tabs. For example, here is a minimal Shiny app that uses `shinyjs` inside a `navbarPage` layout:

```
library(shiny)
library(shinyjs)

ui <- tagList(
  useShinyjs(),
  navbarPage(
    "shinyjs with navbarPage",
    tabPanel("tab1",
             actionButton("button", "Click me"),
             div(id = "hello", "Hello!")),
    tabPanel("tab2")
  )
)

server <- function(input, output, session) {
  observeEvent(input$button, {
    toggle("hello")
  })
}

shinyApp(ui, server)
```

<h1 id="usage-rmd" class="linked-section">Using shinyjs in R Markdown documents</h1>

It is possible to embed Shiny components in an R Markdown document, resulting in interactive R Markdown documents. More information on how to use these documents is available [on the R Markdown website](https://rmarkdown.rstudio.com/authoring_shiny.html). Even though interactive documents don't explicitly specify a UI and a server, using `shinyjs` is still easy: simply call `useShinyjs(rmd = TRUE)` (note the `rmd = TRUE` argument). For example, the following code can be used inside an R Markdown code chunk (assuming the Rmd document is set up with `runtime: shiny` as the link above describes):

```
library(shinyjs)

useShinyjs(rmd = TRUE)
actionButton("button", "Click me")
div(id = "hello", "Hello!")

observeEvent(input$button, {
 toggle("hello")
})
```

<h2 id="usage-tabbed" class="linked-section">Rmd documents with Tabbed Sections</h2>

If the Rmd file makes use of [Tabbed Sections](https://rmarkdown.rstudio.com/html_document_format.html#tabbed_sections) (using `{.tabset}`), then you should include the call to `useShinyjs(rmd = TRUE)` before the tabset definition, near the beginning of the file.

<h2 id="usage-prerendered" class="linked-section">Rmd documents using `shiny_prerendered` engine</h2>

If you're using the [`shiny_prerendered` Rmd format](https://rmarkdown.rstudio.com/authoring_shiny_prerendered.html), you need to include the following code in the beginning of your Rmd file, just after the YAML header:

````
```{r, echo=FALSE}
shiny::addResourcePath("shinyjs", system.file("srcjs", package = "shinyjs"))
```
```{r, context="server"}
shinyjs::useShinyjs(html = TRUE)
```
<script src="shinyjs/inject.js"></script>
````

<h1 id="usage-html" class="linked-section">Using shinyjs when the user interface is built using an HTML file/template</h1>

While most Shiny apps use Shiny's functions to build a user interface to the app, it is possible to build the UI with an HTML template, [as RStudio shows in this article](https://shiny.rstudio.com/articles/templates.html). In this case, you simply need to add `{{ useShinyjs() }}` somewhere in the template, preferably inside the `<head>...</head>` tags.

A similar way to create your app's UI with HTML is to write it entirely in HTML (without templates), [as RStudio shows in this article](https://shiny.rstudio.com/articles/html-ui.html). Building Shiny apps like this is much more complicated and should only be used if you're very comfortable with HTML. Using `shinyjs` in these apps is possible but it works a little differently since there is no `ui.R` to call `useShinyjs()` from.  There are three simple steps to take in order to use `shinyjs` in these apps:

- create a `global.R` file in the same directory as your `server.R`, and add the following line to the file:

        shiny::addResourcePath("shinyjs", system.file("srcjs", package = "shinyjs"))
        
- in the `index.html` file you need to load a special JavaScript file named `shinyjs/inject.js`. You do this by adding the following line to the HTML's `<head>` tag:

        `<script src="shinyjs/inject.js"></script>`
        
- in your server function (the `shinyServer` function) you need to call `useShinyjs(html = TRUE)`

After adding these three lines to your code, you can use all `shinyjs` functions as usual.
