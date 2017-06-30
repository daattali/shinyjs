shinyjs - Perform common JavaScript operations in Shiny apps using plain R code
===============================================================================

[![Build
Status](https://travis-ci.org/daattali/shinyjs.svg?branch=master)](https://travis-ci.org/daattali/shinyjs)
[![CRAN
version](http://www.r-pkg.org/badges/version/shinyjs)](https://cran.r-project.org/package=shinyjs)

`shinyjs` lets you perform common useful JavaScript operations in Shiny
applications without having to know any JavaScript. Examples include:
hiding an element, disabling an input, resetting an input back to its
original value, delaying code execution by a few seconds, and many more
useful functions. `shinyjs` can also be used to easily run your own
custom JavaScript functions from R.

Table of contents
=================

-   [Live demos](#demos)
-   [Installation](#install)
-   [Overview of main functions](#overview-main)
-   [How to use](#usage)
    -   [Using shinyjs in interactive R Markdown
        documents](#usage-interactive)
    -   [Using shinyjs in Shiny Dashboards](#usage-dashboard)
    -   [Using shinyjs with navbarPage layout](#usage-navbarpage)
    -   [Using shinyjs when the user interface is built using an HTML
        file](#usage-html)  
-   [Basic use case - complete working example](#usecase)
-   [Calling your own JavaScript functions from R](#extendshinyjs)
    -   [Simple example](#extendshinyjs-simple)
    -   [Running JavaScript code on page load](#extendshinyjs-onload)
    -   [Passing arguments from R to JavaScript](#extendshinyjs-args)
    -   [Note about V8 prerequisite](#extendshinyjs-v8)
-   [FAQ and extra tricks](#faq-tricks)

<h2 id="demos">
Live demos
</h2>

You can [check out a demo
Shiny app](http://daattali.com/shiny/shinyjs-demo/) that lets you play around
with some of the functionality that `shinyjs` makes available.

`shinyjs` also includes a `colourInput` which is an input control that
allows users to select colours. [Interactive
demo](http://daattali.com/shiny/colourInput/).

[Presentation slides for
`shinyjs` talk](http://bit.ly/shinyjs-slides)
from the 2016 Shiny Developer Conference.

<h2 id="install">
Installation
</h2>
`shinyjs` is available through both CRAN and GitHub:

To install the stable CRAN version:

    install.packages("shinyjs")

To install the latest developmental version from GitHub:

    install.packages("devtools")
    devtools::install_github("daattali/shinyjs")

<h2 id="overview-main">
Overview of main functions
</h2>
In order to use any `shinyjs` function in a Shiny app, you must first
call `useShinyjs()` anywhere in the Shiny app's UI. The following is a
list of the common functions:

-   `show`/`hide`/`toggle` - display or hide an element. There are
    arguments that control the animation as well, though animation is
    off by default.

-   `hidden` - initialize a Shiny tag as invisible (can be shown later
    with a call to `show`).

-   `reset` - reset a Shiny input widget back to its original value.

-   `enable`/`disable`/`toggleState` - enable or disable an input
    element, such as a button or a text input.

-   `delay` - execute R code (including any `shinyjs` functions) after a
    specified amount of time.

-   `disabled` - initialize a Shiny input as disabled.

-   `info` - show a message to the user (using JavaScript's `alert`
    under the hood).

-   `html` - change the text/HTML of an element (using JavaScript's
    `innerHTML` under the hood).

-   `onclick` - run R code when an element is clicked. Was originally
    developed with the sole purpose of running a `shinyjs` function when
    an element is clicked, though any R code can be used.

-   `onevent` - similar to `onclick`, but can be used with many other
    events instead of click.

-   `addClass`/`removeClass`/`toggleClass` - add or remove a CSS class
    from an element

-   `inlineCSS` - easily add inline CSS to a Shiny app.

-   `logjs` - print a message to the JavaScript console (mainly used for
    debugging purposes).

-   `runjs` - run arbitrary JavaScript code (not recommended to use this
    in a published Shiny app).

-   `extendShinyjs` - allows you to write your own JavaScript functions
    and use `shinyjs` to call them as if they were regular R code. More
    information is available in the section "Calling your own JavaScript
    functions from R".

-   `colourInput` and `updateColourInput` - input widget that allows
    users to select colours.

[Check out the demo Shiny app](http://daattali.com/shiny/shinyjs-demo/)
to see some of these in action, or install `shinyjs` and run
`shinyjs::runExample()` to see more demo apps.

<h2 id="usage">
How to use
</h2>
A typical Shiny app has a UI portion and a server portion. As mentioned
above, `useShinyjs()` must be called in the Shiny app's UI, and it's
best to include it near the top as a convention. For example, here is a
minimal Shiny app that uses `shinyjs`:

    library(shiny)
    library(shinyjs)

    ui <- fluidPage(
      useShinyjs(),
      actionButton("button", "Click me"),
      div(id = "hello", "Hello!")
    )

    server <- function(input, output) {
      observeEvent(input$button, {
        toggle("hello")
      })
    }

    shinyApp(ui, server)

This is how most Shiny apps should initialize `shinyjs`, but there are
four common scenarios that should be treated a little differently: using
`shinyjs` in interactive documents, in Shiny dashboards, in Shiny apps
that use a `navbarPage` layout, or in Shiny apps that manually build the
user interface with an HTML file instead of using Shiny's UI functions.
If your Shiny app doesn't fall into any of these categories (most Shiny
apps don't), then you can skip the next 4 sections that describe how to
tackle these cases, and scroll down to the [Basic use case](#usecase)
section.

<h3 id="usage-interactive">
Using shinyjs in interactive R Markdown documents
</h3>
It is possible to embed Shiny components in an R Markdown document,
resulting in interactive R Markdown documents. More information on how
to use these documents is available [on the R Markdown
website](http://rmarkdown.rstudio.com/authoring_shiny.html). Even though
interactive documents don't explicitly specify a UI and a server, using
`shinyjs` is still easy: simply call `useShinyjs(rmd = TRUE)` (note the
`rmd = TRUE` argument). For example, the following code can be used
inside an R Markdown code chunk (assuming the document is set up as a
Shiny document as the link above describes):

    library(shinyjs)

    useShinyjs(rmd = TRUE)
    actionButton("button", "Click me")
    div(id = "hello", "Hello!")

    observeEvent(input$button, {
     toggle("hello")
    })

<h3 id="usage-dashboard">
Using shinyjs in Shiny Dashboards
</h3>
`shinydashboard` is an R package that lets you create nice dashboards
with Shiny. Since it has a different structure than typical Shiny apps,
it can be unclear where to include the call to `useShinyjs()` in these
apps. It is recommended to place the call to `useShinyjs()` in the
beginning of `dashboardBody()`. For example, here is a minimal Shiny
dashboard that uses `shinyjs`:

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

<h3 id="usage-navbarpage">
Using shinyjs with navbarPage layout
</h3>
When creating a Shiny app that uses a `navbarPage` layout, the call to
`useShinyjs()` can be placed inside any of the tabs (since the only real
requirement is that it will be present *somewhere* in the UI). While
having `useShinyjs()` inside the contents of any tab will work, there is
another method that is preferred. You can wrap the `navbarPage` in a
`tagList`, and call `useShinyjs()` within the `tagList`. This way,
`shinyjs` gets set up in a way that is independent of each of the tabs.
For example, here is a minimal Shiny app that uses `shinyjs` inside a
`navbarPage` layout:

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

<h3 id="usage-html">
Using shinyjs when the user interface is built using an HTML file
</h3>
While most Shiny apps use Shiny's functions to build a user interface to
the app, it is possible to build the entire UI with custom HTML, [as
RStudio shows in this
article](http://shiny.rstudio.com/articles/html-ui.html). Building Shiny
apps like this is much more complicated and should only be used if
you're very comfortable with HTML. Using `shinyjs` in these apps is
possible but it works a little differently since there is no `ui.R` to
call `useShinyjs()` from. There are three simple steps to take in order
to use `shinyjs` in these apps:

-   create a `global.R` file in the same directory as your `server.R`,
    and add the following line to the file:

        shiny::addResourcePath("shinyjs", system.file("srcjs", package = "shinyjs"))

-   in the `index.html` file you need to load a special JavaScript file
    named `shinyjs/inject.js`. You do this by adding the following line
    to the HTML's `<head>` tag:

        `<script src="shinyjs/inject.js"></script>`

-   in your server function (the `shinyServer` function) you need to
    call `useShinyjs(html = TRUE)`

After adding these three lines to your code, you can use all `shinyjs`
functions as normal.

<h2 id="usecase">
Basic use case - complete working example
</h2>
*You can view the final Shiny app developed in this simple example
[here](http://daattali.com/shiny/shinyjs-basic/).*

Suppose we want to have a simple Shiny app that collects a user's basic
information (name, age, company) and submits it, along with the time of
submission. Here is a very simple implementation of such an app (nothing
actually happens when the user "submits").

    library(shiny)
    shinyApp(
      ui = fluidPage(
        div(id = "myapp",
          h2("shinyjs demo"),
          textInput("name", "Name", ""),
          numericInput("age", "Age", 30),
          textInput("company", "Company", ""),
          p("Timestamp: ", span(date())),
          actionButton("submit", "Submit")
        )
      ),
      
      server = function(input, output) {
      }
    )

*Note that I generally don't like running Shiny apps like this and
prefer to declare the UI and server separately, but this style is used
here for brevity.*

Here is what that app would look like

![Demo app](inst/img/demo-basic-v1.png)

### Add shinyjs features

Now suppose we want to add a few features to the app to make it a bit
more user-friendly. First we need to set up the app to use `shinyjs` by
making a call to `useShinyjs()` in the Shiny app's UI.

Here are 7 features we'll add to the app, each followed with the code to
implement it using `shinyjs`:

**1. The "Name" field is mandatory and thus the "Submit" button should
not be enabled if there is no name**

In the server portion, add the following code

    observe({
      if (is.null(input$name) || input$name == "") {
        shinyjs::disable("submit")
      } else {
        shinyjs::enable("submit")
      }
    })

Or instead you can use the `toggleState` function and pass it a
`condition`:

    observe({
      shinyjs::toggleState("submit", !is.null(input$name) && input$name != "")
    })

You can use the optional `condition` in some other functions as well,
which can be very useful to make your code shorter and more
understandable.

**2. The "Age" and "Company" fields are optional and we want to have the
ability to hide that section of the form**

First, we need to section off the "Age" and "Company" elements into
their own section, so we surround them with a `div`

    div(id = "advanced",
      numericInput("age", "Age", 30),
      textInput("company", "Company", "")
    )

We also need to add a link in the UI that will be used to hide/show the
section

    a(id = "toggleAdvanced", "Show/hide advanced info")

Lastly, we need to tell Shiny to show/hide the section when the link is
clicked by adding this code to the server

    shinyjs::onclick("toggleAdvanced",
                      shinyjs::toggle(id = "advanced", anim = TRUE))

**3. Similarly, since we don't really care about "Age" and "Company" too
much, we want to hide them initially when the form loads**

Simply surround the section we want to hide initially with
`shinyjs::hidden`

    shinyjs::hidden(
      div(id = "advanced",
        ...
    ))

**4. The user should be able to update the "Timestamp" in case he spends
way too long filling out the form (not very realistic here, and the
timestamp should ideally be determined when the button is clicked, but
it's good enough for illustration purposes)**

First, we need to add an "Update" link to click on, and we need to give
the element showing the time an `id` so that we can refer to it later
when we want to change its contents.

To do that, replace `p("Timestamp: ", span(date()))` with

    p("Timestamp: ", span(id = "time", date()), a(id = "update", "Update"))

Now we need to tell Shiny what to do when "Update" is clicked by adding
this to the server

    shinyjs::onclick("update", shinyjs::html("time", date()))

**5. Some users may find it hard to read the small text in the app, so
there should be an option to increase the font size**

First, we need to add checkbox to the UI

    checkboxInput("big", "Bigger text", FALSE)

In order to make the text bigger, we will use CSS. So let's add an
appropriate CSS rule by adding this code to the UI

    shinyjs::inlineCSS(list(.big = "font-size: 2em"))

Lastly, we want the text to be big or small depending on whether the
checkbox is checked by adding this code to the server

    observe({
      if (input$big) {
        shinyjs::addClass("myapp", "big")
      } else {
        shinyjs::removeClass("myapp", "big")
      }
    })

Or, again, we can use the `toggleClass` function with the `condition`
argument:

    observe({
      shinyjs::toggleClass("myapp", "big", input$big)
    })

**6. Give the user a "Thank you" message upon submission**

Simply add the following to the server

    observeEvent(input$submit, {
      shinyjs::info("Thank you!")
    })

**7. Allow the user to reset the form**

First let's add a button to the UI

    actionButton("reset", "Reset form")

And when the button is clicked, reset the form

    observeEvent(input$reset, {
      shinyjs::reset("myapp")
    })

### Final code

The final code looks like this

    library(shiny)
    shinyApp(
      ui = fluidPage(
        shinyjs::useShinyjs(),
        shinyjs::inlineCSS(list(.big = "font-size: 2em")),
        div(id = "myapp",
            h2("shinyjs demo"),
            checkboxInput("big", "Bigger text", FALSE),
            textInput("name", "Name", ""),
            a(id = "toggleAdvanced", "Show/hide advanced info", href = "#"),
            shinyjs::hidden(
              div(id = "advanced",
                numericInput("age", "Age", 30),
                textInput("company", "Company", "")
              )
            ),
            p("Timestamp: ",
              span(id = "time", date()),
              a(id = "update", "Update", href = "#")
            ),
            actionButton("submit", "Submit"),
            actionButton("reset", "Reset form")
        )
      ),
      
      server = function(input, output) {
        observe({
          shinyjs::toggleState("submit", !is.null(input$name) && input$name != "")
        })
        
        shinyjs::onclick("toggleAdvanced",
                         shinyjs::toggle(id = "advanced", anim = TRUE))    
        
        shinyjs::onclick("update", shinyjs::html("time", date()))
        
        observe({
          shinyjs::toggleClass("myapp", "big", input$big)
        })
        
        observeEvent(input$submit, {
          shinyjs::info("Thank you!")
        })
        
        observeEvent(input$reset, {
          shinyjs::reset("myapp")
        })    
      }
    )

You can view the final app
[here](http://daattali.com/shiny/shinyjs-basic/).

<h2 id="extendshinyjs">
Calling your own JavaScript functions from R
</h2>
You can also use `shinyjs` to add your own JavaScript functions that can
be called from R as if they were regular R functions using
`extendShinyjs`. Note that you have to install the `V8` package in order
to use this function.

<h3 id="extendshinyjs-simple">
Simple example
</h3>
Using `extendShinyjs` is very simple and makes defining and calling
JavaScript functions painless. Here is a very basic example of using
`extendShinyjs` to define a (fairly useless) function that changes the
colour of the page.

    library(shiny)
    library(shinyjs)

    jsCode <- "shinyjs.pageCol = function(params){$('body').css('background', params);}"

    shinyApp(
      ui = fluidPage(
        useShinyjs(),
        extendShinyjs(text = jsCode),
        selectInput("col", "Colour:",
                    c("white", "yellow", "red", "blue", "purple"))
      ),
      server = function(input, output) {
        observeEvent(input$col, {
          js$pageCol(input$col)
        })
      }
    )

Running the code above produces this shiny app:

![Extendshinyjs
demo](http://deanattali.com/img/blog/shinyjs-improvements/extendshinyjs-demo.gif)

See how easy that was? All I had to do was make the JavaScript function
`shinyjs.pageCol`, pass the JavaScript code as an argument to
`extendShinyjs`, and then I can call `js$pageCol()`. That's the basic
idea: any JavaScript function named `shinyjs.foo` will be available to
call as `js$foo()`. You can either pass the JS code as a string to the
`text` argument, or place the JS code in a separate JavaScript file and
use the `script` argument to specify where the code can be found. Using
a separate file is generally prefered over writing the code inline, but
in these examples I will always use the `text` argument to keep it
simple.

<h3 id="extendshinyjs-onload">
Running JavaScript code on page load
</h3>
If there is any JavaScript code that you want to run immediately when
the page loads rather than having to call it from the server, you can
place it inside a `shinyjs.init` function. The function `shinyjs.init`
will automatically be called when the Shiny app's HTML is initialized. A
common use for this is when registering event handlers or initializing
JavaScript objects, as these usually just need to run once when the page
loads.

For example, the following example uses `shinyjs.init` to register an
event handler so that every keypress will print its corresponding key
code:

    jscode <- "
    shinyjs.init = function() {
      $(document).keypress(function(e) { alert('Key pressed: ' + e.which); });
    }"

    shinyApp(
      ui = fluidPage(
        useShinyjs(),
        extendShinyjs(text = jscode),
        "Press any key"
      ),
      server = function(input, output) {}
    )

<h3 id="extendshinyjs-args">
Passing arguments from R to JavaScript
</h3>
Any `shinyjs` function that is called will pass a single array-like
parameter to its corresponding JavaScript function. If the function in R
was called with unnamed arguments, then it will pass an Array of the
arguments; if the R arguments are named then it will pass an Object with
key-value pairs. For example, calling `js$foo("bar", 5)` in R will call
`shinyjs.foo(["bar", 5])` in JS, while calling
`js$foo(num = 5, id = "bar")` in R will call
`shinyjs.foo({num : 5, id : "bar"})` in JS. This means that the
`shinyjs.foo` function needs to be able to deal with both types of
parameters.

To assist in normalizing the parameters, `shinyjs` provides a
`shinyjs.getParams()` function which serves two purposes. First of all,
it ensures that all arguments are named (even if the R function was
called without names). Secondly, it allows you to define default values
for arguments. Here is an example of a JS function that changes the
background colour of an element and uses `shinyjs.getParams()`.

    shinyjs.backgroundCol = function(params) {
      var defaultParams = {
        id : null,
        col : "red"
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      el.css("background-color", params.col);
    }

Note the `defaultParams` that we defined and the call to
`shinyjs.getParams`. It ensures that calling
`js$backgroundCol("test", "blue")` and
`js$backgroundCol(id = "test", col = "blue")` and
`js$backgroundCol(col = "blue", id = "test")` are all equivalent, and
that if the colour parameter is not provided then "red" will be the
default. All the functions provided in `shinyjs` make use of
`shinyjs.getParams`, and it is highly recommended to always use it in
your functions as well. Notice that the order of the arguments in
`defaultParams` in the JavaScript function matches the order of the
arguments when calling the function in R with unnamed arguments. This
means that `js$backgroundCol("blue", "test")` will not work because the
arguments are unnamed and the JS function expects the id to come before
the colour.

For completeness, here is the code for a shiny app that uses the above
function (it's not a very practical example, but it's great for showing
how to use `extendShinyjs` with parameters):

    library(shiny)
    library(shinyjs)

    jsCode <- '
    shinyjs.backgroundCol = function(params) {
      var defaultParams = {
        id : null,
        col : "red"
      };
      params = shinyjs.getParams(params, defaultParams);

      var el = $("#" + params.id);
      el.css("background-color", params.col);
    }'

    shinyApp(
      ui = fluidPage(
        useShinyjs(),
        extendShinyjs(text = jsCode),
        p(id = "name", "My name is Dean"),
        p(id = "sport", "I like soccer"),
        selectInput("col", "Colour:",
                    c("white", "yellow", "red", "blue", "purple")),    
        textInput("selector", "Element", ""),
        actionButton("btn", "Go")
      ),
      server = function(input, output) {
        observeEvent(input$btn, {
          js$backgroundCol(input$selector, input$col)
        })
      }
    )

And the resulting app:

![Extendshinyjs params
demo](http://deanattali.com/img/blog/shinyjs-improvements/extendshinyjs-params.gif)

Note that I chose to define the JS code as a string for illustration
purposes, but in reality I would prefer to place the code in a separate
file and use the `script` argument instead of `text`.

<h3 id="extendshinyjs-v8">
Note about V8 prerequisite
</h3>
In order to use `extendShinyjs`, you should have the `V8` package
installed. You can install it with `install.packages("V8")`.

If you are deploying an app that uses `extendShinyjs` to
[*shinyapps.io*](http://www.shinyapps.io/) then you need to add a call
to `library(V8)` somewhere in your code. This is necessary because the
shinyapps.io server needs to know that it should install the `V8`
package. If you do not do this then you will simply see an error saying
the package is missing.

If you cannot install the `V8` package on your machine (some very old
operating systems don't support it), then you can still use
`extendShinyjs()` but you will have to provide the `functions` argument.
Read more about this argument with `?shinyjs::extendShinyjs`.

<h2 id="faq-tricks">
FAQ and extra tricks
</h2>
There are several questions that pop up very frequently in my email or
on StackOverflow about "How do I use shinyjs to do \_\_\_?" Here is a
list of a few of these common questions with links to a solution that
could be useful. Note that all of these require using `extendShinyjs()`.

-   [How do I show/hide the `shinydashboard` sidebar
    programmatically?](http://stackoverflow.com/a/31306707/3943160)
-   [How do I hide/disable a
    tab?](http://stackoverflow.com/a/31719425/3943160)
-   [How do I refresh the
    page?](http://stackoverflow.com/a/34758024/3943160)
-   [How do I call a JavaScript function from a different JavaScript
    library?](https://github.com/timelyportfolio/sweetalertR/issues/1#issuecomment-151685005)
-   [How do I change the values of a
    `sliderInput`?](http://stackoverflow.com/a/31066997/3943160)
-   [How do I call JavaScript code and use the return
    value?](http://stackoverflow.com/a/34728125/3943160)

Motivation & alternatives using native Shiny
--------------------------------------------

The initial release of this package was announced [on my
blog](http://deanattali.com/2015/04/23/shinyjs-r-package/) and discusses
these topics.

Contributions
-------------

If you have any suggestions or feedback, I would love to hear about it.
You can either [message me
directly](http://deanattali.com/aboutme#contact), [open an
issue](https://github.com/daattali/shinyjs/issues) if you want to
request a feature/report a bug, or make a pull request if you can
contribute. I'd like to give special thanks to the Shiny developers,
especially [Joe Cheng](http://www.joecheng.com/) for always answering
all my Shiny questions.
