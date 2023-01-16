#' Extend shinyjs by calling your own JavaScript functions
#'
#' Add your own JavaScript functions that can be called from R as if they were
#' regular R functions. This is a more advanced technique and can only
#' be used if you know JavaScript. See 'Basic Usage' below for more information
#' or \href{https://deanattali.com/shinyjs/}{view the shinyjs webpage}
#' to learn more.
#'
#' @param script Either a path or an [`htmltools::htmlDependency()`] to a JavaScript file
#' that contains all the functions. Each function name must begin with "`shinyjs.`", for example
#' "`shinyjs.myfunc`". Note that if a path is provided, it must be discoverable by the browser
#' (ie. it needs to be in a "www/" directory or available via `addResourcePath()`).
#' See 'Basic Usage' below for more details.
#' @param text Inline JavaScript code to use instead of providing a file.
#' See 'Basic Usage' below.
#' @param functions The names of the shinyjs JavaScript functions which are defined and
#' you want to be able to call using \code{shinyjs}. For example, if you defined JavaScript functions
#' named \code{shinyjs.foo} and \code{shinyjs.bar}, then use \code{functions = c("foo", "bar")}.
#'
#' @section Basic Usage:
#' Any JavaScript function defined in your script that begins with "`shinyjs.`"
#' and that's provided in the `functions` argument will be available to run
#' from R using the "`js$`" variable. For example, if you write a JavaScript function
#' called "`shinyjs.myfunc`" and used `functions = c("myfunc")`, then you can call it
#' from R with `js$myfunc()`.
#'
#' It's recommended to write JavaScript code in a separate file and provide the
#' filename as the \code{script} argument, but it's also possible to use the
#' \code{text} argument to provide a string containing valid JavaScript code.
#'
#' Here is a basic example of using \code{extendShinyjs()}
#' to define a function that changes the colour of the page:
#'
#' \preformatted{
#' library(shiny)
#' library(shinyjs)
#'
#' jsCode <- "shinyjs.pageCol = function(params){$('body').css('background', params);}"
#'
#' shinyApp(
#'   ui = fluidPage(
#'     useShinyjs(),
#'     extendShinyjs(text = jsCode, functions = c("pageCol")),
#'     selectInput("col", "Colour:",
#'                 c("white", "yellow", "red", "blue", "purple"))
#'   ),
#'   server = function(input, output) {
#'     observeEvent(input$col, {
#'       js$pageCol(input$col)
#'     })
#'   }
#' )
#' }
#'
#' You can add more functions to the JavaScript code, but remember that every
#' function you want to use in R has to have a name beginning with
#' "`shinyjs.`". See the section on passing arguments and the examples below
#' for more information on how to write effective functions.
#'
#' @section Running JavaScript code on page load:
#' If there is any JavaScript code that you want to run immediately when the page loads,
#' you can place it inside a \code{shinyjs.init} function. The function \code{shinyjs.init}
#' will automatically be called when the Shiny app's HTML is initialized. A common
#' use for this is when registering event handlers or initializing JavaScript objects,
#' as these usually just need to run once when the page loads. The `functions` parameter
#' does not need to be told about the `init` function, so you can use an empty list
#' such as `functions = c()` (or if you have an init function together with other shinyjs
#' functions, simply list all the functions except for `init`).
#'
#' For example, the following example uses \code{shinyjs.init} to register an event
#' handler so that every keypress will print its corresponding key code:
#'
#' \preformatted{
#' jscode <- "
#' shinyjs.init = function() {
#'   $(document).keypress(function(e) { alert('Key pressed: ' + e.which); });
#' }"
#' shinyApp(
#'   ui = fluidPage(
#'     useShinyjs(),
#'     extendShinyjs(text = jscode, functions = c()),
#'     "Press any key"
#'   ),
#'   server = function(input, output) {}
#' )
#' }
#'
#' @section Passing arguments from R to JavaScript:
#' Any \code{shinyjs} function that is called will pass a single array-like
#' parameter to its corresponding JavaScript function. If the function in R was
#' called with unnamed arguments, then it will pass an Array of the arguments;
#' if the R arguments are named then it will pass an Object with key-value pairs.
#'
#' For example, calling \code{js$foo("bar", 5)} in R will call \code{shinyjs.foo(["bar", 5])}
#' in JS, while calling \code{js$foo(num = 5, id = "bar")} in R will call
#' \code{shinyjs.foo({num : 5, id : "bar"})} in JS. This means that the
#' \code{shinyjs.foo} function needs to be able to deal with both types of
#' parameters.
#'
#' To assist in normalizing the parameters, \code{shinyjs} provides a
#' \code{shinyjs.getParams()} function which serves two purposes. First of all,
#' it ensures that all arguments are named (even if the R function was called
#' without names). Secondly, it allows you to define default values for arguments.
#'
#' Here is an example of a JS function that changes the background colour of an
#' element and uses \code{shinyjs.getParams()}.
#'
#' \preformatted{
#' shinyjs.backgroundCol = function(params) {
#'   var defaultParams = {
#'     id : null,
#'     col : "red"
#'   };
#'   params = shinyjs.getParams(params, defaultParams);
#'
#'   var el = $("#" + params.id);
#'   el.css("background-color", params.col);
#' }
#' }
#'
#' Note the \code{defaultParams} object that was defined and the call to
#' \code{shinyjs.getParams}. It ensures that calling \code{js$backgroundCol("test", "blue")}
#' and \code{js$backgroundCol(id = "test", col = "blue")} and
#' \code{js$backgroundCol(col = "blue", id = "test")} are all equivalent, and
#' that if the colour parameter is not provided then "red" will be the default.
#'
#' All the functions provided in \code{shinyjs} make use of \code{shinyjs.getParams},
#' and it is highly recommended to always use it in your functions as well.
#' Notice that the order of the arguments in \code{defaultParams} in the
#' JavaScript function matches the order of the arguments when calling the
#' function in R with unnamed arguments.
#'
#' See the examples below for a shiny app that uses this JS function.
#' @return Scripts that are required by \code{shinyjs}.
#' @note You still need to call \code{useShinyjs()} as usual, and the call to
#' \code{useShinyjs()} must come before the call to \code{extendShinyjs()}.
#' @seealso \code{\link[shinyjs]{runExample}}
#' @examples
#' \dontrun{
#'   # Example 1:
#'   # Change the page background to a certain colour when a button is clicked.
#'
#'     jsCode <- "shinyjs.pageCol = function(params){$('body').css('background', params);}"
#'
#'     shinyApp(
#'       ui = fluidPage(
#'         useShinyjs(),
#'         extendShinyjs(text = jsCode, functions = c("pageCol")),
#'         selectInput("col", "Colour:",
#'                     c("white", "yellow", "red", "blue", "purple"))
#'       ),
#'       server = function(input, output) {
#'         observeEvent(input$col, {
#'           js$pageCol(input$col)
#'         })
#'       }
#'     )
#'
#'   # ==============
#'
#'   # Example 2:
#'   # Change the background colour of an element, using "red" as default
#'
#'     jsCode <- '
#'     shinyjs.backgroundCol = function(params) {
#'       var defaultParams = {
#'         id : null,
#'         col : "red"
#'       };
#'       params = shinyjs.getParams(params, defaultParams);
#'
#'       var el = $("#" + params.id);
#'       el.css("background-color", params.col);
#'     }'
#'
#'     shinyApp(
#'       ui = fluidPage(
#'         useShinyjs(),
#'         extendShinyjs(text = jsCode, functions = c("backgroundCol")),
#'         p(id = "name", "My name is Dean"),
#'         p(id = "sport", "I like soccer"),
#'         selectInput("col", "Colour",
#'                     c("green", "yellow", "red", "blue", "white")),
#'         selectInput("selector", "Element", c("sport", "name", "button")),
#'         actionButton("button", "Go")
#'       ),
#'       server = function(input, output) {
#'         observeEvent(input$button, {
#'           js$backgroundCol(input$selector, input$col)
#'         })
#'       }
#'     )
#'
#'   # ==============
#'
#'   # Example 3:
#'   # Create an `increment` function that increments the number inside an HTML
#'   # tag (increment by 1 by default, with an optional parameter). Use a separate
#'   # file instead of providing the JS code in a string.
#'
#'   # Create a JavaScript file "myfuncs.js" in a "www/" directory:
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
#'   # And a shiny app that uses the custom function we just defined. Note how
#'   # the arguments can be either passed as named or unnamed, and how default
#'   # values are set if no value is given to a parameter.
#'
#'       library(shiny)
#'       shinyApp(
#'         ui = fluidPage(
#'           useShinyjs(),
#'           extendShinyjs("myfuncs.js", functions = c("increment")),
#'           p(id = "number", 0),
#'           actionButton("add", "js$increment('number')"),
#'           actionButton("add5", "js$increment('number', 5)"),
#'           actionButton("add10", "js$increment(num = 10, id = 'number')")
#'         ),
#'         server = function(input, output) {
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
#'       )
#' }
#' @export
extendShinyjs <- function(script, text, functions) {
  if (missing(script) && missing(text)) {
    errMsg("extendShinyjs: Either `script` or `text` need to be provided.")
  }
  if (!missing(script) && !missing(text)) {
    errMsg("extendShinyjs: Either `script` or `text` need to be provided, but not both.")
  }
  if (missing(functions)) {
    errMsg("extendShinyjs: `functions` argument must be provided.")
  }

  isShinyjsFunction <- functions %in% shinyjsFunctionNames("all")
  if (any(isShinyjsFunction)) {
    errMsg(paste0(
      "extendShinyjs: `functions` argument must not contain any of the ",
      "following function names:\n",
      paste(functions[isShinyjsFunction], collapse = ", ")
    ))
  }

  jsFuncs <- functions

  # add all the given functions to the shinyjs namespace so that they can be
  # called as if they were regular shinyjs functions
  lapply(jsFuncs, function(x) {
    assign(x, jsFunc, js)
  })

  jsCodeFuncs <- jsFuncTemplate(jsFuncs)

  if (!missing(text)) {
    shinyjsContent <- insertHead(
      shiny::tags$script(shiny::HTML(text)),
      shiny::tags$script(shiny::HTML(jsCodeFuncs))
    )
  } else if (!missing(script)) {
    if (is.character(script)) {
      shinyjsContent <- insertHead(
        shiny::tags$script(src = script),
        shiny::tags$script(shiny::HTML(jsCodeFuncs))
      )
    } else if (inherits(script, "html_dependency")) {
      shinyjsContent <- insertHead(
        script,
        shiny::tags$script(shiny::HTML(jsCodeFuncs))
      )
    }
  }

  shiny::tagList(
    shinyjsContent
  )
}


#' Call user-defined JavaScript functions from R
#' @seealso \code{\link[shinyjs]{extendShinyjs}}
#' @export
#' @keywords internal
js <- new.env()
