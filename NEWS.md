# shinyjs 0.6

2016-04-24

- `info()` fuction: don't include surrounding quotations if not necessary (#59)
- added documentation for how to use `shinyjs` in HTML templates 

# shinyjs 0.5.3

2016-04-05

- Fixed bug with `extendShinyjs()` where it didn't work when using a script and didn't have `V8` installed (#64)

# shinyjs 0.5.2

2016-03-25

- Added `numCols` parameter to the `colourPicker()` gadget

# shinyjs 0.5.1

2016-03-23

- Added `returnName` parameter to `colourInput()`, which lets you get an R colour name instead of HEX value as the return value (#62)

# shinyjs 0.5.0

2016-03-19

- Added an awesome colour picker gadget and addin.  Use `colourPicker()` to open a gadget that lets you pick colours, or choose *Colour Picker* from the *Addins* menu to run it.

# shinyjs 0.4.1

2016-01-31

- `html()` function: don't attempt to change innerHTML if the element does not exist

# shinyjs 0.4.0

2016-01-16

- **BREAKING CHANGE**: the `text` function has been renamed to `html` (#42)

- shinyjs now works with the new modules feature of Shiny (#50)

- Refactor how shinyjs R engine works: instead of using cool meta programming that minimizes code and sends each shinyjs function request straight to JS, add a thin layer or R code for each function. This allows us to check the arguments, run custom code for each function, it allows the documentation to show the arguments instead of them being `...`, and it fixes a few edge cases of calling shinyjs functions, such as calling shinyjs using `do.call()` (#51)

- Update vignette/readme to include FAQ

- Change internally the name of shinyjs functions to make the JavaScript function names more unique to avoid potential conflicts with user-defined JS functions

# shinyjs 0.3.2

2016-01-08

- Show warning when using Shiny modules because they aren't supported yet

# shinyjs 0.3.0

2015-12-30

- bug fix: `hidden()` now works when used on an element with a `display` CSS property


# shinyjs 0.2.6

2015-12-14

- bug fix: `show`/`hide` always trigger shown/hidden events

# shinyjs 0.2.5

2015-12-14

- small UI change to colourInput demo shiny app

# shinyjs 0.2.4

2015-12-01

- Support `extendShinyjs()` for users that cannot install the `V8` package

# shinyjs 0.2.3

2015-11-05

- Updated README


# shinyjs 0.2.2

2015-09-15

- added `html` argument to `useShinyjs()`, which adds support for using shinyjs in shiny apps that are built with index.html instead of using Shiny UI (more details in the README)
- refactored internally how shinyjs resources are handled so that the resource path is now prefixed with "shinyjs" or "shinyjs-extend" instead of a random string

# shinyjs 0.2.1

2015-09-13

- add a `debug` parameter to `useShinyjs` that will cause detailed debugging messages to be printed to the JavaScript console when turned on

# shinyjs 0.2.0

2015-09-05

- version bump for CRAN submission

# shinyjs 0.1.4

2015-09-05

- refactor JavaScript code to remove code duplication and add better internal documentation
- bug fix: `disabled` now works with all input types
- bug fix: `enable`/`disable` did not work on `selectInput`, `sliderInput`, and `actionButton`
- bug fix: resetting a slider input with a range did not reset the end point, only the start point

# shinyjs 0.1.3

2015-09-05

- `onclick` and `onevent` now work with dynamically generated elements. Not a trivial fix, but enough people requested it that it was important

# shinyjs 0.1.2

2015-09-04

**Lots of big changes**

- added `delay` function, which allows you to run code after a specified amount of time has elapsed
- **BREAKING CHANGE** - removed `delay` parameter from `hide`/`show`/`toggle` because the same behaviour can now be achieved using the `delay` function (if you previously used `show(id = "text", delay = 2)`, you can now use `delay(2000, show("text"))`)
- added `onevent` function, which is similar to `onclick` but can be used for many other different events
- `reset` now works with dynamically generated elements (inputs that are created with `renderUI`)
- make `disabled` work for dynamically generated elements
- removed defunc `resettable` function

# shinyjs 0.1.1

2015-08-19

- better debugging: when a shinyjs JavaScript function is called with a mix of both named and unnamed arguments (which is not allowed), tell the user what function exactly was called. This is done because sometimes a different package doesn't properly namespace its function calls and end up accidentally calling shinyjs functions, which results in weird bugs.
- add comments to the `onclick` documentation, to make it clear that it can't work with dynamic UIs
- improved documentation

# shinyjs 0.1.0

2015-08-12

- add support for `shinyjs.init` function when using `extendShinyjs` that runs when the page loads. This provides the user a way to register event handlers or do some initializations that automatically run on page load rather than calling it manually in the server
- add `disabled` function that initializes a Shiny input in a disabled state
- add a `rmd` parameter to `useShinyjs` that lets you use shinyjs inside interactive R markdown documents (default is FALSE to favour regular Shiny apps)
- the bulk of the shinyjs JavaScript code is no longer embeded in the HTML as text and is instead linked to as a file. This makes the Shiny app's HTML much cleaner and smaller
- use htmltools dependency system for handling javascript/css dependencies

# shinyjs 0.0.8.3

2015-07-30

- `disable`/`enable` now work for `downloadButton` elements

# shinyjs 0.0.8.2

2015-07-23

- You no longer need to define the server function with the `session` parameter! A shiny server function defined as `server = function(input, output) {...}` can work with `shinyjs`

# shinyjs 0.0.8.1

2015-07-17

- Fix bug where periods in element names weren't working for some shinyjs functions

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

