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
