---
layout: base
title: shinyjs
subtitle: Easily improve the user experience in your Shiny apps in seconds
css: /css/index.css
---

<div style="
    text-align: center;
    margin-top: 90px;

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

<div>

<div style="
    text-align: center;
    color: #074f66;
    margin-top: 50px;
    font-size: 30px;
    font-weight: bold;
    font-family: arial;
">What is shinyjs?</div>
<div style="
    font-size: 22px;
    text-align: center;
    margin-left: auto;
    font-family: Arial;
    margin-top: 30px;
    margin-right: auto;
">shinyjs lets you perform common useful JavaScript operations in Shiny apps that will greatly improve your apps.<span style="
    margin-top: 4px;
    display: block;
    font-style: italic;
  ">Without having to know any JavaScript.</span></div></div>
  
  
  
<hr/>

<div id="what-it-does" style="
    font-family: arial;
    padding: 0 200px;
    font-size: 20px;
    margin-top: 0;
    text-align: center;
    margin-left: auto;
    margin-right: auto;
"><span style="
    font-size: 30px;
    color: #074f66;
    display: block;
    font-weight: bold;
    margin-top: 40px;
">What can shinyjs do?</span><div style="
    /* width: 500px; */
    margin-top: 15px;
    /* margin: 0 auto; */
    /* text-align: left; */
">
  <div style="
"><i class="fa fa-eye"></i>Hide (or show) an element</div><div><i class="fa fa-ban"></i>Disable (or enable) an input</div><div><i class="fa fa-repeat"></i>Reset an input back to its original value</div><div><i class="fa fa-clock-o"></i>Delay code execution by a few seconds</div><div><i class="fa fa-globe"></i>Easily call your own custom JavaScript functions from R</div><div><i class="fa fa-check"></i>Many useful functions for both the app developer and users</div></div></div>

<div style="
    margin-bottom: 400px;
    margin-top: 50px;
    background: #fff;
    text-align: left;
    padding: 40px 30px 10px;
    font-size: 18px;
    font-family: arial;
    width: 700px;
    margin-left: auto;
    border-radius: 4px;
    margin-right: auto;
">shinyjs was developed for non-commerical purposes. For commerical usage, please <a href="http://deanattali.com/contact">contact me</a>.<span style="
    display: block;
    margin-top: 15px;
">If you find shinyjs useful, please consider supporting its development!</span>
<div style="
    text-align: center;
    margin-top: 20px;
    margin-bottom: 19px;
"><i class="fa fa-smile-o" style="
    font-size: 40px;
  "></i></div>

<p align="center" style="
    margin-top: 15px;
">
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=5ETAMYQ3JSPEU">
    <img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif">
  </a>
</p>
</div>

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
