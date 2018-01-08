# Show a random startup tip
# Copied from ggplot2
.onAttach <- function(...) {
  if (!interactive()) return()

  tips <- c(
    "Need shinyjs help? You can ask any Shiny-related question in the RStudio Community forums:\n\thttps://community.rstudio.com/c/shiny",
    "Don't forget that shinyjs can also be used in Rmd documents!",
    "Watch shinyjs tutorial videos and read the full documentation:\n\thttps://deanattali.com/shinyjs",
    "Find out what's new in shinyjs:\n\thttp://github.com/daattali/shinyjs/releases",
    "Answers to common shinyjs questions can be found in the FAQ:\n\thttps://deanattali.com/shinyjs/help",
    "Need Shiny help? I'm available for consulting:\n\thttp://attalitech.com",
    "Use suppressPackageStartupMessages() to eliminate package startup messages.",
    "Stackoverflow is a great place to get help:\n\thttp://stackoverflow.com/tags/shinyjs",
    "Find out advanced usage of shinyjs:\n\thttps://deanattali.com/shinyjs/advanced",
    "Love shinyjs? Consider donating:\n\thttps://www.paypal.me/daattali/50",
    "See a demo of shinyjs and learn more:\n\thttps://deanattali.com/shinyjs/demo",
    "You can use shinyjs to call your own JavaScript functions:\n\thttps://deanattali.com/shinyjs/extend",
    "Learn different usages for shinyjs and other Shiny tricks:\n\thttps://deanattali.com/blog/advanced-shiny-tips"
  )

  tip <- sample(tips, 1)
  packageStartupMessage(tip)
}