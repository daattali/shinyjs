examples <- c(
  'toggle("btn")',
  'toggle("btn", TRUE, "fade", 2)',
  'toggle(id = "btn", anim = TRUE, time = 1, animType = "slide")',
  'hide("btn")',
  'show("btn")',
  'alert(R.Version())',
  'onclick("btn", alert(date()))',
  'disable("btn")',
  'enable("btn")',
  'innerHTML("btn", "What a nice button")',
  'innerHTML("btn", paste("The time is", date()))',
  'addClass("btn", "green")',
  'removeClass("btn", "green")',
  'toggleClass("btn", "green")'
)
examplesNamed <- seq_along(examples)
names(examplesNamed) <- examples
