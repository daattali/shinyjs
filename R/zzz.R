# Show a random startup tip
# Copied from ggplot2
.onAttach <- function(...) {
  if (!interactive()) return()

  tips <- c(
    "Need shinyjs help? You can ask any Shiny-related question in the RStudio Community forums:\n\thttps://community.rstudio.com/c/shiny",
    "Don't forget that shinyjs can also be used in Rmd documents!",
    "Watch shinyjs tutorial videos and read the full documentation:\n\thttps://deanattali.com/shinyjs/",
    "Find out what's new in shinyjs:\n\thttps://github.com/daattali/shinyjs/releases",
    "Answers to common shinyjs questions can be found in the FAQ:\n\thttps://deanattali.com/shinyjs/help",
    "Need Shiny help? I'm available for consulting:\n\thttps://attalitech.com",
    "Use suppressPackageStartupMessages() to eliminate package startup messages.",
    "Stackoverflow is a great place to get help:\n\thttps://stackoverflow.com/tags/shinyjs",
    "Find out advanced usage of shinyjs:\n\thttps://deanattali.com/shinyjs/advanced",
    "Love shinyjs? Consider donating:\n\thttps://github.com/sponsors/daattali",
    "See a demo of shinyjs and learn more:\n\thttps://deanattali.com/shinyjs/demo",
    "You can use shinyjs to call your own JavaScript functions:\n\thttps://deanattali.com/shinyjs/extend",
    "Learn different usages for shinyjs and other Shiny tricks:\n\thttps://deanattali.com/blog/advanced-shiny-tips"
  )

  tip <- sample(tips, 1)
  packageStartupMessage(tip)
}

.onLoad <- function(libname, pkgname) {
  shiny::registerInputHandler("shinyjspkg", function(data, ...) {
    session <- getSession()
    ns <- data$ns
    code <- data$code
    shinyjs::hide(paste0(ns, "runcode_error"))
    tryCatch(
      eval(parse(text = code)),
      error = function(err) {
        shinyjs::html(paste0(ns, "runcode_errorMsg"), as.character(err$message))
        shinyjs::show(paste0(ns, "runcode_error"), anim = TRUE, animType = "fade")
      }
    )
  }, force = TRUE)
}

.onUnload <- function(libpath) {
  shiny::removeInputHandler("shinyjspkg")
}
