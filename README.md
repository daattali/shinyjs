<!-- To create this README, I run devtools::build_vignettes(), then
rmarkdown::render("vignettes/overview.Rmd", output_format = "md_document"),
copy the contents of vignettes/overview.md here,
fix the image path (remove the ".."),
and add the TravisCI status -->

# shinyjs - Perform common JavaScript operations in Shiny apps using plain R code

[![Build Status](https://travis-ci.org/daattali/shinyjs.svg?branch=master)](https://travis-ci.org/daattali/shinyjs)

`shinyjs` lets you perform common useful JavaScript operations in Shiny
applications without having to know any JavaScript. Examples include
hiding an element, disabling an input, resetting an input back to its
original value, and many more useful functions. You can [check out a
demo Shiny app](http://daattali.com/shiny/shinyjs-demo/) that lets you
play around with some of the functionality that `shinyjs` makes
available, or [have a look at a very basic Shiny
app](http://daattali.com/shiny/shinyjs-basic/) that uses `shinyjs` to
enhance the user experience with very minimal and simple R code.

Installation
------------

`shinyjs` is available through both CRAN and GitHub:

To install the CRAN version:

    install.packages("shinyjs")

To install the latest developmental version from GitHub:

    install.packages("devtools")
    devtools::install_github("daattali/shinyjs")

Overview of main functions
--------------------------

-   `show`/`hide`/`toggle` - display or hide an element. There are
    arguments that control the animation as well, though animation is
    off by default.

-   `hidden` - initialize a Shiny tag as invisible (can be shown later
    with a call to `show`).

-   `reset` - reset a Shiny input widget back to its original value.

-   `enable`/`disable`/`toggleState` - enable or disable an input
    element, such as a button or a text input.

-   `info` - show a message to the user (using JavaScript's `alert`
    under the hood).

-   `text` - change the text/HTML of an element (using JavaScript's
    `innerHTML` under the hood).

-   `onclick` - run R code when an element is clicked. Was originally
    developed with the sole purpose of running a `shinyjs` function when
    an element is clicked, though any R code can be used.

-   `addClass`/`removeClass`/`toggleClass` - add or remove a CSS class
    from an element

-   `inlineCSS` - easily add inline CSS to a Shiny app.

-   `logjs` - print a message to the JavaScript console (mainly used for
    debugging purposes).

-   `runjs` - run arbitrary JavaScript code (not recommended to use this
    in a published Shiny app).

[Check out the demo Shiny app](http://daattali.com/shiny/shinyjs-demo/)
to see some of these in action, or install `shinyjs` and run
`shinyjs::runExample()` to see more demo apps.

Motivation
----------

Shiny is a fantastic R package provided by RStudio that lets you turn
any R code into an interactive webpage. It's very powerful and one of
the most useful packages in my opinion. But there are just a few simple
pieces of functionality that I always find missing and I implement
myself in my Shiny apps using JavaScript (JS) because it's either not
supported natively by Shiny or it's just cleaner to do so. Simple things
like showing/hiding elements, enabling/disabling a button, showing a
popup message to the user, manipulating the CSS class or HTML content of
an element, etc.

After noticing that I'm writing the same JS code in all my apps, and
since making Shiny talk to JS is a bit tedious and annoying with all the
message passing, I decided to just package it to make it easily
reusable. Now I can simply call `hide("panel")` or `disable("button")`.
I was lucky enough to have previous experience with JS so I knew how to
achieve the results that I wanted, but for any Shiny developer who is
not proficient in JS, hopefully this package will make it easy to extend
the power of their Shiny apps.

Basic use case - working example
--------------------------------

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
prefer to declare the UI and server separately, but I do it like this
here for brevity.*

Here is what that app would look like

![Demo app](inst/img/demo-basic-v1.png)

Now suppose we want to add a few features to the app to make it a bit
more user-friendly. First we need to set up the app to use `shinyjs`
with two small changes

1.  A call to `useShinyjs()` needs to be made in the Shiny app's UI.
    This is required to set up all the JavaScript and a few other
    things.

2.  The app's server needs to have the `session` parameter declared, ie.
    initialize the server as `server(input, output, session)` instead of
    `server(input, output)`.

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

    shinyjs::onclick("update", shinyjs::text("time", date()))

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

**The final code looks like this** (I'm using the more compact `toggle*`
version where possible)

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
      
      server = function(input, output, session) {
        observe({
          shinyjs::toggleState("submit", !is.null(input$name) && input$name != "")
        })
        
        shinyjs::onclick("toggleAdvanced",
                         shinyjs::toggle(id = "advanced", anim = TRUE))    
        
        shinyjs::onclick("update", shinyjs::text("time", date()))
        
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

Altenatives using native Shiny
------------------------------

The initial release of this package was announced [on my
blog](http://deanattali.com/2015/04/23/shinyjs-r-package/) and discusses
this topic.

## Contributions

If anyone has any suggestions or feedback, I would love to hear about it. If you have improvements, feel free to make a pull request.  I'd like to give a special thanks to the Shiny developers, especially [Joe Cheng](http://www.joecheng.com/) for always answering all my Shiny questions.
