[![shinyjs](inst/img/banner.png)](https://deanattali.com/shinyjs/)

<h3 align="center">

shinyjs

</h3>

<h4 align="center">

Easily improve the user experience of your Shiny apps in seconds
<br><br> <a href="https://deanattali.com/shinyjs/">Official website</a>
· by <a href="https://deanattali.com">Dean Attali</a>

</h4>

<p align="center">

<a href="https://xscode.com/daattali/shinyjs">
<img src="https://img.shields.io/badge/Available%20on-xs%3Acode-blue?style=?style=plastic&logo=appveyor&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAAZQTFRF////////VXz1bAAAAAJ0Uk5T/wDltzBKAAAAlUlEQVR42uzXSwqAMAwE0Mn9L+3Ggtgkk35QwcnSJo9S+yGwM9DCooCbgn4YrJ4CIPUcQF7/XSBbx2TEz4sAZ2q1RAECBAiYBlCtvwN+KiYAlG7UDGj59MViT9hOwEqAhYCtAsUZvL6I6W8c2wcbd+LIWSCHSTeSAAECngN4xxIDSK9f4B9t377Wd7H5Nt7/Xz8eAgwAvesLRjYYPuUAAAAASUVORK5CYII=" alt="Purchase shinyjs services on xcode" />
</a> <a href="https://travis-ci.org/daattali/shinyjs">
<img src="https://travis-ci.org/daattali/shinyjs.svg?branch=master" alt="Build Status" />
</a> <a href="https://cran.r-project.org/package=shinyjs">
<img src="https://www.r-pkg.org/badges/version/shinyjs" alt="CRAN version" />
</a>

</p>

</p>

-----

`shinyjs` lets you perform common useful JavaScript operations in Shiny
apps that will greatly improve your apps without having to know any
JavaScript.

Examples include: hiding an element, disabling an input, resetting an
input back to its original value, delaying code execution by a few
seconds, and many more useful functions for both the end user and the
developer. `shinyjs` can also be used to easily call your own custom
JavaScript functions from R.

**If you find shinyjs useful, please consider supporting its
development\!**

<p align="center">

<a style="display: inline-block; margin-left: 10px;" href="https://github.com/sponsors/daattali">
<img height="35" src="https://i.imgur.com/034B8vq.png" /> </a>
<a style="display: inline-block;" href="https://paypal.me/daattali">
<img height="35" src="https://camo.githubusercontent.com/0e9e5cac101f7093336b4589c380ab5dcfdcbab0/68747470733a2f2f63646e2e6a7364656c6976722e6e65742f67682f74776f6c66736f6e2f70617970616c2d6769746875622d627574746f6e40312e302e302f646973742f627574746f6e2e737667" />
</a>

</p>

# Table of contents

  - [Demos and tutorials](#demos)
  - [Overview of main functions](#overview-main)
  - [Installation](#install)
  - [How to use](#usage)
  - [Basic use case - complete working example](#usecase)
  - [Calling your own JavaScript functions from R](#extendshinyjs)
  - [FAQ and extra tricks](#faq-tricks)
  - [Support](#support)

<h2 id="demos">

Demos and tutorials

</h2>

  - [Demo Shiny app](https://deanattali.com/shinyjs/demo) that lets you
    play around with some of the functionality in `shinyjs`.
  - [Video of my shinyjs
    talk](https://deanattali.com/shinyjs-shinydevcon-2016/) (30 min) and
    the corresponding [presentation
    slides](https://bit.ly/shinyjs-slides) from the 2016 Shiny Developer
    Conference.
  - [Video of my shinyjs
    talk](https://deanattali.com/shinyjs-user-2016/) (5 min) and the
    corresponding [presentation
    slides](https://bit.ly/shinyjs-slides-useR2016) from the 2016 useR
    Conference.

<h2 id="overview-main">

Overview of main functions

</h2>

**Note: In order to use any `shinyjs` function in a Shiny app, you must
first call `useShinyjs()` anywhere in the app’s UI.**

<table>
<colgroup>
<col style="width: 28%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr class="header">
<th>Function</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><code>show</code>/<code>hide</code>/<code>toggle</code></td>
<td>Display or hide an element (optionally with an animation).</td>
</tr>
<tr class="even">
<td><code>hidden</code></td>
<td>Initialize a Shiny tag as invisible (can be shown later with a call to <code>show</code>).</td>
</tr>
<tr class="odd">
<td><code>enable</code>/<code>disable</code>/<code>toggleState</code></td>
<td>Enable or disable an input element, such as a button or a text input.</td>
</tr>
<tr class="even">
<td><code>disabled</code></td>
<td>Initialize a Shiny input as disabled.</td>
</tr>
<tr class="odd">
<td><code>reset</code></td>
<td>Reset a Shiny input widget back to its original value.</td>
</tr>
<tr class="even">
<td><code>refresh</code></td>
<td>Refresh the page.</td>
</tr>
<tr class="odd">
<td><code>delay</code></td>
<td>Execute R code (including any <code>shinyjs</code> functions) after a specified amount of time.</td>
</tr>
<tr class="even">
<td><code>alert</code></td>
<td>Show a message to the user.</td>
</tr>
<tr class="odd">
<td><code>click</code></td>
<td>Simulate a click on a button.</td>
</tr>
<tr class="even">
<td><code>html</code></td>
<td>Change the text/HTML of an element.</td>
</tr>
<tr class="odd">
<td><code>onclick</code></td>
<td>Run R code when a specific element is clicked. Was originally developed with the sole purpose of running a <code>shinyjs</code> function when an element is clicked, though any R code can be used.</td>
</tr>
<tr class="even">
<td><code>onevent</code></td>
<td>Similar to <code>onclick</code>, but can be used with many other events instead of click (for example, listen for a key press, mouse hover, etc).</td>
</tr>
<tr class="odd">
<td><code>addClass</code>/<code>removeClass</code>/<code>toggleClass</code></td>
<td>add or remove a CSS class from an element.</td>
</tr>
<tr class="even">
<td><code>runjs</code></td>
<td>Run arbitrary JavaScript code.</td>
</tr>
<tr class="odd">
<td><code>extendShinyjs</code></td>
<td>Allows you to write your own JavaScript functions and use <code>shinyjs</code> to call them as if they were regular R code. More information is available in the section “Calling your own JavaScript functions from R” below.</td>
</tr>
</tbody>
</table>

### Functions that help you during Shiny app development

<table>
<colgroup>
<col style="width: 28%" />
<col style="width: 71%" />
</colgroup>
<thead>
<tr class="header">
<th>Function</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><code>runcodeUI</code>+<code>runcodeServer</code></td>
<td>Adds a text input to your app that lets you run arbitrary R code live.</td>
</tr>
<tr class="even">
<td><code>showLog</code></td>
<td>Print any JavaScript <code>console.log()</code> messages in the R console, to make it easier and quicker to debug apps without having to open the JS console.</td>
</tr>
<tr class="odd">
<td><code>logjs</code></td>
<td>Print a message to the JavaScript console (mainly used for debugging purposes).</td>
</tr>
<tr class="even">
<td><code>inlineCSS</code></td>
<td>Easily add inline CSS to a Shiny app.</td>
</tr>
</tbody>
</table>

[Check out the shinyjs demo app](https://deanattali.com/shinyjs/demo) to
see some of these in action, or install `shinyjs` and run
`shinyjs::runExample()` to see more demos.

<h2 id="install">

Installation

</h2>

To install the stable CRAN version:

    install.packages("shinyjs")

To install the latest development version from GitHub:

    install.packages("remotes")
    remotes::install_github("daattali/shinyjs")

<h2 id="usage">

How to use

</h2>

A typical Shiny app has a UI portion and a server portion. Before using
most shinyjs functions, you need to call `useShinyjs()` in the app’s UI.
It’s best to include it near the top as a convention.

Here is a minimal Shiny app that uses `shinyjs`:

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

This is how most Shiny apps should initialize `shinyjs` - by calling
`useShinyjs()` near the top of the UI.

However, if you use shinyjs in any of the following cases:

  - In Shiny dashboards (built using the `shinydashboard` package)
  - In Shiny apps that use a `navbarPage` layout
  - In Rmd documents
  - In Shiny apps that manually build the user interface with an HTML
    file or template (instead of using Shiny’s UI functions)

Then you should see the [*Including shinyjs in different types of
apps*](https://deanattali.com/shinyjs/advanced) document.

If your Shiny app doesn’t fall into any of these categories, then the
above code sample should be enough to get your started with including
shinyjs in your app.

<h2 id="usecase">

Basic use case - complete working example

</h2>

See the [*shinyjs example app
walk-through*](https://deanattali.com/shinyjs/example) document for a
step-by-step guide on how to add a variety of shinyjs features to a
simple app in order to make it more user friendly.

<h2 id="extendshinyjs">

Calling your own JavaScript functions from R

</h2>

You can also use `shinyjs` to add your own JavaScript functions that can
be called from R as if they were regular R functions using
`extendShinyjs`. This is only suitable for advanced users who are
familiar with JavaScript and wish to facilitate the communication
between R and JavaScript.

To learn about this feature and see how useful it can be, see the
[*extendShinyjs: Calling your own JavaScript functions from
R*](https://deanattali.com/shinyjs/extend) document.

<h2 id="faq-tricks">

FAQ and extra tricks

</h2>

There are several questions that pop up very frequently in my email or
on StackOverflow about “How do I use shinyjs to do \_\_\_?” Here is a
list of a few of these common questions with links to a solution that
could be useful. Note that all of these require using `extendShinyjs()`.

  - [How do I show/hide the `shinydashboard` sidebar
    programmatically?](https://stackoverflow.com/a/31306707/3943160)
  - [How do I hide/disable a
    tab?](https://stackoverflow.com/a/31719425/3943160)
  - [How do I refresh the
    page?](https://stackoverflow.com/a/34758024/3943160)
  - [How do I call a JavaScript function from a different JavaScript
    library?](https://github.com/timelyportfolio/sweetalertR/issues/1#issuecomment-151685005)
  - [How do I change the values of a
    `sliderInput`?](https://stackoverflow.com/a/31066997/3943160)
  - [How do I call JavaScript code and use the return
    value?](https://stackoverflow.com/a/34728125/3943160)

I also keep a long [list of various Shiny tips &
tricks](https://deanattali.com/blog/advanced-shiny-tips/) for solving
common Shiny problems, many of which make use of shinyjs.

<h2 id="support">

Support

</h2>

This document is only an overview of shinyjs. There are more in-depth
resources available on the [shinyjs
website](https://deanattali.com/shinyjs).

If you need help with shinyjs, free support is available on
[StackOverflow](https://stackoverflow.com/questions/ask?tags=r+shiny+shinyjs),
[RStudio
Community](https://community.rstudio.com/new-topic?category=shiny&tags=shinyjs),
and [Twitter](https://twitter.com/hashtag/rstats).

Due to the large volume of requests I receive, I’m unable to provide
free support. **If you can’t solve your problem and want my personal
help, please visit <https://xscode.com/daattali/shinyjs> or [contact
me](https://deanattali.com/contact) to receive help for a fee.**

## Contributions

If you have any suggestions or feedback, I would love to hear about it.
You can either [message me directly](https://deanattali.com/contact),
[open an issue](https://github.com/daattali/shinyjs/issues) to report a
bug or suggest a feature, or make a pull request if you can contribute.

I’d like to give special thanks to the Shiny developers, especially [Joe
Cheng](http://www.joecheng.com/) for always answering all my Shiny
questions in my early days.

Lastly, if you find shinyjs useful, please consider [supporting
me](https://github.com/sponsors/daattali) for the countless hours I’ve
spent building, documenting, and supporting this package :)
