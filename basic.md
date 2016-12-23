---
layout: page
title: Quick Start
---

# Installation

You can install the official version from CRAN:

```
install.packages("shinyjs")
```

Or you can be more adventurous and install the latest development version from GitHub:

```
install.packages("devtools")
devtools::install_github("daattali/shinyjs")
```

<br/>

# Quick Start

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
- In interactive Rmd documents
- In Shiny apps that manually build the user interface with an HTML file or template (instead of using Shiny's UI functions)

Then you should read the [Advanced help page]({{ site.baseurl }}/advanced).

If your Shiny app doesn't fall into any of these categories, then the above code sample should be enough to get your started with including shinyjs in your app.