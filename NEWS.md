# shinyjs 0.0.2.0

The user is no longer required to set the shiny session or to pass it into any
function calls. Every *shinyjs* function will try to dynamically figure out the
correct Shiny session to use.  The previous code with explicit sessions is still
in the codebase but has been commented out so that it'll be easy to switch back
to it in the near future in case the new approach doesn't always work.
