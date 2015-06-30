# shinyjs 0.0.8.0

2015-06-30

- added an option to allow only a predefined list of colours to select from in `colourInput` (feature request from Hadley and other Twitter users)

# shinyjs 0.0.7.0

2015-06-23

- add `selector` param to the `disable`/`enable`/`toggleState` functions and the
`addClass`/`removeClass`/`toggleClass` functions so that multiple elements can
be targeted in batch
- added `transparentText` param to `colourInput`

# shinyjs 0.0.6.6

2015-06-22

- added a demo app using `colourInput` that's available via `runExample` and [on my shiny server](http://daattali.com/shiny/colourInput/)
- add a transparency option to `colourInput`
- complete refactor of `colourInput` using a better library that I modified to work well with shiny inputs
- including multiple `useShinyjs()` or `extendShinyjs()` will not result in duplicated HTML anymore. This can be useful if the UI is including a few external UI pieces and they independently make a call to `useShinyjs()`.

# shinyjs 0.0.6.5

2015-06-17

- added `colourInput` that can be used as an input element to select colours, and its corresponding `updateColourInput`. This doesn't really fit the `shinyjs` model of running JS functions, this feels like something very different from the rest of the functions in this package, it might move somewhere else in the future.

# shinyjs 0.0.6.4

2015-05-30

- `hidden` can now accept multiple tags or a tagList or a list of tags (previously only a single tags was allowed)

- allow `hide`/`show`/`toggle` to be run on any JQuery selector, not only on a single ID

# shinyjs 0.0.6.3

2015-05-28

- added `delay` argument to `hide`/`show`/`toggle` so that you can now hide
or show an element after a short delay instead of immediately. Useful for 
showing a message for a few seconds and then fading it away.

# shinyjs 0.0.6.2

2015-05-27

- added `text` argument to `extendShinyjs` so that JavaScript code can be provided
as a string instead of in a separate file. Useful if your JS code is very short
and simple and you don't want to create a new file

# shinyjs 0.0.6.0

2015-05-25

- add `extendShinyjs` function - allow users to add their own JavaScript functions
that can be called as if they are regular R code

- `disable` and `enable` now work for ALL shiny input types

- `show` and `hide` now work for any HTML tag including all shiny input types

- better `onclick` behaviour - when set on a shiny input, trigger the event
when any part of the input is clicked

- improve implementation of `reset` and simplify function call to it


# shinyjs 0.0.5.0

2015-05-23

- add `reset` function that allows input elements to be reset to their original values

- add function `runjs` to run arbitrary javascript code (not recommended to use in published shiny apps)

- relax R version requirement to 3.1.0

- look for session object in all parent frames, so that shinyjs functions can work from helper functions and not only from within the main server function

- refacor internal code

- update example apps and vignette to include `reset` function and `condition` param in `toggle` functions


# shinyjs 0.0.4.0

2015-04-24

- add a `condition` argument to `toggle`/`toggleState`/`toggleClass` that allows
you to pass a boolean condition to determine if to show/hide (enable/disable, etc)
based on that condition. Useful to do things like
`toggleState(id = "submitBtn", condition = nchar(input$text) >= 3)`

- fix `hidden` so that if there are elements created dynamically using `renderUI`,
shiny will render them when they are made visible

- better implementation of `toggle`

- using `enable`/`disable`/`toggleState` on a selectize input works

- better implementation of `toggleState`

# shinyjs 0.0.3.3

2015-04-21

CRAN resubmission

# shinyjs 0.0.3.0

2015-04-18

- bugfixes to `onclick()` (evaluate expressions in the correct environment)

- rename `alert()` to `info()` because when the app was deployed in a Shiny Server (shinyapps.io or my own shiny server), it was printing the alret twice - probably because shiny server somehow intercepts the `alert` call too

- rename `innerHTML()` to `text()` to make it more understandable for the average user

- add `add` param to `onclick()`

- add `add` param to `text()`

- add `inlineCSS()` function to easily add inline CSS to a Shiny app

- add documentation to all functions

- add "demo" example app that provides a safe way to  experiment with shinyjs by providing a predetermined set of functions to run

- add "basic" example app that shows how some `shinyjs` functions can be used
together in a real (very simply) Shiny app

- add vignette and README, get ready for CRAN submission

# shinyjs 0.0.2.1

2015-04-02

New function: **onclick** - allows the user to run an R expression (including
*shinyjs* expressions) when a specific element in the Shiny app is clicked. 


# shinyjs 0.0.2.0

2015-04-02

The user is no longer required to set the shiny session or to pass it into any
function calls. Every *shinyjs* function will try to dynamically figure out the
correct Shiny session to use.  The previous code with explicit sessions is still
in the codebase but has been commented out so that it'll be easy to switch back
to it in the near future in case the new approach doesn't always work.

This has been a pending change for a while but I was hesitant to use it because
I still don't *fully* understand the call stack and I'm not 100% sure this will
always be correct. But it does make sense to me and it seems to work so I'll
give it a go.
