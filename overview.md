---
layout: page
title: Overview
---

# Functions to improve user experience in your apps

In order to use any shinyjs function in a Shiny app, you must first call `useShinyjs()` anywhere in the app's UI.

| Function | Description |
|---------------------|----------------------------------------------------|
| `show` / `hide` / `toggle` | Display or hide an element (optionally with an animation). |
| `hidden` | Initialize a Shiny tag as invisible (can be shown later with a call to `show`). |
| `enable` / `disable` / `toggleState` | Enable or disable an input element, such as a button or a text input. |
| `disabled` | Initialize a Shiny input as disabled. |
| `reset` | Reset a Shiny input widget back to its original value. |
| `delay` | Execute R code (including any `shinyjs` functions) after a specified amount of time. |
| `alert` | Show a message to the  |
| `html` | Change the text/HTML of an element. |
| `onclick` | Run R code when a specific element is clicked. Was originally developed with the sole purpose of running a `shinyjs` function when an element is clicked, though any R code can be used. |
| `onevent` | Similar to `onclick`, but can be used with many other events instead of click (for example, listen for a key press, mouse hover, etc). |
| `addClass` / `removeClass` / `toggleClass` | add or remove a CSS class from an element. |
| `runjs` | Run arbitrary JavaScript code. |
| `extendShinyjs` | Allows you to write your own JavaScript functions and use `shinyjs` to call them as if they were regular R code. More information is available in the section "Calling your own JavaScript functions from R" below. |

<br/>

# Functions that help you during Shiny app development

| Function | Description |
|---------------------|----------------------------------------------------|
| `runcodeUI` + `runcodeServer` | Adds a text input to your app that lets you run arbitrary R code live. |
| `showLog` | Print any JavaScript `console.log()` messages in the R console, to make it easier and quicker to debug apps without having to open the JS console. |
| `logjs` | Print a message to the JavaScript console (mainly used for debugging purposes). |
| `inlineCSS` | Easily add inline CSS to a Shiny app. |

<h1 id="demo" class="linked-section">Demo</h1>

You can test out some shinyjs functions below. Choose some R code from the dropdown list, and click *Run*.

<iframe id="demo-iframe" src="https://daattali.com/shiny/shinyjs-mini-demo" scroll="no" width="100%" height="350px">
