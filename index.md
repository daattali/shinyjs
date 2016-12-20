---
layout: base
title: shinyjs
subtitle: Easily improve the user experience in your Shiny apps in seconds
css: /css/index.css
---

<div style="
    text-align: center;
    margin-top: 91px;

    background: #17baef;

    font-family: 'Open Sans';
    padding: 100px;
"><div style="    font-size: 120px;    font-weight: 800;"><span style="
    color: #074f66;
  ">shiny</span><span style="color: #efcd17;">js</span></div>
  <div style="
    font-size: 30px;
    color: #fff;
    text-shadow: 0px 0px 0px black;
">Easily improve the user experience in your Shiny apps in seconds</div>
</div>


<div>shinyjs lets you perform common useful JavaScript operations in Shiny apps that will greatly improve your apps without having to know any JavaScript.</div>

<div>Examples include: hiding an element, disabling an input, resetting an input back to its original value, delaying code execution by a few seconds, and many more useful functions for both the end user and the developer. shinyjs can also be used to easily call your own custom JavaScript functions from R.</div>

<div>shinyjs was developed for non-commerical purposes. For commerical usage, please contact me. If you find shinyjs useful, please consider supporting its development!</div>

<h2 id="overview-main">Overview of main functions</h2>

**Note: In order to use any `shinyjs` function in a Shiny app, you must first call `useShinyjs()` anywhere in the app's UI.**

| Function | Description |
|---------------------|----------------------------------------------------|
| `show`/`hide`/`toggle` | Display or hide an element (optionally with an animation). |
| `hidden` | Initialize a Shiny tag as invisible (can be shown later with a call to `show`). |
| `enable`/`disable`/`toggleState` | Enable or disable an input element, such as a button or a text input. |
| `disabled` | Initialize a Shiny input as disabled. |
| `reset` | Reset a Shiny input widget back to its original value. |
| `delay` | Execute R code (including any `shinyjs` functions) after a specified amount of time. |
| `alert` | Show a message to the  |
| `html` | Change the text/HTML of an element. |
| `onclick` | Run R code when a specific element is clicked. Was originally developed with the sole purpose of running a `shinyjs` function when an element is clicked, though any R code can be used. |
| `onevent` | Similar to `onclick`, but can be used with many other events instead of click (for example, listen for a key press, mouse hover, etc). |
| `addClass`/`removeClass`/`toggleClass` | add or remove a CSS class from an element. |
| `runjs` | Run arbitrary JavaScript code. |
| `extendShinyjs` | Allows you to write your own JavaScript functions and use `shinyjs` to call them as if they were regular R code. More information is available in the section "Calling your own JavaScript functions from R" below. |

### Functions that help you during Shiny app development

| Function | Description |
|---------------------|----------------------------------------------------|
| `runcodeUI`+`runcodeServer` | Adds a text input to your app that lets you run arbitrary R code live. |
| `showLog` | Print any JavaScript `console.log()` messages in the R console, to make it easier and quicker to debug apps without having to open the JS console. |
| `logjs` | Print a message to the JavaScript console (mainly used for debugging purposes). |
| `inlineCSS` | Easily add inline CSS to a Shiny app. |
