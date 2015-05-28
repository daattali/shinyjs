#' Extend shinyjs with your own JavaScript functions
#'
#' Add your own JavaScript functions that can be called from R as if they were
#' regular R functions. This is a more advanced technique and can only
#' be used if you know JavaScript. See 'Basic Usage' below for more information
#' or \href{https://github.com/daattali/shinyjs}{view the full README} to learn
#' more.
#'
#' @section Basic Usage:
#' Any JavaScript function defined in your script that begins with `shinyjs.`
#' will be available to run from R through the `js$` variable. For example,
#' if you write a JavaScript function called `shinyjs.myfunc`, then you can
#' call it in R with `js$myfunc()`.
#'
#' It's recommended to write JavaScript code in a separate file and provide the
#' filename as the `script` argument, but it's also possible to use the `text`
#' argument to provide a string containing valid JavaScript code. Using the
#' `text` argument is meant to be used when your JavaScript code is very short
#' and simple.
#'
#' As a simple example, here are the steps required to add a
#' JavaScript function that shows a message to the user (similar to
#' \code{\link[shinyjs]{info}}):
#'
#' \itemize{
#'   \item Create a JavaScript file inside the Shiny app's directory
#'
#'   \code{www/js/shinyjs-ext.js}
#'   \item Add the following JavaScript function to the file:
#'
#'     \code{shinyjs.myfunc = function(params) { alert(params); }}
#'   \item In your Shiny app's UI, add a call to
#'
#'     \code{shinyjs::extendShinyjs("www/js/shinyjs-ext.js")}
#'   \item Alternatively, instead of the previous three steps you can
#'   provide the JavaScript code inline since it's fairly short:
#'
#'     \code{shinyjs::extendShinyjs(text = "shinyjs.myfunc = function(params) { alert(params); }")}
#'   \item Now in your Shiny app's server you can call
#'     \code{js$myfunc("Hello!")} and you will get a JavaScript message.
#' }
#'
#' You can add more functions to the JavaScript file, but remember that every
#' function you want to use within R has to have a name beginning with
#' `shinyjs.`. See the section on passing arguments or the examples below
#' to see a more realistic example of how to implement a function with
#' arguments.
#'
#' @section Passing arguments from R to JavaScript:
#' \code{shinyjs} will pass a single array-like parameter to your JavaScript function.
#' If the function in R was called with unnamed arguments, then it will pass
#' an \code{Array} of the arguments; if the R arguments are named then
#' it will pass an \code{Object} with key-value pairs (each key is an argument
#' name and the value is the argument's value).
#'
#' To assist with normalizing the parameters, you can call the
#' \code{shinyjs.getParams(params, defaults)} function:
#' \itemize{
#'   \item \code{params} are the parameters that are passed to your
#'     JavaScript function
#'
#'   \item \code{defaults} is an Object with key-value pairs of parameters,
#'     where each key is a parameter name and each value is a default value.
#'     \code{shinyjs.myfunc = function(params) { alert(params); }}
#' }
#' The order of the parameters in this \code{defaults} object should match the
#' order of the parameters that users should use if they choose not to use
#' named arguments.
#'
#' For example, if a JavaScript function expects an id parameter and a length
#' parameter (in that order), then these could be the first few lines of the function:
#'
#' \preformatted{
#'   shinyjs.myfunc(params) \{
#'     var defaultParams = { id : null, length : 5 };
#'     params = shinyjs.getParams(params, defaultParams);
#'     // function body
#'   \}
#' }
#'
#' This function could be called either with \code{js$myfunc('test')} or
#' \code{js$myfunc('test', 10)} or \code{js$myfunc(length = 10, id = 'test')}
#' @param script Path to a JavaScript file that contains all the functions.
#' Each function name must begin with `shinyjs.`, for example
#' `shinyjs.myfunc`. See 'Basic Usage' below.
#' @param text Inline JavaScript code to use. If your JavaScript function is very
#' short and you don't want to create a separate file for it, you can provide the
#' code as a string. See 'Basic Usage' below.
#' @return Scripts that \code{shinyjs} requires in order to run your JavaScript
#' functions as if they were R code.
#' @note You still need to call \code{useShinyjs()} as usual, and you need to
#' call \code{useShinyjs()} before calling \code{extendShinyjs()}.
#' @seealso \code{\link[shinyjs]{runExample}}
#' @examples
#' \dontrun{
#'   Example 1:
#'   Change the page background to red when a button is clicked.
#'   This example uses the `text` argument to provide short JavaScript code inline.
#'   
#'       library(shiny)
#'       runApp(shinyApp(
#'         ui = fluidPage(
#'           useShinyjs(),
#'           extendShinyjs(text =
#'             "shinyjs.red = function(){$('body').css('background', 'red');}"),
#'           actionButton("btn", "Click me")
#'         ),
#'         server = function(input, output, session) {
#'           observeEvent(input$btn, {
#'             js$red()
#'           })
#'         }
#'       ))
#' 
#'   ==============
#' 
#'   Example 2:
#'   Create an `increment` function that increments the number inside an HTML
#'   tag (increment by 1 by default, with an optional parameter).
#'
#'   Create a JavaScript file "myfuncs.js":
#'     shinyjs.increment = function(params) {
#'       var defaultParams = {
#'         id : null,
#'         num : 1
#'       };
#'       params = shinyjs.getParams(params, defaultParams);
#'
#'       var el = $("#" + params.id);
#'       el.text(parseInt(el.text()) + params.num);
#'     }
#'
#'     And a shiny app that uses the custom function we just defined. Note how
#'     the arguments can be either passed as named or unnamed, and how default
#'     values are set if no value is given to a parameter.
#'
#'       library(shiny)
#'       runApp(shinyApp(
#'         ui = fluidPage(
#'           useShinyjs(),
#'           extendShinyjs("myfuncs.js"),
#'           p(id = "number", 0),
#'           actionButton("add", "js$increment('number')"),
#'           actionButton("add5", "js$increment('number', 5)"),
#'           actionButton("add10", "js$increment(num = 10, id = 'number')")
#'         ),
#'         server = function(input,output,session) {
#'           observeEvent(input$add, {
#'             js$increment('number')
#'           })
#'           observeEvent(input$add5, {
#'             js$increment('number', 5)
#'           })
#'           observeEvent(input$add10, {
#'             js$increment(num = 10, id = 'number')
#'           })
#'         }
#'       ))
#' }
#' @export
extendShinyjs <- function(script, text) {
  if (!requireNamespace("V8", quietly = TRUE)) {
    errMsg("V8 package is required to use `extendShinyjs`. Please install it.")
  }
  
  if (missing(script) && missing(text)) {
    errMsg("Either `script` or `text` need to be provided.")
  }

  # create a js context with a `shinyjs` object that user-defined functions
  # can populate
  ct <- V8::new_context(NULL, FALSE, FALSE)
  ct$assign("shinyjs", c())
  
  # read functions from a script
  if (!missing(script)) {
    if (!file.exists(script)) {
      errMsg(sprintf("Could not find JavaScript file `%s`.", script))
    }
    tryCatch({
      ct$source(script)
    }, error = function(err) {
      errMsg(sprintf("Error parsing the JavaScript file: %s.", err$message))
    })
  }
  
  # read functions from in-line text
  if (!missing(text)) {
    tryCatch({
      ct$eval(text)
    }, error = function(err) {
      errMsg(sprintf("Error parsing the JavaScript code provided.", err$message))
    })
  }
  
  # find out what functions the user defined 
  jsFuncs <- ct$get(V8::JS("Object.keys(shinyjs)"))
  if (length(jsFuncs) == 0) {
    errMsg(paste0("Could not find any shinyjs functions in the JavaScript file. ",
                  "Did you remember to prepend every function's name with `shinyjs.`?"))
  }

  # add all the given functions to the shinyjs namespace so that they can be
  # called as if they were regular shinyjs functions
  lapply(jsFuncs, function(x) {
    assign(x, jsFunc, js)
  })
  
  # set up the message handlers for all functions
  setupJS(jsFuncs, script, text)
}


#' Call user-defined JavaScript functions from R
#' @seealso \code{\link[shinyjs]{extendShinyjs}}
#' @export
#' @keywords internal
js <- new.env()
